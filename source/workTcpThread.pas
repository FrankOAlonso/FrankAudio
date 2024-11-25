
unit workTcpThread;



interface

uses
  Classes, SysUtils,MemBuf,codecU,blcksock,Synautil,windows,system.diagnostics;
const
  debug=false;

type
  TWTe_s = (entrada,salida,both,loopback);

  TStatusCallback = Procedure(s:string);

  { TWorkThread }
  TWorkThread = class(TThread)
  private
    FStatusText: string;
    FMbin,FMbout:TMemBuf;
    FstatusCallback:TStatusCallback;
    FSock:TBlockSocket;
    Fe_s:TWTe_s;
    FBsizeSock:integer;
    Fcodec:Tcodec;
    PbTemp: Pblock;
    Pbytes: ^byte;
    stopw:TStopwatch;
    isExec:boolean;
    procedure ShowStatus;
  protected
    procedure comunicate(s:string);
    procedure log(s:string);
  public
    Proctime:integer;
    tics,tics2:Cardinal;
    procedure processFrames;
    procedure init;
    procedure Execute; override;
    constructor Create(CreateSuspended: boolean);
    procedure done;
    procedure terminate;
    property statusCallback :TStatusCallback write FstatusCallback;
    property Mbin:TMemBuf read FMbin write FMbin;
    property MbOut:TMemBuf read FMbout write FMbout;
    property e_s:TWTe_s read Fe_s write Fe_s;
    property Sock:TBlockSocket read FSock write FSock;
    property BsizeSock: integer read FBsizeSock write FBsizeSock;
    property codec: TCodec read Fcodec write Fcodec;
  end;
var
  CritSect : TRTLCriticalSection;

implementation
var
  logfile:Text;

{ TWorkThread }
procedure TWorkThread.log(s:string);
begin
  writeln(logfile,s);
end;

procedure TWorkThread.ShowStatus;
// this method is only called by Synchronize(@ShowStatus) and therefore
// executed by the main thread
// The main thread can access GUI elements, for example Form1.Caption.
begin
  if Assigned(FstatusCallback) then
    FstatusCallback(fStatusText);
end;

procedure TWorkThread.comunicate(s:string);
begin
 if Assigned(FstatusCallback) then begin
   fStatusText := s;
   Synchronize(Showstatus);
 end;
end;


procedure TWorkThread.processFrames;
const
  recdelay = 0;
var
  Pbout: Pblock;
  nb, totSamp, totbytes: integer;
  finrec, sending: boolean;
  Pdef, poutdef: pointer;
begin
  stopw.Reset;
  stopw.Start;
  if Fe_s = loopback then
  begin
    repeat
      if isExec then EnterCriticalSection(CritSect);
      Pbout := MbOut.Getmem(FBsizeSock);
      finrec := (Pbout = nil);
      if not finrec then
      begin

        if Fcodec <> nil then
        begin
          // si hay codec, codificamos y decodificamos
          totbytes := Fcodec.encode(Pbout^, Pbytes^);
          totSamp := Fcodec.decode(Pbytes^, totbytes, PbTemp^);
          Pdef := PbTemp;
        end
        else
        begin
          Pdef := Pbout;
          totSamp := FBsizeSock;
        end;
        if totSamp > 0 then
          FMbin.PutMemCopy(totSamp, Pdef);
      end;
      if isExec then LeaveCriticalSection(CritSect);
    until (finrec);
  end
  else
    if FSock <> nil then begin

      // entrada
      if Fe_s in [entrada, both] then
      begin
        finrec := false;
        // esperar a lectura
        while not finrec do
        begin

          begin
            // leer del socket
            nb := FSock.RcvBlockBuf(Pbytes, recdelay);
            finrec := (FSock.lasterror <> 0) or (nb <= 0) or (nb > (FBsizeSock * sizeof(sample)));
            // si se ha leido
            if not finrec then
            begin
              // calcular el origen y el tamaño a guardar
              if Fcodec <> nil then
              begin
                totSamp := Fcodec.decode(Pbytes^, nb, PbTemp^);
                Pdef := PbTemp;
              end
              else
              begin
                Pdef := Pbytes;
                totSamp := nb div sizeof(sample);
              end;
              if isExec then EnterCriticalSection(CritSect);
              // alocar memoria y copiar
                  FMbin.PutMemCopy(totSamp, Pdef);
              if isExec then LeaveCriticalSection(CritSect);
            end;
          end;

        end;

      end;

      // salida
      if Fe_s in [salida, both] then
      begin
        sending := true;
        while sending do
        begin
          if isExec then EnterCriticalSection(CritSect);
          Pbout := FMbout.Getmem(FBsizeSock);
          if isExec then LeaveCriticalSection(CritSect);
          sending := Pbout <> nil;
          if sending then
          begin

            // segun si hay codec o no, calcular el origen y el tamño a mandar
            if Fcodec <> nil then
            begin
              totbytes := Fcodec.encode(Pbout^, Pbytes^);
              poutdef := Pbytes;
            end
            else
            begin
              poutdef := Pbout;
              totbytes := FBsizeSock * sizeof(sample);
            end;

            // mandar
            FSock.SendBlockBuf(poutdef, totbytes);
          end;
        end;
      end;
    end;
   stopw.stop;
   Proctime:=(1000000*stopw.ElapsedTicks div stopw.Frequency);
end;

procedure TWorkThread.Execute;
begin
  isExec:=true;
  FStatusText := 'TWorkThread Running ...';
  // bucle de ejecucion
  while (not Terminated) and (true { any condition required } ) do
  begin
    processFrames;
    yield;
  end;
end;



constructor TWorkThread.Create(CreateSuspended: boolean);
begin
  FstatusCallback:=nil;
  FreeOnTerminate := True;
  Fcodec:=nil;
  stopw:=TStopwatch.Create;
  isExec:=false;
  inherited Create(CreateSuspended);

end;
procedure TWorkThread.done;
begin
  //liberar los buffers
  if PbTemp<>nil then
    FreeMemory(PbTemp);
  if Pbytes<>nil then
    FreeMemory(Pbytes);
end;

procedure TWorkThread.init;
begin
  // tamaño en bytes del bloque del sock
  //FblckSize := FBsizeSock * sizeof(sample);

  // buffer temporal
  PbTemp := GetMemory(FBsizeSock * sizeof(sample));
  Pbytes := Getmemory(FBsizeSock * sizeof(sample));


  // Buscar los Mem buffers
  if ((Fe_s in [salida, both]) and (not Assigned(FMbout))) or
    ((Fe_s in [entrada, both]) and (not Assigned(FMbin))) then
  begin
    raise Exception.Create('Error creando work thread Buffers no asignados');
    terminate;
  end;


end;

 procedure TWorkThread.terminate;
 begin
  inherited;
  //liberar la memoria
  sleep(100);
  done;
  //FreeMemory(PbTemp);
  //FreeMemory(Pbytes);

 end;


initialization
  InitializeCriticalSection(CritSect);
  if debug then begin
    AssignFile(logfile,'result.log');
    Rewrite(logfile);
  end;

finalization
  DeleteCriticalSection(CritSect);
  if debug then begin
    Close(logfile);
  end;
end.
