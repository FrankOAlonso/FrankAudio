unit Unit1;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TestObject = class
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    // Sample Methods
    // Simple single Test
    [Test]
    procedure Test1;
    // Test with TestCase Attribute to supply parameters.
    [Test]
    [TestCase('TestA','1,2')]
    [TestCase('TestB','3,4')]
    procedure Test2(const AValue1 : Integer;const AValue2 : Integer);
  end;

implementation

procedure TestObject.Setup;
begin
end;

procedure TestObject.TearDown;
begin
end;

procedure TestObject.Test1;
begin
end;

procedure TestObject.Test2(const AValue1 : Integer;const AValue2 : Integer);
begin
end;

initialization
  TDUnitX.RegisterTestFixture(TestObject);

end.
