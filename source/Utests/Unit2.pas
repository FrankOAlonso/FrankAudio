unit Unit2;

interface

uses
  DUnitX.TestFramework,ConManager,sysutils,blcksock,windows, DUnitX.Loggers.GUIX;


type
  [TestFixture]
  TestRemote = class
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    // Sample Methods
    // Simple single Test
    [Test]
    [TestCase('TestEchoOut','192.168.0.11,22134')]
    procedure TestConectionRemote(const ip,port : string);

  end;

implementation
var
  cm,cm2:TConManager;
procedure TestRemote.Setup;
begin
 cm:=TConManager.Create;
end;

procedure TestRemote.TearDown;
begin
end;

procedure TestRemote.TestConectionRemote(const ip,port : string);
var
  soki,soko:TTCPBlockSocket;
  bufenv,bufrec:AnsiString;
  s:string;
  sblock,s2:AnsiString;
  i,j:integer;
  tics,tics2:Cardinal;
  asingle,asingle1:array[1..512] of single;
  numb,bytestrans:integer;
begin


  //creamos un  connection manager y nos intentamos conectar al remoto,
  //que tiene q ue estar escuchando en loopback
  cm2:=TConManager.Create;
  cm2.remoteIp:=ip;
  cm2.RemotePort:=port;
  cm2.connect;
  Assert.AreEqual(conectado,cm2.Estado);

  for i := 1 to 512 do
   asingle[i]:=Random(27);

   tics:=GetTickCount();
   bytestrans:=0;
    //probamos a conectarnos
   for j := 1 to 512 do begin

    soki:=cm2.sock;
    numb:=soki.SendBuffer(@asingle,sizeof(asingle));
    assert.AreEqual(0,soki.LastError);
    assert.AreEqual(numb,sizeof(asingle));
    numb:=soki.RecvBufferEx(@asingle1,sizeof(asingle),1000);
    assert.AreEqual(0,soki.LastError);
    assert.AreEqual(numb,sizeof(asingle));
    //lo enviado y recibido es igual
   // Assert.AreEqualMemory(@asingle,@asingle1,sizeof(asingle));
   bytestrans:=bytestrans+SizeOf(asingle);
   end;

 tics2:=GetTickCount();

 WriteLn('Milisegundos bloques'+(tics2-tics).ToString+ ' Kb/sec '+ (bytestrans/(tics2-tics)).ToString );



  Assert.AreEqual(conectado,cm2.Estado);
  cm2.Disconnect;
  Assert.AreEqual(inicio,cm2.Estado);



end;
initialization
  TDUnitX.RegisterTestFixture(TestRemote);

end.
