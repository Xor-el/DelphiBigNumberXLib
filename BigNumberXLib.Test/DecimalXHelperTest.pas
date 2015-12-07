unit DecimalXHelperTest;

// Simple Unit Test for DecimalXHelper.
// Will add more Soon.

interface

uses
  DUnitX.TestFramework, DecimalX, DecimalXHelper;

type

  [TestFixture]
  TDecimalXHelperTest = class(TObject)
  public
    [Test]
    procedure SqrtTest;
    [Test]
    procedure IntPowerTest;
    [Test]
    procedure IntRootTest;
    [Test]
    procedure ExpTest;
    [Test]
    procedure LnTest;
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

procedure TDecimalXHelperTest.IntPowerTest;
var
  dec1: TDecimalX;
  s: String;
begin
  dec1 := TDecimalX.Create('0.42343');
  s := dec1.IntPower(-4, 30).ToString;
  Assert.IsTrue(s = '31.108101113585960182989900654048');
  dec1 := TDecimalX.Create('3.9');
  s := dec1.IntPower(8, 8).ToString;
  Assert.IsTrue(s = '53520.09260481');
end;

procedure TDecimalXHelperTest.IntRootTest;
var
  dec1: TDecimalX;
  s: String;
begin
  dec1 := TDecimalX.Create('4.2345');
  s := dec1.IntRoot(2, 30).ToString;
  Assert.IsTrue(s = '2.0577900767571020629770974914148');

end;

procedure TDecimalXHelperTest.ExpTest;
var
  dec1: TDecimalX;
  s: String;
begin
  dec1 := TDecimalX.Create('1');
  s := dec1.Exp(46).ToString;
  Assert.IsTrue(s = '2.7182818284590452353602874713526624977572470937');
  dec1 := TDecimalX.Create('-0.5');
  s := dec1.Exp(32).ToString;
  Assert.IsTrue(s = '0.60653065971263342360379953499118');

end;

procedure TDecimalXHelperTest.LnTest;
var
  dec1: TDecimalX;
  s: String;
begin
  dec1 := TDecimalX.Create('2.65');
  s := dec1.Ln(32).ToString;
  Assert.IsTrue(s = '0.97455963999813084070924556288652');

end;

initialization

TDUnitX.RegisterTestFixture(TDecimalXHelperTest);

end.
