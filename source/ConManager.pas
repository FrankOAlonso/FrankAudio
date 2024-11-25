unit ConManager;

interface

uses
  classes, sysutils, blcksock, Synautil, synsock;

const
  MAX_BLOCK_SIZE = 16384; // 16 kbytes

type
  CMestado = (inicio, escuchando, conectado, error);
  CMConType = (TCP, UDP);
  TConCallbk = Procedure(Sock: TSocket) of object;
  TErrCallbk = Procedure(serror: string) of object;

  { ********************* TListenThread ************************************** }
  { Tread para escuchar conexiones }
  TListenThread = class(TThread)
  private
    LSock: TBlockSocket;
    Csock: TSocket;
    lisIP, lisPort: string;
    Ftipo: CMConType;
    procedure Notificar;
  public
    ccb: TConCallbk;
    errcb: TErrCallbk;
    Constructor Create(ip, port: string; concallback: TConCallbk;
      errCallback: TErrCallbk);
    Destructor Destroy; override;
    procedure Execute; override;
  end;

  { ********************* TEchoThrd ************************************** }

  TEchoThrd = class(TThread)
  private
    Sock: TBlockSocket;
    Csock: TSocket;
    BlckSize: Integer;
    Ftipo: CMConType;
  public
    Constructor Create(hsock: TSocket; bs: TBlockSocket; tipo: CMConType;
      BSize: Integer);
    procedure Execute; override;
    function isconnected: boolean;
  end;

  { ********************* TConManager ************************************** }
  { Manejador de conexiones }
  TConManager = class(TObject)
  private
    FremoteIp, FselfIP, FRemotePort, FSelfPort: string;
    FSock: TBlockSocket;
    FEstado: CMestado;
    FLasterror: string;
    FLoopBack: boolean;
    FLoopBackBlockSize: Integer;
    FechoThread: TEchoThrd;
    FLisThread: TListenThread;
    Ftipo: CMConType;
    procedure Reset;
    function getIsconected: boolean;

  protected
    Procedure concallback(Sock: TSocket);
    Procedure errCallback(serror: string);
    procedure setestado(e: CMestado);
    procedure setTipo(tip: CMConType);

  public
    constructor Create;
    destructor Destroy;override;
    procedure listen;
    procedure connect;
    procedure Disconnect;


    property remoteIp: string read FremoteIp write FremoteIp;
    property selfIp: string read FselfIP write FselfIP;
    property RemotePort: string read FRemotePort write FRemotePort;
    property SelfPort: string read FSelfPort write FSelfPort;
    property Estado: CMestado read FEstado write setestado;
    property Sock: TBlockSocket read FSock;
    property LoopBack: boolean read FLoopBack write FLoopBack;
    property LoopbackBlockSize: Integer read FLoopBackBlockSize
      write FLoopBackBlockSize;
    property lasterror: string read FLasterror;
    property isConected: boolean read getIsconected;
    property tipo: CMConType read Ftipo write setTipo;
  end;

implementation

  { ********************* TListenThread ************************************** }
  { ********************* TListenThread ************************************** }

  Constructor TListenThread.Create(ip, port: string; concallback: TConCallbk;
    errCallback: TErrCallbk);
  begin
    lisIP := ip;
    lisPort := port;
    ccb := concallback;
    errcb := errCallback;
    LSock := TTCPBlockSocket.Create;
    FreeOnTerminate := true;
    // se crea , arranca
    inherited Create(False);
  end;

  Destructor TListenThread.Destroy;
  begin
    LSock.free;
  end;

  procedure TListenThread.Notificar;
  // this method is only called by Synchronize(@ShowStatus) and therefore
  // executed by the main thread
  begin
    if Assigned(ccb) then
      ccb(Csock);
  end;

  procedure TListenThread.Execute;
  label
    error;
  var
    ClientSock: TSocket;
    fin: boolean;
  begin
    LSock.CreateSocket;
    LSock.setLinger(true, 10000);
    LSock.bind(lisIP, lisPort);
    if LSock.lasterror <> 0 then
      goto error;

    if Ftipo = TCP then
    begin
      LSock.listen;
      if LSock.lasterror <> 0 then
        goto error;
    end;

    // bucle de espera de conexiones entrantes
    fin := False;
    while not(terminated or fin) do
    begin
      if LSock.canread(100) then
      begin
        ClientSock := LSock.accept;
        if LSock.lasterror = 0 then
        begin
          Csock := ClientSock;
          Notificar;
          terminate;
          fin := true;
        end;
      end;
    end;
    exit;

  error:
    // comunicar el error en callback y terminar la tarea
    errcb(LSock.LastErrorDesc);

  end;

  { TEchoThrd }
  { ********************* TEchoThrd ************************************** }
  { ********************* TEchoThrd ************************************** }

  Constructor TEchoThrd.Create(hsock: TSocket; bs: TBlockSocket;
    tipo: CMConType; BSize: Integer);
  begin
    BlckSize := BSize;
    Ftipo := tipo;
    Sock := bs;
    inherited Create(False);
    Csock := hsock;
    FreeOnTerminate := true;
  end;

  procedure TEchoThrd.Execute;
  var
    s: AnsiString;
    blck: array [0 .. MAX_BLOCK_SIZE - 1] of byte;
    numBytes: Integer;

  begin
    case Ftipo of
      TCP:
        begin
          Sock := TTCPBlockSocket.Create;
          Sock.socket := Csock;
        end;
      UDP:
        // el socket ya esta creado
        // Sock := TUDPBlockSocket.Create;
      end;

      try

        Sock.GetSins;
        with Sock do
        begin
          if BlckSize = 0 then
            // como ansistring
            repeat
              if terminated then
                break;
              s := RecvBlock(60000);
              if lasterror <> 0 then
                break;
              SendBlock(s);
              if lasterror <> 0 then
                break;
              //yield;
            until False
          else
            // como bufers de BLcksize
            repeat
              if terminated then
                break;
              numBytes := RcvBlockBuf(@blck, 60000);
              if lasterror <> 0 then
                break;
              SendBlockBuf(@blck, numBytes);
              if lasterror <> 0 then
                break;
              //yield;
            until False;

        end;
      finally
        if Ftipo = TCP then
          Sock.free;
      end;
    end;

  function TEchoThrd.isconnected: boolean;
  begin
    // no funsiona
    result := False;
    if Sock = nil then
      exit;
    // Result := (Sock.Socket = INVALID_SOCKET) or ((Sock.WaitingData = 0) and Sock.CanRead(0));
    result := (Sock.socket <> INVALID_SOCKET) or ((Sock.WaitingData = 0));

  end;

  { ********************* TConManager ************************************** }
  { ********************* TConManager ************************************** }

  constructor TConManager.Create;
  begin
    inherited;
    Ftipo := TCP;
    FLoopBackBlockSize := 0;
    FLoopBack := False;
    Reset;
  end;

  destructor TConManager.Destroy;
  begin
    Reset;
    inherited;
  end;

  procedure TConManager.setestado(e: CMestado);
  begin
    FEstado := e;
  end;

  procedure TConManager.setTipo(tip: CMConType);
  begin
    if tip = Ftipo then
      exit;
    Disconnect;
    Ftipo := tip;
  end;

  // conection callback
  Procedure TConManager.concallback(Sock: TSocket);
  begin
    if FLoopBack then
    begin
      // si echo, creamos una tarea asociada al socket
      // que devuelve lo que se le envia
      FechoThread := TEchoThrd.Create(Sock, nil, Ftipo, FLoopBackBlockSize);
      Estado := conectado;
    end
    else
    begin
      // sino, preparamos el socket para usarlo
      FSock := TTCPBlockSocket.Create;
      FSock.socket := Sock;
      FSock.GetSins;
      Estado := conectado;
    end;
  end;

  // error callback
  Procedure TConManager.errCallback(serror: string);
  begin
    Estado := error;
    FLasterror := serror;
  end;

  function TConManager.getIsconected: boolean;
  begin
    result := False;
    if Estado <> conectado then
      exit;
    if FechoThread <> nil then
      result := FechoThread.isconnected;
  end;

  procedure TConManager.listen;
  begin
    FLasterror := '';
    case Ftipo of
      TCP:
        begin
          FLisThread := TListenThread.Create(FselfIP, FSelfPort, concallback,
            errCallback);
          // FLisThread.Priority := tpHighest;
          // arrancar
          // FLisThread.Start;
          if FLasterror = '' then
            Estado := escuchando
          else
            Estado := error;
        end;
      UDP:
        begin
          FSock := TUDPBlockSocket.Create;
          FSock.setLinger(true, 10000);
          FSock.bind(FselfIP, FSelfPort);
          if FSock.lasterror <> 0 then
          begin
            FLasterror := FSock.LastErrorDesc;
            Estado := error;
          end
          else
          begin
            if FLoopBack then
              FechoThread := TEchoThrd.Create(-1, FSock, Ftipo,
                FLoopBackBlockSize);

            Estado := conectado;
          end;
        end;
    end;
  end;

  procedure TConManager.connect;
  begin
    if not(Estado in [inicio, escuchando]) then
      exit;
    if Estado = escuchando then
      Reset;

    // aqui estado=inicio
    case Ftipo of
      TCP:
        FSock := TTCPBlockSocket.Create;
      UDP:
        FSock := TUDPBlockSocket.Create;
    end;

    FSock.connect(FremoteIp, FRemotePort);
    if FSock.lasterror = 0 then
      Estado := conectado
    else
    begin
      errCallback(FSock.LastErrorDesc);
      FSock.Destroy;
      FSock := nil;
    end;
  end;

  procedure TConManager.Disconnect;
  begin
    Reset;
  end;

  procedure TConManager.Reset;
  begin
    Estado := inicio;
    FLasterror := '';
    // FLoopBack:=False;

    try
      begin
        if Assigned(FLisThread) then
        begin
          FLisThread.terminate;
          sleep(100);
          FLisThread := nil;
        end;

        if Assigned(FechoThread) then
        begin
          FechoThread.terminate;
          FechoThread := nil;
        end;

        if Assigned(FSock) then
        begin
          FSock.CloseSocket;
          FSock.Destroy;
          FSock := nil;
        end;
        FLasterror := '';
        Estado := inicio;
      end;
    except
    end;
  end;

end.
