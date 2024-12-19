unit TworkThreadTestU;

interface

uses
  DUnitX.TestFramework,echo,ConManager,membuf,worktcpthread, blcksock,windows;

type
  [TestFixture]
  TWorkThreadTest = class
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    // Sample Methods
    // Simple single Test
    [Test]
    procedure TestEchoserver;
    // Test with TestCase Attribute to supply parameters.
    //[Test]
    //[TestCase('TestEchoOut','256,5000,192.168.0.2,22134,UDP')]
    //[TestCase('TestEchoOut','480,5000,192.168.0.2,22134,TCP')]
    //[TestCase('TestEchoOut','480,5000,192.168.0.2,22124,UDP')]
    //[TestCase('TestEchoOut','480,5000,192.168.0.2,22124,TCP')]
    procedure TestConectionRemote(const V1 : Integer;const V2 : Integer;const ip,port : string; tipo:CMConType);

    //[TestCase('TestEchoOutRemoteReal','256,5000,82.223.2.110,3040,UDP')]
    [TestCase('TestEchoOutRemoteReal','256,5000,10.0.0.1,3040,UDP')]
 //   [TestCase('TestEchoOutRemote','128,5000,192.168.0.11,22134,TCP')]
    procedure TestConectionRemoteReal(const V1 : Integer;const V2 : Integer;const ip,port : string; tipo:CMConType);

  end;

implementation
const
 sSize=256;
 Bsizeaudio=480;
var
   echoDeamon:TTCPEchoDaemon;

procedure TWorkThreadTest.Setup;
begin
end;

procedure TWorkThreadTest.TearDown;
begin
end;

procedure TWorkThreadTest.TestEchoserver;
var
 cm:TConManager;
 soki:TBlockSocket;
 a1,a2:array[0..sSize-1] of sample;
 j,socksize,blocksize,BsizeTot,totin,tot,cont,totprueba:integer;
begin

   echoDeamon := TTCPEchoDaemon.Create;

  cm := TConManager.Create;
  cm.remoteIp :='127.0.0.1';
  cm.RemotePort := '22134';
  cm.connect;
  Assert.AreEqual(conectado, cm.Estado);

  // enviar un bloque
  for j := 0 to sSize - 1 do
  begin
    a1[j] := j;
    a2[j] := 66;
  end;

  soki := cm.Sock;
  for j := 1 to 10 do
  begin
    a1[0] := 10 - j;
    soki.SendBuffer(@a1[0], sSize * sizeof(sample));
    soki.RecvBufferEx(@a2[0], sSize * sizeof(sample), 1000);
    Assert.AreEqual(0, soki.LastError);
    Assert.AreEqualMemory(@a1, @a2, sSize * sizeof(sample));

  end;
  cm.Destroy;
  echoDeamon.terminate;
end;

procedure TWorkThreadTest.TestConectionRemote(const V1 : Integer;const V2 : Integer;const ip,port : string;tipo:CMConType);
const
 testsize=10000;
var
 cm,cme:TConManager;
 soki:TBlockSocket;
 a1,a2:array[0..sSize-1] of sample;
 j,socksize,blocksize,BsizeTot,totin,tot,cont,cont2,totprueba:integer;
 Mbin,Mbout:TMemBuf;
 workThread : TWorkThread;
 p1,p2,pRes:pblock;
 a3,a4:array[0..testsize-1] of sample;
 nb:integer;
begin
  //con bloques
  cme := TConManager.Create;
  cme.selfIp:=ip;
  cme.SelfPort:=port;
  cme.tipo:=tipo;
  cme.LoopBack:=true;
  cme.LoopbackBlockSize:=sSize*sizeof(sample);
  cme.listen;
  sleep(1000);
  Assert.istrue(cme.Estado in [escuchando,conectado]);

     // probar el working thread
   cm := TConManager.Create;
  cm.remoteIp := ip;
  cm.RemotePort := port;
  cm.tipo:=tipo;
  cm.connect;
  Assert.AreEqual(conectado, cm.Estado);
  



  // probar el echo
  soki := cm.Sock;
  for j := 1 to 10 do
  begin
    a1[0] := 10 - j;
    soki.SendBlockBuf(@a1[0], sSize * sizeof(sample));
    nb := soki.RcvBlockBuf(@a2[0], 1000);

    Assert.AreEqual(0, soki.LastError);
    Assert.AreEqualMemory(@a1, @a2, sSize * sizeof(sample));

  end;

   writeln('Echo Probado');
  cm.destroy;
  cme.Destroy;

  cme := TConManager.Create;
  cme.selfIp:=ip;
  cme.SelfPort:=port;
  cme.tipo:=tipo;
  cme.LoopBack:=true;
  cme.LoopbackBlockSize:=sSize*sizeof(sample);
  cme.listen;
  sleep(3000);
  Assert.istrue(cme.Estado in [escuchando,conectado]);

  cm := TConManager.Create;
  cm.remoteIp := ip;
  cm.RemotePort := port;
  cm.tipo:=tipo;
  cm.connect;
  Assert.AreEqual(conectado, cm.Estado);

  // probar el working thread
  BsizeTot := Bsizeaudio * 30;
  Mbin := TMemBuf.Create(BsizeTot);
  Mbout := TMemBuf.Create(BsizeTot);

  workThread := TWorkThread.Create(True);
  // With the True parameter it doesn't start automatically
  if Assigned(workThread.FatalException) then
    raise workThread.FatalException;

  //workThread.FreeOnTerminate := false;
  // Here the code initialises anything required before the threads starts executing
  // workThread.statusCallback:=@threadUpdate;

  // entrada , salida o ambos
  workThread.e_s := both;

  // buffers circulares
  workThread.Mbin := Mbin;
  workThread.Mbout := Mbout;
  // tamaño del bloque de socket
  workThread.BsizeSock := sSize;
  workThread.Sock :=cm.Sock ;

  workThread.init;
  //probamos a meter algun bloque antes


  //los llenamos de algo para controlar
  for j := 0 to testsize-1 do begin
    a3[j]:=j;
    a4[j]:=66;
  end;

   mbout.PutMemCopy(v1,@a3[0]);

  workThread.processFrames;
    sleep(1000);
  workThread.processFrames;


  pRes:=Mbin.GetMemcopy(v1,@a4[0]);
  Assert.IsNotNull(pRes);
  assert.AreEqualMemory(@a3,@a4,v1*sizeof(sample));

  //workThread.Priority:=tpHighest;
  // arrancar
  workThread.Start;
  sleep(1000);
  Assert.AreEqual(true,workThread.Started);
  //alocar memoria para los bufers de prueba



  totin:=0;
  tot:=0;
  cont:=0;
  cont2:=0;
  while (totin<testsize) and (tot<(testsize-v1)) do begin
    //metemos de v1 en v1   y lo guardamos en a1
    EnterCriticalSection(CritSect);
      mbout.PutMemCopy(v1,@a3[totin]);
    LeaveCriticalSection(CritSect);

    inc(cont);
    totin:=totin+v1;
    sleep(30);
    //sacamos de v1 en v1  p2
    REPEAT
      EnterCriticalSection(CritSect);
        pRes:=Mbin.GetMemcopy(v1,@a4[tot]);
      LeaveCriticalSection(CritSect);

      if pRes<>nil then begin
        inc(cont2);
        tot:=tot+v1;
      end;
    UNTIL pRes=nil;


  end;
  Assert.istrue(cont-(testsize div v1)<=1);

  Assert.Istrue((totin-tot)<2*v1);

  assert.AreEqualMemory(@a3,@a4,2*tot);
  Assert.istrue(mbOut.used<ssize);
  Assert.istrue(mbin.used<v1);


  workThread.Terminate;
  //echoDeamon.Terminate;
  sleep(1000);

  cme.Disconnect;
  cm.Disconnect;
  cme.Destroy;
  cm.Destroy;

end;

procedure TWorkThreadTest.TestConectionRemoteReal(const V1 : Integer;const V2 : Integer;const ip,port : string;tipo:CMConType);
const
 testsize=100000;
var
 cm,cme:TConManager;
 soki:TTCPBlockSocket;
 a1,a2:array[0..sSize-1] of sample;
 j,socksize,blocksize,BsizeTot,lostBlocks,totin,tot,cont,cont2,totprueba:integer;
 Mbin,Mbout:TMemBuf;
 workThread : TWorkThread;
 p1,p2,pRes:pblock;
 a3,a4:array[0..testsize-1] of sample;
begin
  //con bloques
 { cme := TConManager.Create;
  cme.selfIp:=ip;
  cme.SelfPort:=port;
  cme.tipo:=tipo;
  cme.LoopBack:=true;
  cme.LoopbackBlockSize:=sSize*sizeof(sample);
  cme.listen;
  sleep(1000);
  Assert.istrue(cme.Estado in [escuchando,conectado]);
}
  //echoDeamon := TTCPEchoDaemon.Create;
   // probar el working thread
  writeln('Hace falta un servidorecho udp  remoto escuchando');
  cm := TConManager.Create;
  cm.remoteIp := ip;
  cm.RemotePort := port;
  cm.tipo:=tipo;
  cm.connect;
  Assert.AreEqual(conectado, cm.Estado);

  // probar el working thread
  // probar el working thread
  BsizeTot := Bsizeaudio * 30;
  Mbin := TMemBuf.Create(BsizeTot);
  Mbout := TMemBuf.Create(BsizeTot);

  workThread := TWorkThread.Create(True);
  // With the True parameter it doesn't start automatically
  if Assigned(workThread.FatalException) then
    raise workThread.FatalException;

  //workThread.FreeOnTerminate := false;
  // Here the code initialises anything required before the threads starts executing
  // workThread.statusCallback:=@threadUpdate;

  // entrada , salida o ambos
  workThread.e_s := both;

  // buffers circulares
  workThread.Mbin := Mbin;
  workThread.Mbout := Mbout;
  // tamaño del bloque de socket
  workThread.BsizeSock := sSize;
  workThread.Sock :=cm.Sock ;
  workThread.init;

  // workThread.Priority:=tpHighest;
  // arrancar
  //workThread.Start;
  //sleep(1000);
  //Assert.AreEqual(true,workThread.Started);

  //alocar memoria para los bufers de prueba

  //los llenamos de algo para controlar
  for j := 0 to testsize-1 do begin
    a3[j]:=j;
    a4[j]:=66;
  end;



  totin:=0;
  tot:=0;
  cont:=0;
  cont2:=0;
  while (totin<testsize) and (tot<(testsize-v1)) do begin
    //metemos de v1 en v1   y lo guardamos en a1

    mbout.PutMemCopy(v1,@a3[totin]);
    workThread.processFrames;
    inc(cont);
    totin:=totin+v1;
    sleep(20);
    //sacamos de v1 en v1  p2
    pRes:=Mbin.GetMemcopy(v1,@a4[tot]);

    if pRes<>nil then begin
      inc(cont2);
      tot:=tot+v1;
    end;


  end;

  lostBlocks:=(totin-tot)div v1;

  Assert.istrue(cont-(testsize div v1)<=1);

  Assert.Istrue((totin-tot)<=2*v1);

  assert.AreEqualMemory(@a3,@a4,2*tot);
  Assert.istrue(mbOut.used<ssize);
  Assert.istrue(mbin.used<=2*v1);


  workThread.Terminate;
  //echoDeamon.Terminate;
  sleep(1000);


  cm.Disconnect;

  cm.Destroy;

end;
initialization
  TDUnitX.RegisterTestFixture(TWorkThreadTest);

end.
