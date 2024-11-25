{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N-,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$WARN SYMBOL_DEPRECATED ON}
{$WARN SYMBOL_LIBRARY ON}
{$WARN SYMBOL_PLATFORM ON}
{$WARN SYMBOL_EXPERIMENTAL ON}
{$WARN UNIT_LIBRARY ON}
{$WARN UNIT_PLATFORM ON}
{$WARN UNIT_DEPRECATED ON}
{$WARN UNIT_EXPERIMENTAL ON}
{$WARN HRESULT_COMPAT ON}
{$WARN HIDING_MEMBER ON}
{$WARN HIDDEN_VIRTUAL ON}
{$WARN GARBAGE ON}
{$WARN BOUNDS_ERROR ON}
{$WARN ZERO_NIL_COMPAT ON}
{$WARN STRING_CONST_TRUNCED ON}
{$WARN FOR_LOOP_VAR_VARPAR ON}
{$WARN TYPED_CONST_VARPAR ON}
{$WARN ASG_TO_TYPED_CONST ON}
{$WARN CASE_LABEL_RANGE ON}
{$WARN FOR_VARIABLE ON}
{$WARN CONSTRUCTING_ABSTRACT ON}
{$WARN COMPARISON_FALSE ON}
{$WARN COMPARISON_TRUE ON}
{$WARN COMPARING_SIGNED_UNSIGNED ON}
{$WARN COMBINING_SIGNED_UNSIGNED ON}
{$WARN UNSUPPORTED_CONSTRUCT ON}
{$WARN FILE_OPEN ON}
{$WARN FILE_OPEN_UNITSRC ON}
{$WARN BAD_GLOBAL_SYMBOL ON}
{$WARN DUPLICATE_CTOR_DTOR ON}
{$WARN INVALID_DIRECTIVE ON}
{$WARN PACKAGE_NO_LINK ON}
{$WARN PACKAGED_THREADVAR ON}
{$WARN IMPLICIT_IMPORT ON}
{$WARN HPPEMIT_IGNORED ON}
{$WARN NO_RETVAL ON}
{$WARN USE_BEFORE_DEF ON}
{$WARN FOR_LOOP_VAR_UNDEF ON}
{$WARN UNIT_NAME_MISMATCH ON}
{$WARN NO_CFG_FILE_FOUND ON}
{$WARN IMPLICIT_VARIANTS ON}
{$WARN UNICODE_TO_LOCALE ON}
{$WARN LOCALE_TO_UNICODE ON}
{$WARN IMAGEBASE_MULTIPLE ON}
{$WARN SUSPICIOUS_TYPECAST ON}
{$WARN PRIVATE_PROPACCESSOR ON}
{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_CAST OFF}
{$WARN OPTION_TRUNCATED ON}
{$WARN WIDECHAR_REDUCED ON}
{$WARN DUPLICATES_IGNORED ON}
{$WARN UNIT_INIT_SEQ ON}
{$WARN LOCAL_PINVOKE ON}
{$WARN MESSAGE_DIRECTIVE ON}
{$WARN TYPEINFO_IMPLICITLY_ADDED ON}
{$WARN RLINK_WARNING ON}
{$WARN IMPLICIT_STRING_CAST ON}
{$WARN IMPLICIT_STRING_CAST_LOSS ON}
{$WARN EXPLICIT_STRING_CAST OFF}
{$WARN EXPLICIT_STRING_CAST_LOSS OFF}
{$WARN CVT_WCHAR_TO_ACHAR ON}
{$WARN CVT_NARROWING_STRING_LOST ON}
{$WARN CVT_ACHAR_TO_WCHAR ON}
{$WARN CVT_WIDENING_STRING_LOST ON}
{$WARN NON_PORTABLE_TYPECAST ON}
{$WARN XML_WHITESPACE_NOT_ALLOWED ON}
{$WARN XML_UNKNOWN_ENTITY ON}
{$WARN XML_INVALID_NAME_START ON}
{$WARN XML_INVALID_NAME ON}
{$WARN XML_EXPECTED_CHARACTER ON}
{$WARN XML_CREF_NO_RESOLVE ON}
{$WARN XML_NO_PARM ON}
{$WARN XML_NO_MATCHING_PARM ON}
{$WARN IMMUTABLE_STRINGS OFF}
unit FAMainForm;

{$I ASIOVST.INC}

interface

uses
  {$IFDEF FPC} LCLType, LResources, Buttons, {$ELSE} Windows, {$ENDIF}
  Forms, Classes, Controls, StdCtrls,dialogs,ASIO, DASIOHost, DAVDComplex, DAVDCommon,DAVDBufferMathAsm,
   blcksock, Synautil,membuf,workTcpthread,ConManager,CodecU, Vcl.ExtCtrls,graphics,
   system.diagnostics;

type
  Tstatus=(stop,play);
const
  DEF_SIZE_SOK=240;
  DEF_SAMPLE_RATE=48000;
  //separate_thread=false;
type
  TFAmainF = class(TForm)
    Bt_CP: TButton;
    Bt_Play: TButton;
    DriverCombo: TComboBox;
    OutputChannelBox: TComboBox;
    ASIOHost: TASIOHost;
    LbFreq: TLabel;
    Lb_Drivername: TLabel;
    Lb_Channels: TLabel;
    Label3: TLabel;
    InputChannelBox: TComboBox;
    EditIPOut: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    EditIpIn: TEdit;
    EditPortOut: TEdit;
    Label6: TLabel;
    Memo1: TMemo;
    CBEnviar: TCheckBox;
    CBrecibir: TCheckBox;
    Label7: TLabel;
    EditPortSelf: TEdit;
    CBloopback: TCheckBox;
    EscucharBut: TButton;
    ConectarBut: TButton;
    DesconBut: TButton;
    PanelState: TPanel;
    LabelStatus: TLabel;
    Timer1: TTimer;
    CBcopyDirect: TCheckBox;
    CBExtLoopbak: TCheckBox;
    CBCompress: TCheckBox;
    CBBitRate: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    CBProtocol: TComboBox;
    CBSepThread: TCheckBox;
    Bt_Reset: TButton;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DriverComboChange(Sender: TObject);
    procedure OutputChannelBoxChange(Sender: TObject);
    procedure Bt_CPClick(Sender: TObject);
    procedure Bt_PlayClick(Sender: TObject);
    procedure ASIOHostBufferSwitch32Complex(Sender: TObject; const InBuffer, OutBuffer: TAVDArrayOfSingleDynArray);
    procedure InputChannelBoxChange(Sender: TObject);
    procedure DesconButClick(Sender: TObject);
    procedure EscucharButClick(Sender: TObject);
    procedure ConectarButClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure CBloopbackClick(Sender: TObject);
    procedure CBExtLoopbakClick(Sender: TObject);
    procedure CBCompressClick(Sender: TObject);
    procedure CBBitRateChange(Sender: TObject);
    procedure CBProtocolChange(Sender: TObject);
    procedure CBSepThreadClick(Sender: TObject);
    procedure Bt_ResetClick(Sender: TObject);

  private
    MbOut,MbIn:TmemBuf;
    MemBufsizeTot,FBsizeSock,FBsizeAudio:integer;
    workThread:TWorkThread;
    ConManager,CMExt:TConManager;
    FCodec:Tcodec;
    FskipedIn:integer;
    FTipo:CMConType;
    Proctime:int64;
    separate_thread:boolean;
    fOutChanBase,fInChanBase : Byte;
    stopw:TStopwatch;
    Fstatus:Tstatus;
    procedure SendBuffer(InBuf: TAVDArrayOfSingleDynArray);
    procedure GetBuffer(OutBuf: TAVDArrayOfSingleDynArray);
    procedure SetBufers(Crear:boolean);
    procedure SetThread(Crear:boolean);
    procedure setenables;
    procedure idleap(Sender: TObject; var Done: Boolean);

  public


  end;

var
  FAmainF        : TFAmainF;

implementation

{$IFNDEF FPC}
{$R *.DFM}
{$ENDIF}

uses
  SysUtils, Inifiles;

procedure threadUpdate(s:string);
begin
  FAmainF.Memo1.Lines.Add(s);
end;


procedure TFAmainF.FormCreate(Sender: TObject);
begin
 //AsioHost.
 DriverCombo.Items := ASIOHost.DriverList;
 if DriverCombo.Items.Count = 0 then
  try
   raise Exception.Create('No ASIO Driver present! Application Terminated!');
  except
   Application.Terminate;
  end;



 // and make sure all controls are enabled or disabled
 with TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'FrankAudio.INI') do
  try
   Left := ReadInteger('Layout', 'Audio Left', Left);
   Top := ReadInteger('Layout', 'Audio Top', Top);
   DriverCombo.ItemIndex := ReadInteger('Audio', 'Asio Driver', -1);
   if DriverCombo.ItemIndex >= 0 then DriverComboChange(DriverCombo);
   OutputChannelBox.ItemIndex := ReadInteger('Audio', 'OutputChannels', 0);
   InputChannelBox.ItemIndex := ReadInteger('Audio', 'InputChannels', 0);
   CBBitRate.ItemIndex:=ReadInteger('Audio', 'BitRate',2);
   CBProtocol.ItemIndex:=ReadInteger('Audio', 'Protocol', 1);
   CBCompress.Checked:=ReadBool('Audio', 'Compress', true);
   //CBExtLoopbak.Checked:=ReadBool('Audio', 'ExLoop', false);
   CBEnviar.Checked:=ReadBool('Coms', 'Enviar', true);
   CBrecibir.Checked:=ReadBool('Coms', 'Recibir', true);
   EditIpIn.Text:=ReadString('Coms', 'IPin', '127.0.0.1');
   EditIPOut.Text:=ReadString('Coms', 'IPout','127.0.0.1');
   EditPortSelf.Text:=ReadString('Coms', 'Portin','22134');
   EditPortOut.Text:=ReadString('Coms', 'PortOut', '22134');
  finally
   Free;
  end;

 

 //bufers size
 FBsizeSock:=DEF_SIZE_SOK;
 MemBufsizeTot:=32*FBsizeSock;


 //conection manager
 ConManager:=TConManager.Create;

 //canales de entrada y salida
 InputChannelBoxChange(self);
 OutputChannelBoxChange(self);

 //fstatus
 Fstatus:=stop;

 //FTipo:=UDP;
 CBProtocolChange(self);

 //codec
 CBCompressClick(self);

 //echo externo
 CBExtLoopbakClick(self);

 //tread separada o call directo
 CBSepThreadClick(self);

 Application.OnIdle:=idleap;
 stopw:=TStopwatch.Create;
end;

procedure TFAmainF.DesconButClick(Sender: TObject);
begin
  ConManager.Disconnect;
end;

procedure TFAmainF.DriverComboChange(Sender: TObject);
var
 i : Integer;
begin
 Bt_CP.Enabled := False;
 Bt_Play.Enabled := False;
 DriverCombo.ItemIndex := DriverCombo.Items.IndexOf(DriverCombo.Text);
 if DriverCombo.ItemIndex >= 0 then
  begin
   ASIOHost.DriverIndex := DriverCombo.ItemIndex;

   //llenar combo de input
   InputChannelBox.Clear;
   for i := 0 to (ASIOHost.InputChannelCount div 2) - 1 do
    InputChannelBox.Items.Add(ASIOHost.InputChannelInfos[2 * i].name + ' / ' +
                              ASIOHost.InputChannelInfos[2 * i+1].name);
   //llenar combo de output
   OutputChannelBox.Clear;
   for i := 0 to (ASIOHost.OutputChannelCount div 2) - 1 do
    OutputChannelBox.Items.Add(ASIOHost.OutputChannelInfos[2 * i].name + ' / ' +
                              ASIOHost.OutputChannelInfos[2 * i+1].name);

   //comprobar que admite el samplerate
   if (ASIOHost.CanSampleRate(DEF_SAMPLE_RATE)<>ASE_OK) then
     raise Exception.Create('La placa de sonido no soporta el samplerate '+DEF_SAMPLE_RATE.ToString);

   ASIOHost.SampleRate:=DEF_SAMPLE_RATE;

   //guardar la eleccion de driver
   with TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'FrankAudio.INI') do
    try
     WriteInteger('Audio', 'Asio Driver', DriverCombo.ItemIndex);
    finally
     Free;
    end;



   Bt_CP.Enabled := True;
   Bt_Play.Enabled := True;
   InputChannelBox.ItemIndex := 0;
   OutputChannelBox.ItemIndex := 0;


  end;
end;

procedure TFAmainF.Bt_ResetClick(Sender: TObject);
var
  bin,bout:integer;
begin
  if Fstatus=play then
    Bt_PlayClick(self);
  bin:=InputChannelBox.ItemIndex;
  bout:=OutputChannelBox.ItemIndex;
  ASIOHost.Reset;
  DriverComboChange(self);
  //restaurar
  InputChannelBox.ItemIndex:=bin;
  OutputChannelBox.ItemIndex:=bout;

end;

procedure TFAmainF.EscucharButClick(Sender: TObject);
begin
  ConManager.selfIp:=EditIpIn.Text;
  ConManager.SelfPort:=EditPortSelf.Text;
  ConManager.LoopBack:=CBloopback.Checked;
  ConManager.tipo:=FTipo;
  ConManager.listen;
end;

procedure TFAmainF.Bt_CPClick(Sender: TObject);
begin
 ASIOHost.ControlPanel;
end;

procedure TFAmainF.FormDestroy(Sender: TObject);
begin
  if ASIOHost.Active then begin

   ASIOHost.Active := False; // Stop Audio
   SetThread(false);
   SetBufers(false);
  end;

 with TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'FrankAudio.INI') do
  try
   WriteInteger('Layout', 'Audio Left', Left);
   WriteInteger('Layout', 'Audio Top', Top);
   WriteInteger('Audio', 'ASIO Driver', DriverCombo.ItemIndex);
   WriteInteger('Audio', 'OutputChannels', OutputChannelBox.ItemIndex);
   WriteInteger('Audio', 'InputChannels', InputChannelBox.ItemIndex);
   WriteInteger('Audio', 'BitRate', CBBitRate.ItemIndex);
   WriteInteger('Audio', 'Protocol', CBProtocol.ItemIndex);
   WriteBool('Audio', 'Compress', CBCompress.Checked);
   WriteBool('Audio', 'ExLoop', CBExtLoopbak.Checked);
   WriteBool('Coms', 'Enviar', CBEnviar.Checked);
   WriteBool('Coms', 'Recibir', CBrecibir.Checked);
   WriteString('Coms', 'IPin', EditIpIn.Text);
   WriteString('Coms', 'IPout', EditIPOut.Text);
   WriteString('Coms', 'Portin', EditPortSelf.Text);
   WriteString('Coms', 'PortOut', EditPortOut.Text);

  finally
   Free;
  end;
end;

procedure TFAmainF.SetThread(Crear:boolean);
var
  es:TWTe_s;

begin
  es:=entrada;
  if CBrecibir.Checked then  es:=entrada;
  if CBEnviar.Checked then  es:=salida;
  if CBrecibir.Checked and CBenviar.Checked then  es:=both;
  if CBloopback.Checked then  es:=loopback;

  if crear then begin
    workThread := TWorkThread.Create(True); // With the True parameter it doesn't start automatically
    if Assigned(workThread.FatalException) then
      raise workThread.FatalException;

    workThread.FreeOnTerminate:=true;
    // Here the code initialises anything required before the threads starts executing
    workThread.statusCallback:=@threadUpdate;

    //entrada , salida o ambos
    workThread.e_s:=es;

    //buffers circulares
    workThread.Mbin:=MbIn;
    workThread.MbOut:=MbOut;

    //tamaño del bloque de socket
    workThread.BsizeSock:=FBsizeSock;

    if es<>loopback then begin
     //socket
      //blcksize:=BbOut.blockSize*sizeof(sample);
      //ConManager.LoopbackBlockSize:=blcksize;
      //ConManager.LoopbackBlockSize:=FBsizeSock*SizeOf(sample);
      workThread.Sock:=ConManager.Sock;


    end;
    //ponemos a la tarea el estado del codec, puede ser nil
    workThread.codec:=FCodec;

    workThread.Priority:=tpNormal;

    workThread.init;
    //arrancar
    if separate_thread then
      workThread.Start;

  end else begin
   try
    //marcar para terminar
    if Assigned(workThread) and separate_thread then begin
        workThread.Terminate;
        sleep(250);
   end else begin
     workThread.done;
   end;
   except
    MessageBox(self.WindowHandle ,'errror cerrando thread','error',0);
   end;
   workThread:=nil;

  end;
end;

procedure TFAmainF.SetBufers(Crear:boolean);
begin
  FBsizeAudio:=ASIOHost.BufferSize;
  if crear then begin
    MbIn:=TmemBuf.create(MemBufsizeTot);
    MbOut:=TmemBuf.create(MemBufsizeTot);
    FskipedIn:=0;
  end else begin
    if Assigned(MbIn) then
      MbIn.Destroy;
    if Assigned(MbOut) then
      MbOut.Destroy;
  end;

end;





procedure TFAmainF.CBCompressClick(Sender: TObject);
begin
  if CBCompress.Checked then begin
   try
      FCodec := Tcodec.Create;
      FCodec.frameSize := FBsizeSock;
      FCodec.SampleRate := round(ASIOHost.SampleRate);
      // codec.BitRate:=16000;
      CBBitRateChange(self);
      // iniciar
      FCodec.init;
    except
      on E: Exception do
      begin
        FCodec.Free;
        FCodec := nil;
        ShowMessage('There was an error: ' + E.Message);
        CBCompress.Enabled := False;
        CBCompress.Checked := False;
      end;

    end;
  end else  begin
    if Fcodec<>nil then
      FCodec.Destroy;
    Fcodec:=nil;
  end;
end;

procedure TFAmainF.CBExtLoopbakClick(Sender: TObject);
begin
  //loopback externo, como un echo thread distinto
  if CBExtLoopbak.Checked then  begin
   CMExt:=TConManager.Create;
   CMExt.selfIp:=EditIpIn.Text;
   CMExt.SelfPort:=EditPortSelf.Text;
   CMExt.tipo:=FTipo;
   CMExt.LoopBack:=True;
   CMExt.LoopbackBlockSize:=FBsizeSock*sizeof(sample);
   CMext.listen;
  end else
   if assigned(CMExt)  then begin
     CMExt.Disconnect;
     sleep(200);
     CMExt.Destroy;
     CMExt:=nil;
   end;
end;

procedure TFAmainF.CBloopbackClick(Sender: TObject);
begin
   ConManager.LoopbackBlockSize:=FBsizeSock*sizeof(sample);
end;

procedure TFAmainF.CBProtocolChange(Sender: TObject);
var
  newtipo:CMConType;
begin
  if CBProtocol.Items[CBProtocol.ItemIndex]='TCP' then
    newtipo:=TCP
  else
    newtipo:=UDP;
  if newtipo=FTipo then  exit;
  FTipo:=newtipo;
  ConManager.tipo:=newtipo;
end;

procedure TFAmainF.CBSepThreadClick(Sender: TObject);
begin
  separate_thread:=CBSepThread.Checked;
end;

procedure TFAmainF.CBBitRateChange(Sender: TObject);
begin
  if FCodec<>nil then
    FCodec.bitRate:=1000*(CBBitRate.Items[CBBitRate.ItemIndex].ToInteger);

end;

procedure TFAmainF.ConectarButClick(Sender: TObject);
begin
  ConManager.remoteIp:=EditIPOut.Text;
  ConManager.RemotePort:=EditPortOut.Text;
  ConManager.tipo:=FTipo;
  ConManager.connect;
end;

procedure TFAmainF.InputChannelBoxChange(Sender: TObject);
begin
  fInChanBase := InputChannelBox.ItemIndex * 2;
end;


procedure TFAmainF.OutputChannelBoxChange(Sender: TObject);
begin
 fOutChanBase := OutputChannelBox.ItemIndex * 2;
end;

procedure TFAmainF.setenables;
 var
  estado:CMestado;
  sStatus:string;
 begin
   sStatus:='';
   if ConManager=nil then estado:=inicio
   else estado:=ConManager.Estado;

   EscucharBut.Enabled:=estado in [inicio];
   ConectarBut.Enabled:=(estado in [inicio,escuchando]) and (fstatus=stop);
   DesconBut.Enabled:=estado in [conectado,escuchando,error];
   CBProtocol.Enabled:=not (estado=conectado);
   CBCompress.Enabled:=(fstatus<>play);
   Bt_CP.Enabled:=Fstatus=stop;

   with PanelState do
   case estado of
     inicio: begin
       Caption:='Desconectado';
       PanelState.color:=clRed;
     end;
     escuchando:begin
       Caption:='Escuchando';
       PanelState.color:=clGray;
     end;
     conectado:begin
       Caption:='Conectado';
       PanelState.color:=clGreen;
     end;
     error:begin
       Caption:='Error';
       PanelState.color:=clFuchsia;
       sStatus:='Error: '+ConManager.lasterror;
     end;
   end;


   case fstatus of
     play: begin
       Bt_Play.Caption:='Stop Audio';
     end;
     stop:begin
       Bt_Play.Caption:='Start Audio';
     end;
   end;



   Bt_Play.Enabled:=estado in [conectado,inicio];
   LabelStatus.Caption:=sStatus;
 end;

{************************Play**********************************}
procedure TFAmainF.Bt_PlayClick(Sender: TObject);
begin
 if Fstatus=stop then
  begin
      //if (ConManager.Estado=conectado) or Cbloopback.checked  then begin
   SetBufers(true);
   SetThread(true);

   Fstatus:=play;
   ASIOHost.Active := True; // Start Audio
   Memo1.Lines.Add('Samplerate= '+ASIOHost.SampleRate.ToString +' Buffersize: '+ ASIOHost.BufferSize.ToString );
  end else begin
   ASIOHost.Active := False; // Stop Audio
   SetThread(false);
   SetBufers(false);
   Fstatus:=stop;
  end;
end;

procedure TFAmainF.idleap(Sender: TObject; var Done: Boolean);
 begin
   setenables;
   done:=true;
 end;

 procedure TFAmainF.Timer1Timer(Sender: TObject);
 begin
   //no funciona
   //checkConnect;
   setenables;
   if (workThread<>nil) then
     Memo1.Lines.Add('Prc Time here:'+Proctime.ToString+' Proctime Thread:'+workThread.Proctime.ToString+'   NB In: ' + MbIn.used.ToString + ' Out: ' + MbOut.used.ToString);
 end;

{**********************************************************************
************************* HERE ****************************************
***********************************************************************}

procedure TFAmainF.SendBuffer(InBuf: TAVDArrayOfSingleDynArray);
var
 i:integer;
 p:Pblock;
 short:boolean;
begin
  short:= sizeof(sample)=2;

    if separate_thread then EnterCriticalSection(CritSect);
      //añadir un bloque al buffer circular
      p:=MbOut.PutMem(FBsizeAudio);

      if  p<>nil then begin
        if short then
           for I := 0 to FBsizeAudio-1 do
               P[I]:=round(Inbuf[fInChanBase,i]*32766) //convertir a shortint
        else
           for I := 0 to FBsizeAudio-1 do
              p[I]:=Inbuf[fInChanBase,i]; //copiar los datos
           // Move(InBuf[fInChanBase,0],P[0], BsizeAudio * SizeOf(sample));
      end;
    if separate_thread then LeaveCriticalSection(CritSect);
end;

procedure TFAmainF.GetBuffer(OutBuf: TAVDArrayOfSingleDynArray);
var
 i:integer;
 p:Pblock;
 short:boolean;

begin
  short:= sizeof(sample)=2;

  //Purgar el bufer si hay mas de tres bloques
  //leer el bloque que se va a entregar
  if separate_thread then EnterCriticalSection(CritSect);
   repeat
    p:=MbIn.GetMem(FBsizeAudio);
   until Mbin.used<4*FBsizeAudio;
  if separate_thread then LeaveCriticalSection(CritSect);
    if p<>nil then begin
      if short then
        for i := 0 to FBsizeAudio-1 do
          OutBuf[fOutChanBase,i]:=p[i]/32767 //convertir a single
      else
          for i := 0 to FBsizeAudio-1 do
            OutBuf[fOutChanBase,i]:=p[i]; //copiar los datos
          //Move(P[0],OutBuf[fOutChanBase,0], BsizeAudio * SizeOf(sample));
    end
    // else silencio, aunque puede venir ya silenciado
    //   ClearArrays(Outbuf,fOutChanBase+2,BsizeAudio); //se llena a silencio

end;



Procedure TFAmainF.ASIOHostBufferSwitch32Complex(Sender: TObject; const InBuffer,
  OutBuffer: TAVDArrayOfSingleDynArray);
var
  nchan:integer;
label
  fin;
begin

 FBsizeAudio:=ASIOHost.BufferSize;
 nchan:=2;//ASIOHost.OutputChannelCount;

 if CBcopyDirect.Checked then begin
   //copia la entrada en la salida
   //CopyArrays(InBuffer,OutBuffer,nchan,bsize);
   Move(Inbuffer[fInChanBase,0],OutBuffer[fOutChanBase,0], FBsizeAudio * SizeOf(sample));
   if nchan=2 then
     Move(Inbuffer[fInChanBase+1,0],OutBuffer[fOutChanBase+1,0], FBsizeAudio * SizeOf(sample));
   exit;
 end;

 if   (ConManager.Estado=conectado) or cbloopback.checked then begin
  //tics:=GetTickCount();
  stopw.Reset;
  stopw.Start;

  if CBEnviar.Checked then
     SendBuffer(InBuffer);

  //procesar comunicaciones
  if (not separate_thread) and (workThread<>nil)  then
     workthread.processFrames;

  //lo primero llenamos el buffer de salida
  if CBrecibir.Checked then
      GetBuffer(OutBuffer);


  stopw.stop;
  // tics2:=GetTickCount();

   Proctime:=(1000000*stopw.ElapsedTicks div stopw.Frequency);

 end;
end;

{$IFDEF FPC}
initialization
  {$i AsioDemoForm.lrs}
{$ENDIF}

end.
