unit DecimalXHelperTest;

interface

uses
  DUnitX.TestFramework, DecimalX, DecimalXHelper;

type

  [TestFixture]
  TDecimalXHelperTest = class(TObject)
  public
    [Test]
    procedure SqrtTest;
  end;

implementation

procedure TDecimalXHelperTest.SqrtTest;
var
  dec1: TDecimalX;
  s: String;
begin
  dec1 := TDecimalX.Create(16);
  s := dec1.Sqrt(1).ToString;
  Assert.IsTrue(s = '4.0');

  dec1 := TDecimalX.Create('0.0');
  s := dec1.Sqrt(2).ToString;
  Assert.IsTrue(s = '0.00');

  dec1 := TDecimalX.Create('2.0');
  s := dec1.Sqrt(200).ToString;
  Assert.IsTrue
    (s = '1.41421356237309504880168872420969807856967187537694807317667973799073247846210703885038753432764157273501384623091229702492483605585073721264412149709993583141322266592750559275579995050115278206057147');

  dec1 := TDecimalX.Create('25.0');
  s := dec1.Sqrt(4).ToString;
  Assert.IsTrue(s = '5.0000');

  dec1 := TDecimalX.Create('1.000');
  s := dec1.Sqrt(1).ToString;
  Assert.IsTrue(s = '1.0');

  dec1 := TDecimalX.Create(6);
  s := dec1.Sqrt(4).ToString;
  Assert.IsTrue(s = '2.4494');

  dec1 := TDecimalX.Create('0.5');
  s := dec1.Sqrt(6).ToString;
  Assert.IsTrue(s = '0.707106');

  dec1 := TDecimalX.Create('5113.51315');
  s := dec1.Sqrt(4).ToString;
  Assert.IsTrue(s = '71.5088');

  dec1 := TDecimalX.Create('15112345');
  s := dec1.Sqrt(6).ToString;
  Assert.IsTrue(s = '3887.459967');

  dec1 := TDecimalX.Create
    ('783648276815623658365871365876257862874628734627835648726');
  s := dec1.Sqrt(58).ToString;
  Assert.IsTrue
    (s = '27993718524262253829858552106.4622387227347572406137833208384678543897305217402364794553');

end;

initialization

TDUnitX.RegisterTestFixture(TDecimalXHelperTest);

end.
