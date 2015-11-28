unit DecimalXTest;

interface
uses
  DUnitX.TestFramework, IntegerX, DecimalX;

type

  [TestFixture]
  TDecimalXTest = class(TObject) 
  public
  end;

implementation


initialization
  TDUnitX.RegisterTestFixture(TDecimalXTest);
end.
