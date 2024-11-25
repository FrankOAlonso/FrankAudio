unit TRpiTest;

interface

uses
  DUnitX.TestFramework,ConManager,sysutils,blcksock,windows;//DUnitX.Loggers.GUIX;

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
    [TestCase('TestRpi0','192.168.0.2,22134,UDP')]
    //[TestCase('TestRpi0','192.168.0.2,22124,UDP')]
    //[TestCase('TestRpi0','192.168.0.2,22134,TCP')]
    procedure TestRpi0(const ip,port : string;tipo:CMConType);


  end;

implementation
var
  cm,cm2:TConManager;


procedure TConManagerTest.Setup;
begin


end;

procedure TConManagerTest.TearDown;
begin
end;


procedure TConManagerTest.TestRpi0(const ip,port : string;tipo:CMConType);
const
 max=64;

var
  soki,soko:TBlockSocket;
  bufenv,bufrec:ansistring;
  s,s2:string;
  abytes1,abytes2:Array[0..max-1] of single;
  i,j,nb:integer;
   tics,tics2:Cardinal;
  asingle,asingle1:array[1..128] of single;
  numb,bytestrans:integer;
begin
  sleep (1000);
  cm:=TConManager.Create;
  cm.selfIp:=ip;
  cm.SelfPort:=port;
  cm.tipo:=tipo;
  cm.LoopBack:=true;
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
  bufenv:='Hola que tal';
  soki.SendBlockBuf(@bufenv,length(bufenv));
  nb:=soki.RcvBlockBuf(@bufrec,100);

  Assert.IsTrue(soki.LastError=0);
  soki.CloseSocket;


   case tipo of
    TCP:
     Soko := TTCPBlockSocket.Create;
    UDP:
     Soko := TUDPBlockSocket.Create;
  end;

  for i := 1 to 128 do
   asingle[i]:=Random(27);

   tics:=GetTickCount();
   bytestrans:=0;
   soko.Connect(ip,port);
    //probamos a conectarnos
   for j := 1 to 512 do begin


    soko.SendBlockBuf(@asingle,sizeof(asingle));
    assert.AreEqual(0,soko.LastError);
    numb:=soko.RcvBlockBuf(@asingle1,1000);
    assert.AreEqual(0,soko.LastError);
    assert.AreEqual(numb,sizeof(asingle));
    //lo enviado y recibido es igual
    Assert.AreEqualMemory(@asingle,@asingle1,sizeof(asingle));
   bytestrans:=bytestrans+SizeOf(asingle);
   end;

 tics2:=GetTickCount();
 case tipo of
    TCP:
     WriteLn('Milisegundos bloques TCP rpi '+(tics2-tics).ToString+ ' Kb/sec '+ (bytestrans/(tics2-tics)).ToString );

    UDP:
      WriteLn('Milisegundos bloques UDP rpi '+(tics2-tics).ToString+ ' Kb/sec '+ (bytestrans/(tics2-tics)).ToString );
  end;
 




  soki.Destroy;
end;




initialization
  TDUnitX.RegisterTestFixture(TConManagerTest);

end.
