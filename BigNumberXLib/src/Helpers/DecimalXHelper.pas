unit DecimalXHelper;

{
  * Copyright (c) 2015 Ugochukwu Mmaduekwe ugo4brain@gmail.com
  *   This Source Code Form is subject to the terms of the Mozilla Public License
  * v. 2.0. If a copy of the MPL was not distributed with this file, You can
  * obtain one at http://mozilla.org/MPL/2.0/.
  *   Neither the name of Ugochukwu Mmaduekwe nor the names of its contributors may
  *  be used to endorse or promote products derived from this software without
  *  specific prior written permission.
}

// Most Algorithms were gotten from numbercruncher.mathutils.BigFunctions (Java Number Cruncher).

interface

uses
  SysUtils, IntegerX, DecimalX;

type
  TDecimalXHelper = record helper for TDecimalX

  strict private
    function expTaylor(x: TDecimalX; scale: Integer): TDecimalX;
    (* **
      * Compute the natural logarithm of x to a given scale, x > 0.
      * Use Newton's algorithm.
      * *)
    function lnNewton(x: TDecimalX; scale: Integer): TDecimalX;

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

    /// <summary>
    /// Compute x^exponent to a given scale. Uses the same algorithm as class
    /// numbercruncher.mathutils.IntPower.
    /// </summary>
    /// <param name="exponent">
    /// the exponent value
    /// </param>
    /// <param name="scale">
    /// the desired <c>scale</c> of the result. (where the <c>scale</c> is
    /// the number of digits to the right of the decimal point.
    /// </param>
    /// <returns>
    /// the result value
    /// </returns>
    /// <exception cref="EArgumentException">
    /// if <c>scale</c> &lt; 0
    /// </exception>
    function IntPower(exponent: Int64; scale: Integer): TDecimalX;

    /// <summary>
    /// Compute the integral root of x to a given scale, x &gt;= 0 Using
    /// Newton's algorithm.
    /// </summary>
    /// <param name="index">
    /// the integral root value
    /// </param>
    /// <param name="scale">
    /// the desired <c>scale</c> of the result. (where the <c>scale</c> is
    /// the number of digits to the right of the decimal point.
    /// </param>
    /// <returns>
    /// the result value
    /// </returns>
    /// <exception cref="EArgumentException">
    /// if <c>scale</c> &lt; 0.
    /// </exception>
    /// <exception cref="EIllegalArgumentException">
    /// if <c>self</c> &lt; 0.
    /// </exception>
    function IntRoot(index: Int64; scale: Integer): TDecimalX;

    /// <summary>
    /// Compute e^x to a given scale. <br />Break x into its whole and
    /// fraction parts and compute (e^(1 + fraction/whole))^whole using
    /// Taylor's formula.
    /// </summary>
    /// <param name="scale">
    /// the desired <c>scale</c> of the result. (where the <c>scale</c> is
    /// the number of digits to the right of the decimal point.
    /// </param>
    /// <returns>
    /// the result value
    /// </returns>
    /// <exception cref="EArgumentException">
    /// if <c>scale</c> &lt;= 0.
    /// </exception>
    function Exp(scale: Integer): TDecimalX;
    (* **
      * Compute the natural logarithm of x to a given scale, x > 0.
      * *)
    function Ln(scale: Integer): TDecimalX;
  private
    function CDivide(divisor: TDecimalX; scale: Integer;
      roundingMode: TRoundingMode): TDecimalX;

  end;

  EIllegalArgumentException = class(Exception);

resourcestring
  NegativeSquareRoot = 'Cannot compute squareroot of Negative number.';
  SqrtScaleInvalid = 'Scale cannot be <= 0.';
  InvalidScale = 'Scale cannot be < 0.';
  InvalidScale2 = 'Scale cannot be <= 0.';
  NegativeOrZeroNaturalLog =
    'Cannot compute Natural Log of Negative or Zero Number.';
  NegativeIntRoot = 'Cannot compute IntRoot of Negative Number';

implementation

function TDecimalXHelper.IntPower(exponent: Int64; scale: Integer): TDecimalX;
var
  x, a, power: TDecimalX;
begin
  x := Self;
  // Check that scale >= 0.
  if (scale < 0) then
    raise EArgumentException.Create(InvalidScale);

  if exponent < 0 then
  begin
    a := TDecimalX.Create(1);
    result := a.CDivide(x.IntPower(-exponent, scale), scale,
      TRoundingMode.HalfEven);
    Exit;
  end;

  power := TDecimalX.Create(1);

  // Loop to compute value^exponent.
  while (exponent > 0) do
  begin

    // Is the rightmost bit a 1?
    if ((exponent and 1) = 1) then
    begin
      power := power.multiply(x);
      power := Rescale(power, -scale, TRoundingMode.HalfEven);
    end;

    // Square x and shift exponent 1 bit to the right.
    x := x.multiply(x);
    x := Rescale(x, -scale, TRoundingMode.HalfEven);
    exponent := TIntegerX.Asr(exponent, 1);

  end;

  result := power;

end;

function TDecimalXHelper.IntRoot(index: Int64; scale: Integer): TDecimalX;
var
  x, n, i, im1, tolerance, xPrev, xToIm1, xToI, numerator,
    denominator: TDecimalX;
  sp1: Integer;
begin
  x := Self;
  // Check that scale >= 0.
  if (scale < 0) then
    raise EArgumentException.Create(InvalidScale);
  // Check that x >= 0.
  if (x.signum() < 0) then
    raise EIllegalArgumentException.Create(NegativeIntRoot);

  sp1 := scale + 1;
  n := x;
  i := TDecimalX.Create(index);
  im1 := TDecimalX.Create(index - 1);
  tolerance := TDecimalX.Create(5);
  tolerance := tolerance.movePointLeft(sp1);

  // The initial approximation is x/index.
  x := x.CDivide(i, scale, TRoundingMode.HalfEven);

  // Loop until the approximations converge
  // (two successive approximations are equal after rounding).
  repeat
    // x^(index-1)
    xToIm1 := x.IntPower(index - 1, sp1);

    // x^index
    xToI := x.multiply(xToIm1);
    xToI := Rescale(xToI, -sp1, TRoundingMode.HalfEven);

    // n + (index-1)*(x^index)
    numerator := n.add(im1.multiply(xToI));
    numerator := Rescale(numerator, -sp1, TRoundingMode.HalfEven);

    // (index*(x^(index-1))
    denominator := i.multiply(xToIm1);
    denominator := Rescale(denominator, -sp1, TRoundingMode.HalfEven);

    // x = (n + (index-1)*(x^index)) / (index*(x^(index-1)))
    xPrev := x;
    x := numerator.CDivide(denominator, sp1, TRoundingMode.Down);
  until (x.subtract(xPrev).abs().compareTo(tolerance) <= 0);

  result := x;
end;

function TDecimalXHelper.Exp(scale: Integer): TDecimalX;
var
  x, a, xWhole, xFraction, z, t, maxLong, tempRes, b: TDecimalX;
begin
  x := Self;
  // Check that scale > 0.
  if (scale <= 0) then
    raise EArgumentException.Create(InvalidScale2);
  // e^0 = 1
  if (x.signum() = 0) then
  begin
    result := TDecimalX.Create(1);
    Exit;
  end

  // If x is negative, return 1/(e^-x).
  else if (x.signum() = -1) then
  begin
    a := TDecimalX.Create(1);
    result := a.CDivide(x.Negate().Exp(scale), scale, TRoundingMode.HalfEven);
    Exit;
  end;

  // Compute the whole part of x.
  xWhole := Rescale(x, 0, TRoundingMode.Down);

  // If there isn't a whole part, compute and return e^x.
  if (xWhole.signum() = 0) then
  begin
    result := expTaylor(x, scale);
    Exit;
  end;

  // Compute the fraction part of x.
  xFraction := x.subtract(xWhole);

  // z = 1 + fraction/whole
  b := TDecimalX.Create(1);
  z := b.add(xFraction.CDivide(xWhole, scale, TRoundingMode.HalfEven));

  // t = e^z
  t := expTaylor(z, scale);

  maxLong := TDecimalX.Create(Int64.MaxValue);
  tempRes := TDecimalX.Create(1);

  // Compute and return t^whole using IntPower().
  // If whole > Int64.MaxValue, then first compute products
  // of e^Int64.MaxValue.
  while (xWhole.compareTo(maxLong) >= 0) do
  begin
    tempRes := tempRes.multiply(t.IntPower(Int64.MaxValue, scale));
    tempRes := Rescale(tempRes, -scale, TRoundingMode.HalfEven);
    xWhole := xWhole.subtract(maxLong);

  end;
  result := tempRes.multiply(t.IntPower(xWhole.ToInt64, scale));
  result := Rescale(result, -scale, TRoundingMode.HalfEven);
end;

function TDecimalXHelper.expTaylor(x: TDecimalX; scale: Integer): TDecimalX;
var
  factorial, xPower, sumPrev, sum, term: TDecimalX;
  i: Integer;

begin

  factorial := TDecimalX.Create(1);
  xPower := x;

  // 1 + x
  sum := x.add(TDecimalX.Create(1));

  // Loop until the sums converge
  // (two successive sums are equal after rounding).
  i := 2;
  repeat
    // x^i
    xPower := xPower.multiply(x);
    xPower := Rescale(xPower, -scale, TRoundingMode.HalfEven);

    // i!
    factorial := factorial.multiply(TDecimalX.Create(i));

    // x^i/i!
    term := xPower.CDivide(factorial, scale, TRoundingMode.HalfEven);

    // sum = sum + x^i/i!
    sumPrev := sum;
    sum := sum.add(term);

    Inc(i);
  until (sum.compareTo(sumPrev) = 0);

  result := sum;
end;

function TDecimalXHelper.Ln(scale: Integer): TDecimalX;
var
  x, root, lnRoot, a: TDecimalX;
  magnitude: Integer;
begin
  x := Self;
  // Check that scale > 0.
  if (scale <= 0) then
    raise EArgumentException.Create(InvalidScale2);

  // Check that x > 0.
  if (x.signum() <= 0) then
    raise EIllegalArgumentException.Create(NegativeOrZeroNaturalLog);

  // The number of digits to the left of the decimal point.
  magnitude := x.ToString().Length - (-x.exponent) - 1;

  if (magnitude < 3) then
  begin
    result := lnNewton(x, scale);
    Exit;
  end

  // Compute magnitude*ln(x^(1/magnitude)).
  else
  begin

    // x^(1/magnitude)
    root := x.IntRoot(magnitude, scale);

    // ln(x^(1/magnitude))
    lnRoot := lnNewton(root, scale);

    // magnitude*ln(x^(1/magnitude))
    a := TDecimalX.Create(magnitude);
    result := a.multiply(lnRoot);
    result := Rescale(result, -scale, TRoundingMode.HalfEven);

  end;
end;

function TDecimalXHelper.lnNewton(x: TDecimalX; scale: Integer): TDecimalX;
var
  sp1: Integer;
  n, term, tolerance, eToX: TDecimalX;
begin
  sp1 := scale + 1;
  n := x;

  // Convergence tolerance = 5*(10^-(scale+1))
  tolerance := TDecimalX.Create(5);
  tolerance := tolerance.movePointLeft(sp1);

  // Loop until the approximations converge
  // (two successive approximations are within the tolerance).
  repeat
    // e^x
    eToX := x.Exp(sp1);

    // (e^x - n)/e^x
    term := eToX.subtract(n).CDivide(eToX, sp1, TRoundingMode.Down);

    // x - (e^x - n)/e^x
    x := x.subtract(term);
  until (term.compareTo(tolerance) <= 0);

  x := Rescale(x, -scale, TRoundingMode.HalfEven);
  result := x;
end;

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

function TDecimalXHelper.CDivide(divisor: TDecimalX; scale: Integer;
  roundingMode: TRoundingMode): TDecimalX;
var
  dividend: TDecimalX;

begin

  (* /*
    * Rescale dividend or divisor (whichever can be "upscaled" to
    * produce correctly scaled quotient).
    * Take care to detect out-of-range scales
    */ *)
  dividend := Self;
  if (Self.checkExponent(Int64(scale) + -divisor.exponent) > -dividend.exponent)
  then

    dividend := Rescale(dividend, -scale + divisor.exponent,
      TRoundingMode.Unnecessary)
  else
    divisor := Rescale(divisor,
      (Self.checkExponent(Int64(dividend.exponent) - (-scale))),
      TRoundingMode.Unnecessary);

  result := TDecimalX.Create(RoundingDivide2(dividend.Coefficient,
    divisor.Coefficient, roundingMode), -scale);
end;

end.
