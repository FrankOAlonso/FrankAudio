unit TcodecTestU;

interface

uses
  DUnitX.TestFramework,CodecU;

type
  [TestFixture]
  TCodecTest = class
  public
    // Sample Methods
    // Simple single Test
    [Test]
    procedure Test1;
    // Test with TestCase Attribute to supply parameters.
    [Test]
    //[TestCase('TestA','480,2')]
    [TestCase('TestB','240,4')]
    procedure Test2(const size : Integer;const AValue2 : Integer);
  end;

implementation

procedure TCodecTest.Test1;
begin
end;

procedure TCodecTest.Test2(const size : Integer;const AValue2 : Integer);
var
  cod:TCodec;
  asinIn,asinOut:array [0..cMAX_FRAME_SIZE-1] of TSample;
  abytes:array [0..cMAX_PACKET_SIZE-1] of byte;
  j,nb,ns:integer;
  pfin,pfout:TPPcm;
  pb:TPbytes;
  s:string;
  a:tsample;
begin
  for j:=0 to size-1 do begin
    asinIn[j]:=sin((2*PI*j)/size);
    //asin[j]:=((a and $00FF)shl 8) or ((a and $FF00) shr 8);
  end;
  pfin:=@asinin[0];
  pfout:=@asinout[0];
  pb:=@abytes;

  //crear el codec
  cod:=TCodec.Create;

  //ajustar los parametros
  cod.frameSize:=size;
  cod.sampleRate:=48000;
  cod.bitRate:=64000;

  //iniciar
  cod.init;
 for j:=1  to 20 do  begin

  nb:=cod.encode(pfin^,pb^);
  Assert.IsTrue(nb>0);
  ns:=cod.decode(pb^,nb,pfout^);
  Assert.IsTrue(ns>0);

 end;






end;

initialization
  TDUnitX.RegisterTestFixture(TCodecTest);

end.
