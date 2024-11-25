unit TconmanagertestU;

interface

uses
  DUnitX.TestFramework,ConManager,sysutils,blcksock,windows;// DUnitX.Loggers.GUIX;

type
  [TestFixture]
  TConManagerTest = class
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    // Sample Methods
    // Simple single Test
    [Test]
    [TestCase('TestConection0','192.168.0.2,22134,UDP')]
    [TestCase('TestConection0','192.168.0.2,22124,UDP')]
    //[TestCase('TestConection0','192.168.0.2,22134,TCP')]
    procedure TestConection0(const ip,port : string;tipo:CMConType);

    [Test]
    procedure Test1;
    // Test with TestCase Attribute to supply parameters.
    [Test]
    [TestCase('Test0','0.0.0.0,22134,UDP')]
    [TestCase('Test192','192.168.0.2,22134')]
    [TestCase('Test127','127.0.0.1,22134')]
    //[TestCase('Testchungo','24.0.8.0,22134')]
    procedure Test2(const ip,port : string;tipo:CMConType);

    [Test]
    //[TestCase('Test0','0.0.0.0,22134')]
    [TestCase('Test192','192.168.0.2,22134,UDP')]
    [TestCase('Test127','127.0.0.1,22134,TCP')]
    procedure TestConection(const ip,port : string;tipo:CMConType);

    [Test]
    [TestCase('TestConection2','192.168.0.2,22134,UDP')]
    [TestCase('TestConection2','192.168.0.2,22134,TCP')]
    procedure TestConection2(const ip,port : string;tipo:CMConType);

    [Test]
    [TestCase('TestEchoOut,UDP','192.168.0.2,22134,UDP')]
    [TestCase('TestEchoOut TCP','192.168.0.2,22134,TCP')]
    procedure TestConection3(const ip,port : string;tipo:CMConType);

    [Test]
    [TestCase('TestIsconectedt','192.168.0.2,22134')]
    procedure TestConection4(const ip,port : string;tipo:CMConType);

  end;

implementation
var
  cm,cm2:TConManager;


procedure TConManagerTest.Setup;
begin
  cm:=TConManager.Create;

end;

procedure TConManagerTest.TearDown;
begin
  cm.Destroy;
end;

procedure TConManagerTest.Test1;
begin
  //Assert.IsTrue(cm.remoteIp='7');

end;

procedure TConManagerTest.Test2(const ip,port : string;tipo:CMConType);
begin
  cm.selfIp:=ip;
  cm.SelfPort:=port;
  cm.tipo:=tipo;
  cm.listen;
  sleep(1000);

  Assert.istrue(cm.Estado in [escuchando,conectado]);
 { while true  do
    sleep(1000);
  }
  //cm.Disconnect;
  //Assert.AreEqual(inicio,cm.Estado);

end;

{
procedure SendBlock(sok:TBlockSocket;Buf:Pointer;Nbytes:integer);
begin
   sok.SendInteger(Nbytes);
   sok.SendBuffer(Buf,Nbytes);
end;

function RcvBlock(sok:TBlockSocket;Buf:Pointer;TimeOut:integer):integer;
var
 Nbytes:integer;
begin
   Nbytes:=sok.RecvInteger(Timeout);
   sok.RecvBufferEx(Buf,Nbytes,TimeOut);
   result:=nbytes;
end;
}
procedure TConManagerTest.TestConection0(const ip,port : string;tipo:CMConType);
const
 max=64;

var
  soki,soko:TBlockSocket;
  bufenv,bufrec:AnsiString;
  s,s2:string;
  abytes1,abytes2:Array[0..max-1] of single;
  j,nb:integer;
begin
  cm.selfIp:=ip;
  cm.SelfPort:=port;
  cm.tipo:=tipo;
  cm.listen;
  sleep(1000);
  Assert.istrue(cm.Estado in [escuchando,conectado]);

  //probamos a conectarnos
  case tipo of
    TCP:
     Soki := TTCPBlockSocket.Create;
    UDP:
     Soki := TUDPBlockSocket.Create;
  end;

  soki.Connect(ip,port);

  assert.AreEqual(0,soki.LastError);

  sleep(1000);

  Assert.AreEqual(conectado,cm.Estado);

  //iniciar un buffer
  for j := 0 to max-1  do
    abytes1[j]:=10*j;


  //enviarlo como bloque
  soki.SendBlockBuf(@abytes1,sizeof(abytes1));
  assert.AreEqual(0,soki.LastError);

  //recibirlo por el otro lado
  soko:=cm.sock;
  nb:=soko.RcvBlockbuf(@abytes2,1000);
  assert.AreEqual(0,soko.LastError);

  //lo enviado y recibido es igual
  assert.AreEqualMemory(@abytes1,@abytes2,sizeof(abytes1));


  //al reves
  //iniciar un buffer
  for j := 0 to max-1  do
    abytes1[j]:=7*j;


  //enviar algo

  soko.SendBlockBuf(@abytes1,sizeof(abytes1));
  assert.AreEqual(0,soko.LastError);

  //recibirlo por el otro lado

  nb:=soki.RcvBlockbuf(@abytes2,1000);
  assert.AreEqual(0,soki.LastError);

  //lo enviado y recibido es igual
  assert.AreEqualMemory(@abytes1,@abytes2,sizeof(abytes1));


  //cm.Disconnect;
  //Assert.AreEqual(inicio,cm.Estado);
  soki.CloseSocket;
  soki.Destroy;
end;


procedure TConManagerTest.TestConection(const ip,port : string;tipo:CMConType);
var
  soki,soko:TBlockSocket;
  bufenv,bufrec:AnsiString;
  s,s2:string;

begin
  cm.selfIp:=ip;
  cm.SelfPort:=port;
  cm.tipo:=tipo;
  cm.listen;
  sleep(1000);
  Assert.istrue(cm.Estado in [escuchando,conectado]);

  //probamos a conectarnos
  case tipo of
    TCP:
     Soki := TTCPBlockSocket.Create;
    UDP:
     Soki := TUDPBlockSocket.Create;
  end;

  soki.Connect(ip,port);

  assert.AreEqual(0,soki.LastError);

  sleep(1000);

  Assert.AreEqual(conectado,cm.Estado);

  bufenv:='Hola que tal'+#13+#10;
  //enviar algo
  //soko:=cm.sock;
  soki.SendString(bufenv);
  assert.AreEqual(0,soki.LastError);
  //sleep(1000);

  soko:=cm.sock;
  bufrec:=soko.RecvString(3000)+#13+#10;
  assert.AreEqual(0,soko.LastError);

  //lo enviado y recibido es igual
  assert.AreEqual(bufenv,bufrec);

  //al reves
   bufenv:='Hola que tal'+#13+#10;
  //enviar algo
  soko:=cm.sock;
  soko.SendString(bufenv);
  assert.AreEqual(0,soko.LastError);
  //sleep(1000);

  bufrec:=soki.RecvString(3000)+#13+#10;
  assert.AreEqual(0,soki.LastError);

  //lo enviado y recibido es igual
  assert.AreEqual(bufenv,bufrec);

  
  soki.CloseSocket;
  soki.Destroy;
end;

procedure TConManagerTest.TestConection2(const ip,port : string;tipo:CMConType);
var
  soki,soko:TBlockSocket;
  bufenv,bufrec:AnsiString;
  s,s2:AnsiString;
  nb:integer;
begin
  cm.selfIp:=ip;
  cm.SelfPort:=port;
  cm.tipo:=tipo;
  cm.LoopBack:=true;
  cm.LoopbackBlockSize:=16;
  cm.listen;
  sleep(1000);
  Assert.istrue(cm.Estado in [escuchando,conectado]);


  //creamos otro connection manager y nos intentamos conectar al primero
  cm2:=TConManager.Create;
  cm2.remoteIp:=ip;
  cm2.RemotePort:=port;
  cm2.tipo:=tipo;
  cm2.connect;
  Assert.AreEqual(conectado,cm2.Estado);
   sleep(1000);
  Assert.AreEqual(conectado,cm.Estado);




  //probamos a conectarnos
  s :='0123456789ABCDEF';
  s2:='6666666666666666';
  soki:=cm2.sock;
  soki.SendBlockBuf(@s[1],16);
  assert.AreEqual(0,soki.LastError);
  sleep(1000);
  nb:=soki.RcvBlockBuf(@s2[1],1000);
  assert.AreEqual(0,soki.LastError);
  //lo enviado y recibido es igual
  assert.AreEqualMemory(@s[1],@s2[1],16);

  Assert.AreEqual(conectado,cm2.Estado);
  cm2.Disconnect;
  Assert.AreEqual(inicio,cm2.Estado);
  //cm.Disconnect;
  sleep(1000);
  //cm.Destroy;
  cm2.Destroy;
end;

procedure TConManagerTest.TestConection3(const ip,port : string;tipo:CMConType);
var
  soki,soko:TBlockSocket;
  bufenv,bufrec:AnsiString;
  s,stipo:string;
  sblock,s2:AnsiString;
  i,j:integer;
  tics,tics2:Cardinal;
  asingle,asingle1:array[1..512] of single;
  numb,bytestrans:integer;
begin
  if tipo=UDP then
    stipo:='UDP'
  else
    stipo:='TCP';

  cm.selfIp:=ip;
  cm.SelfPort:=port;
  cm.tipo:=tipo;
  cm.LoopBack:=true;
  cm.listen;
  sleep(1000);
  Assert.istrue(cm.Estado in [escuchando,conectado]);


  //creamos otro connection manager y nos intentamos conectar al primero
  cm2:=TConManager.Create;
  cm2.remoteIp:=ip;
  cm2.RemotePort:=port;
  cm2.tipo:=tipo;
  cm2.connect;
  Assert.AreEqual(conectado,cm2.Estado);
   sleep(1000);
  Assert.AreEqual(conectado,cm.Estado);

 sblock:='';
 for I :=1 to 64  do
   sblock:=sblock+'0123456789ABCDEF';

 tics:=GetTickCount();
 bytestrans:=0;
 for i := 1 to 1024 do begin

  //probamos a conectarnos

  soki:=cm2.sock;
  soki.SendBlock(sblock);
  assert.AreEqual(0,soki.LastError);
  //sleep(1000);
  s2:=soki.RecvBlock(1000);
  assert.AreEqual(0,soki.LastError);
  //lo enviado y recibido es igual
  assert.AreEqual(sblock,s2);
  bytestrans:=bytestrans+length(s2);

 end;

 tics2:=GetTickCount();
 WriteLn('Milisegundos stop '+stipo+' '+(tics2-tics).ToString+ ' Kb/sec '+ (bytestrans/(tics2-tics)).ToString );
 cm2.Disconnect;
 cm2.Destroy;

 for i := 1 to 512 do
   asingle[i]:=Random(27);

 //con bloques
  cm.Disconnect;
  cm.LoopBack:=true;
  cm.LoopbackBlockSize:=sizeof(asingle);
  cm.listen;
  sleep(1000);
  Assert.istrue(cm.Estado in [escuchando,conectado]);



   //creamos otro connection manager y nos intentamos conectar al primero
  cm2:=TConManager.Create;
  cm2.remoteIp:=ip;
  cm2.RemotePort:=port;
  cm2.tipo:=tipo;
  cm2.connect;
  Assert.AreEqual(conectado,cm2.Estado);
   sleep(1000);
  Assert.AreEqual(conectado,cm.Estado);

   tics:=GetTickCount();
   bytestrans:=0;
    //probamos a conectarnos
   for j := 1 to 512 do begin

    soki:=cm2.sock;
    soki.SendBlockBuf(@asingle,sizeof(asingle));
    assert.AreEqual(0,soki.LastError);
    numb:=soki.RcvBlockBuf(@asingle1,1000);
    assert.AreEqual(0,soki.LastError);
    assert.AreEqual(numb,sizeof(asingle));
    //lo enviado y recibido es igual
   // Assert.AreEqualMemory(@asingle,@asingle1,sizeof(asingle));
   bytestrans:=bytestrans+SizeOf(asingle);
   end;

 tics2:=GetTickCount();

 WriteLn('Milisegundos bloques'+stipo+' '+(tics2-tics).ToString+ ' Kb/sec '+ (bytestrans/(tics2-tics)).ToString );



  Assert.AreEqual(conectado,cm2.Estado);
  cm2.Disconnect;
  Assert.AreEqual(inicio,cm2.Estado);



end;

procedure TConManagerTest.TestConection4(const ip,port : string;tipo:CMConType);
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
  Assert.AreEqual(true,cm.isConected);
  cm2.Disconnect;
  sleep(1000);
  Assert.AreEqual(false,cm2.isConected);






end;


initialization
  TDUnitX.RegisterTestFixture(TConManagerTest);

end.
