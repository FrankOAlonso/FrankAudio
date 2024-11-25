unit MemBufTestU;

interface

uses
  DUnitX.TestFramework,membuf;

type
  [TestFixture]
  TMemBufTest = class
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    // Sample Methods
    // Simple single Test

    [Test]
    [TestCase('Test 4,3,72','4,3,72')]
    [TestCase('Test 3,4,72','3,4,72')]
    [TestCase('Test 7,5,350','7,5,350')]
    [TestCase('Test 7,5,340','7,5,340')]
    [TestCase('Test 240,512,14000','240,512,14000')]
    [TestCase('Test 240,513,14000','240,513,14000')]
    [TestCase('Test 239,317,7568','239,317,7568')] //primos
    procedure Test1(const V1 : Integer;const V2 : Integer;const V3 : Integer);

    // Test with TestCase Attribute to supply parameters.
    [Test]
    [TestCase('TestA','1,2')]
     procedure Test2(const AValue1 : Integer;const AValue2 : Integer);
  end;

implementation

procedure TMemBufTest.Setup;
begin
end;

procedure TMemBufTest.TearDown;
begin
end;

procedure TMemBufTest.Test1(const V1 : Integer;const V2 : Integer;const V3 : Integer);
const
  asize=15000;

var
  totprueba:integer;
  mb:TMemBuf;
  BufSize,sz2,j,tot,totin,cont:integer;
   a1,a2:array[0..asize-1] of sample;
  p1,p2:Pblock;
begin
  totprueba:=v3;
  BufSize:=asize;
  for j := 0 to asize-1 do begin
    a1[j]:=j;
    a2[j]:=66;
  end;

  //posicionamos el bufer sobre la mitad mas o menos
  mb:=TMemBuf.create(BufSize);
  j:=0;
  repeat
    mb.PutMem(7);
    mb.GetMem(7);
    j:=j+7;
  until j>(Bufsize div 2) ;


  Assert.AreEqual(0,mb.used);


  totin:=0;
  cont:=0;
  while totin<totprueba do begin
    //metemos de v1 en v1   y lo guardamos en a1
    p1:=@a1[totin];
    //for j:=0 to 3 do
      // a1[tot+j]:=random(20000);
    mb.PutMemCopy(v1,p1);
    inc(cont);
    totin:=totin+v1;
  end;
  Assert.istrue(cont-(totprueba div v1)<=1);

  tot:=0;
  cont:=0;
  repeat
    //metemos de 3en 3   y lo guardamos en a2
    p1:=@a2[tot];
    p2:=mb.GetMemCopy(v2,p1);
    if p2<>nil then begin
      inc(cont);
      tot:=tot+v2;
    end;
  until p2=nil;

  Assert.istrue(cont-(totprueba div v2)<=1);
  Assert.Istrue((totin-tot)<v2);

  assert.AreEqualMemory(@a1,@a2,2*tot);
  Assert.istrue(mb.used<v2);




end;

procedure TMemBufTest.Test2(const AValue1 : Integer;const AValue2 : Integer);
const
 asize=4;
var
  mb:TMemBuf;
  BufSize,sz2,j:integer;
   a1,a2:array[0..asize-1] of sample;
  p1,p2:Pblock;
begin
 { BufSize:=10;
  mb:=TMemBuf.create(BufSize);
  Assert.AreEqual(0,mb.used);
  Assert.AreEqual(BufSize,mb.caben);


  sz2:=sizeof(A1) shr 1;
  p1:=mb.PutMem(sz2);
  Assert.AreEqual(sz2,mb.used);
  p1:=mb.PutMem(sz2);
  Assert.AreEqual(2*sz2,mb.used);
  p1:=mb.PutMem(sz2);
  Assert.IsTrue(p1=nil);
  Assert.AreEqual(2,mb.caben);
  p1:=mb.GetMem(5);
  Assert.IsTrue(p1<>nil);
  Assert.AreEqual(3,mb.used);
  p1:=mb.PutMem(sz2);
  Assert.IsTrue(p1<>nil);
  Assert.AreEqual(7,mb.used);
  Assert.AreEqual(3,mb.caben);

  //con copia de datos

  for j := 0 to asize-1 do
    a1[j]:=random(30000);

  mb.clearMem;
  Assert.AreEqual(0,mb.used);
  Assert.AreEqual(BufSize,mb.caben);

  p1:=mb.PutMemCopy(asize,@a1);
  Assert.IsTrue(p1<>nil);
  Assert.AreEqual(asize,mb.used);

  p1:=mb.GetMemCopy(asize,@a2);
  Assert.AreEqual(0,mb.used);
  Assert.IsTrue(p1<>nil);

  assert.AreEqualMemory(@a1,@a2,asize);

  //lo llevamos al extremo
  mb.clearMem;
  p1:=mb.PutMemCopy(asize,@a1);
  Assert.IsTrue(p1<>nil);
  Assert.AreEqual(asize,mb.used);

  p1:=mb.PutMemCopy(asize,@a1);
  Assert.IsTrue(p1<>nil);
  Assert.AreEqual(2*asize,mb.used);

  p1:=mb.GetMem(3);
  Assert.AreEqual(5,mb.used);
  Assert.IsTrue(p1<>nil);
  //he sacado tres pero no caben los cuatro al inicio . debe fallar
  p1:=mb.PutMemCopy(asize,@a1);
  Assert.IsTrue(p1=nil);
  Assert.AreEqual(5,mb.used);

  //saco dos mas
  p1:=mb.GetMem(2);
  Assert.AreEqual(3,mb.used);
  Assert.IsTrue(p1<>nil);

   //he sacado tres mas 2 y ahora si debe caber
  p1:=mb.PutMemCopy(asize,@a1);
  Assert.IsTrue(p1<>nil);
  Assert.AreEqual(7,mb.used);

  p1:=mb.GetMemCopy(asize,@a2);
  Assert.AreEqual(3,mb.used);
  Assert.IsTrue(p1<>nil);



  //otra prueba
  mb.clearMem;
  p1:=mb.PutMemCopy(3,@a1);
  Assert.IsTrue(p1<>nil);

  p1:=mb.PutMemCopy(3,@a1);
  Assert.IsTrue(p1<>nil);

  p1:=mb.PutMemCopy(3,@a1);
  Assert.IsTrue(p1<>nil);
   //saco dos mas
  p1:=mb.GetMem(6);
  Assert.IsTrue(p1<>nil);
  Assert.AreEqual(3,mb.used);


  p2:=mb.PutMemCopy(4,@a1);
  Assert.IsTrue(p1<>nil);

  p1:=mb.GetMem(3);
  Assert.IsTrue(p1<>nil);

  p1:=mb.GetMemCopy(4,@a2);
  Assert.IsTrue(p1<>nil);
  assert.AreEqualMemory(@a1,@a2,asize);
  Assert.AreEqual(0,mb.used);





  }

end;


initialization
  TDUnitX.RegisterTestFixture(TMemBufTest);

end.
