unit DecimalXHelper;

interface

uses
  SysUtils, IntegerX, DecimalX;

type
  TDecimalXHelper = record helper for TDecimalX
  public

    /// <summary>
    /// Compute the square root of self to a given scale, Using Newton's
    /// algorithm. x &gt;= 0.
    /// </summary>
    /// <param name="scale">
    /// the desired <c>scale</c> of the result. (where the <c>scale</c> is
    /// the number of digits to the right of the decimal point.
    /// </param>
    /// <returns>
    /// the result value
    /// </returns>
    /// <exception cref="EArgumentException">
    /// if <c>scale</c> is &lt;= 0.
    /// </exception>
    /// <exception cref="EIllegalArgumentException">
    /// if <c>self</c> is &lt; 0.
    /// </exception>

    function Sqrt(scale: Integer): TDecimalX;

  end;

  EIllegalArgumentException = class(Exception);

resourcestring
  NegativeSquareRoot = 'Cannot compute squareroot of Negative number.';
  SqrtScaleInvalid = 'Scale cannot be <= 0.';

implementation

function TDecimalXHelper.Sqrt(scale: Integer): TDecimalX;
var
  x: TDecimalX;
  n, ix, ixPrev: TIntegerX;
  bits: Integer;
begin
  x := Self;
  // Check that scale > 0.
  if (scale <= 0) then
    raise EArgumentException.Create(SqrtScaleInvalid);
  // Check that x >= 0.
  if (x.signum() < 0) then
    raise EIllegalArgumentException.Create(NegativeSquareRoot);

  if (x.signum() = 0) then
  begin
    result := TDecimalX.Create(x.ToTIntegerX, -scale);
    Exit;
  end;

  // n = x*(10^(2*scale))
  n := x.movePointRight(scale shl 1).ToTIntegerX();

  // The first approximation is the upper half of n.
  bits := (n.bitLength() + 1) shr 1;
  ix := n.RightShift(bits);

  // Loop until the approximations converge
  // (two successive approximations are equal after rounding).
  while (ix.compareTo(ixPrev) <> 0) do
  begin
    ixPrev := ix;

    // x = (x + n/x)/2
    ix := ix.add(n.divide(ix)).RightShift(1);
  end;

  result := TDecimalX.Create(ix, -scale);
end;

end.
