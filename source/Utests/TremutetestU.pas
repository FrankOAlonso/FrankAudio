unit TremutetestU;

interface

uses
  DUnitX.TestFramework,sysutils, blcksock,ConManager,echo,blockbuf,
  windows;


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
    [TestCase('TestCheckConect','192.168.0.16,22134')]
    procedure TestCheckConect(const ip,port : string);

    [Test]
  {  [TestCase('TestEchoOut','128,192.168.0.16,22134')]
   }  [TestCase('TestEchoOut','256,192.168.0.16,22134')]
    [TestCase('TestEchoOut','400,192.168.0.16,22134')]
   [TestCase('TestEchoOut','512,192.168.0.16,22134')]
    procedure TestConectionRemote(socksize:integer;const ip,port : string);

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

procedure TestRemote.TestCheckConect(const ip,port : string);
var
  soki,soko:TBlockSocket;
  bufenv,bufrec:AnsiString;
  s,s2:ansistring;
begin
  cm.selfIp:=ip;
  cm.SelfPort:=port;
  cm.LoopBack:=true;
  cm.listen;
  sleep(1000);
  Assert.AreEqual(escuchando,cm.Estado);


  //creamos otro connection manager y nos intentamos conectar al primero
  cm2:=TConManager.Create;
  cm2.remoteIp:=ip;
  cm2.RemotePort:=port;
  cm2.connect;
  Assert.AreEqual(conectado,cm2.Estado);
   sleep(1000);
  Assert.AreEqual(conectado,cm.Estado);

  //probamos a conectarnos
  s:='Hola que tal';
  soki:=cm2.sock;
  soki.Sendblock(s);
  assert.AreEqual(0,soki.LastError);
  sleep(1000);
  s2:=soki.RecvBlock(1000);
  assert.AreEqual(0,soki.LastError);
  //lo enviado y recibido es igual
  assert.AreEqual(s,s2);
 {

  Assert.AreEqual(true,cm.isConected);
  cm2.Disconnect;
  Sleep(1000)  ;
  Assert.AreEqual(false,cm.isConected);
  }


  {



  Assert.AreEqual(conectado,cm2.Estado);
  cm2.Disconnect;
  Assert.AreEqual(inicio,cm2.Estado);
  }
end;



procedure TestRemote.TestConectionRemote(socksize:integer;const ip,port : string);
const
  max=1024;
var
  soki:TBlockSocket;
  s:string;
  sblock,s2:AnsiString;
  i,j:integer;
  tics,tics2:Cardinal;
  ashortint,ashortint1:array[0..max-1] of sample;
  numb,bytestrans,bytes:integer;
  echodem:TTCPEchoDaemon;
begin
  //creamos un deamon de echo
  echodem:=TTCPEchoDaemon.Create;
  echodem.blksize:=socksize;
  bytes:=socksize*sizeof(sample);

  //creamos un  connection manager y nos intentamos conectar al echo,
  //que tiene q ue estar escuchando en loopback
  cm2:=TConManager.Create;
  cm2.remoteIp:=ip;
  cm2.RemotePort:=port;
  cm2.connect;
  Assert.AreEqual(conectado,cm2.Estado);

  for i := 1 to socksize do
   ashortint[i]:=Random(20000);

   tics:=GetTickCount();
   bytestrans:=0;
    //probamos a conectarnos
   for j := 1 to 2048 do begin

    soki:=cm2.sock;
    numb:=soki.SendBuffer(@ashortint,bytes);
    assert.AreEqual(0,soki.LastError);
    assert.AreEqual(numb,bytes);
    numb:=soki.RecvBufferEx(@ashortint1,bytes,5000);
    assert.AreEqual(0,soki.LastError);
    assert.AreEqual(numb,bytes);
    //lo enviado y recibido es igual
    Assert.AreEqualMemory(@ashortint,@ashortint1,bytes);
    bytestrans:=bytestrans+bytes;
   end;

 tics2:=GetTickCount();

 WriteLn('Milisegundos bloques Tamaño:'+socksize.ToString+' '+(tics2-tics).ToString+ ' Kb/sec '+ (bytestrans/(tics2-tics)).ToString );



  Assert.AreEqual(conectado,cm2.Estado);
  cm2.Disconnect;
  Assert.AreEqual(inicio,cm2.Estado);
  echodem.Terminate;
  sleep(1000);


end;

initialization
  TDUnitX.RegisterTestFixture(TestRemote);

end.
