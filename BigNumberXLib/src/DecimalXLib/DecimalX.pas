unit DecimalX;

{
  * Copyright (c) 2015 Ugochukwu Mmaduekwe ugo4brain@gmail.com
  *   This Source Code Form is subject to the terms of the Mozilla Public License
  * v. 2.0. If a copy of the MPL was not distributed with this file, You can
  * obtain one at http://mozilla.org/MPL/2.0/.
  *   Neither the name of Ugochukwu Mmaduekwe nor the names of its contributors may
  *  be used to endorse or promote products derived from this software without
  *  specific prior written permission.
}

interface

uses

  SysUtils, Math, TypInfo, IntegerX;

type

  /// <summary>
  /// Indicates the rounding algorithm (behavior) to use for <see cref="TDecimalX" /> operations.
  /// </summary>
  /// <remarks> The round-05up algorithm mentioned in GDAS have not been implemented.</remarks>
  TRoundingMode = (
    /// <summary>
    /// Round away from 0.
    /// </summary>
    Up,

    /// <summary>
    /// Truncate (round toward 0).
    /// </summary>
    Down,

    /// <summary>
    /// Round toward positive infinity.
    /// </summary>
    Ceiling,

    /// <summary>
    /// Round toward negative infinity.
    /// </summary>
    Floor,

    /// <summary>
    /// Round to nearest neighbor, round up if equidistant.
    /// </summary>
    HalfUp,

    /// <summary>
    /// Round to nearest neighbor, round down if equidistant.
    /// </summary>
    HalfDown,

    /// <summary>
    /// Round to nearest neighbor, round to even neighbor if equidistant.
    /// </summary>
    HalfEven,

    /// <summary>
    /// Do not do any rounding.
    /// </summary>
    /// <remarks>This value is not part of the GDAS, but is in java.math.BigDecimal.</remarks>
    Unnecessary);

type
  /// <summary>
  /// Immutable Record which encapsulates the context settings which describes certain rules for <see cref="TDecimalX" /> operations.
  /// </summary>
  TContext = record
  public
    /// <summary>
    /// The number of digits to be used.  (0 = unlimited)
    /// </summary>
    _precision: UInt32;
    /// <summary>
    /// The rounding algorithm (mode) to be used.
    /// </summary>
    _roundingMode: TRoundingMode;
  strict private
    /// <summary>
    /// Getter function for <see cref="TContext.Precision" />
    /// </summary>
    function GetPrecision: UInt32;
    /// <summary>
    /// Getter function for <see cref="TContext.RoundingMode" />
    /// </summary>
    function GetRoundingMode: TRoundingMode;
    /// <summary>
    /// Getter function for <see cref="TContext.BASIC_DEFAULT" />
    /// </summary>
    class function GetBasicDefault(): TContext; static;
    /// <summary>
    /// Getter function for <see cref="TContext.Decimal32" />
    /// </summary>
    class function GetDecimal32(): TContext; static;
    /// <summary>
    /// Getter function for <see cref="TContext.Decimal64" />
    /// </summary>
    class function GetDecimal64(): TContext; static;
    /// <summary>
    /// Getter function for <see cref="TContext.Decimal128" />
    /// </summary>
    class function GetDecimal128(): TContext; static;
    /// <summary>
    /// Getter function for <see cref="TContext.Unlimited" />
    /// </summary>
    class function GetUnlimited(): TContext; static;
    class constructor Create();

  public
    /// <summary>
    /// The number of digits to be used.  (0 = unlimited)
    /// </summary>
    property Precision: UInt32 read GetPrecision;
    /// <summary>
    /// The rounding algorithm (mode) to be used.
    /// </summary>
    property RoundingMode: TRoundingMode read GetRoundingMode;
    /// <summary>
    /// A <see cref="TContext" /> with a precision setting of Precision= 9 digits, RoundingMode= <see cref="HalfUp" />
    /// </summary>
    class property BASIC_DEFAULT: TContext read GetBasicDefault;
    /// <summary>
    /// A <see cref="TContext" /> with a precision setting matching the IEEE 754R
    /// Decimal32 format, 7 digits, and a rounding mode of <see cref="HalfEven" /> the IEEE
    /// 754R default.
    /// </summary>
    class property Decimal32: TContext read GetDecimal32;
    /// <summary>
    /// A <see cref="TContext" /> with a precision setting matching the IEEE 754R
    /// Decimal64 format, 16 digits, and a rounding mode of <see cref="HalfEven" /> the IEEE
    /// 754R default.
    /// </summary>
    class property Decimal64: TContext read GetDecimal64;
    /// <summary>
    /// A <see cref="TContext" /> with a precision setting matching the IEEE 754R
    /// Decimal128 format, 34 digits, and a rounding mode of <see cref="HalfEven" /> the IEEE
    /// 754R default.
    /// </summary>
    class property Decimal128: TContext read GetDecimal128;
    /// <summary>
    /// A <see cref="TContext" /> whose settings have the values required for
    /// unlimited precision arithmetic.
    /// The values of the settings are: Precision=0 RoundingMode= <see cref="HalfUp" />
    /// </summary>
    class property Unlimited: TContext read GetUnlimited;

    /// <summary>
    /// A custom function to create a <see cref="TContext" /> by supplying
    /// only a Precision. It uses an already defined RoundingMode= <see cref="HalfEven" />
    /// </summary>
    /// <param name="Precision">
    /// Precision to Use
    /// </param>
    /// <returns>A <see cref="TContext" /> with specified parameters.</returns>
    class function ExtendedDefault(Precision: UInt32): TContext; static;

    constructor Create(Precision: UInt32; mode: TRoundingMode); overload;
    constructor Create(Precision: UInt32); overload;

    class operator Equal(c1: TContext; c2: TContext): Boolean;
    class operator NotEqual(c1: TContext; c2: TContext): Boolean;
    function Equals(other: TContext): Boolean;
    function ToString(): String;
    function RoundingNeeded(bi: TIntegerX): Boolean;

    class var

    /// <summary>
    /// <see cref="TFormatSettings" /> used in <see cref="TContext" /> and <see cref="TDecimalX" />.
    /// </summary>
      _TCFS: TFormatSettings;

  end;

type

  /// <summary>
  /// Numeric Record which represents Immutable, arbitrary-precision signed decimals.
  /// </summary>
  /// <remarks>
  /// <para>
  /// This Record is inspired by the ( <see href="http://speleotrove.com/decimal/decarith.html">
  /// General Decimal Arithmetic Specification</see>) (PDF: <see href="http://speleotrove.com/decimal/decarith.pdf">
  /// General Decimal Arithmetic Specification.PDF</see>). However, at
  /// the moment, the interface and capabilities comes closer to
  /// java.math.BigDecimal.
  /// </para>
  /// <para>
  /// Because of this, as in j.m.BigDecimal, the implementation is
  /// closest to the X3.274 subset described in Appendix A of the GDAS:
  /// infinite values, NaNs, subnormal values and negative zero are not
  /// represented, and most conditions throw exceptions. Exponent limits
  /// in the context are not implemented, except a limit to the range of
  /// an Integer (Int32).
  /// </para>
  /// <para>
  /// The representation is an arbitrary precision integer (the signed
  /// coefficient, also called the unscaled value) and an exponent. The
  /// exponent is limited to the range of an Integer (Int32). The value of a
  /// BigDecimal representation is <c>coefficient * 10^exponent</c>.
  /// </para>
  /// <para>
  /// Note: the representation in the GDAS is [sign,coefficient,exponent]
  /// with sign = 0/1 for (pos/neg) and an unsigned coefficient. This
  /// yields signed zero, which we do not have. We used a <see cref="TIntegerX" />
  /// (BigInteger) for the signed coefficient. That record does not have
  /// a representation for signed zero.
  /// </para>
  /// <para>
  /// Note: Compared to j.m.BigDecimal, our coefficient = their <c>
  /// unscaledValue</c> and our exponent is the negation of their <c>
  /// scale</c>.
  /// </para>
  /// <para>
  /// The representation also track the number of significant digits.
  /// This is usually the number of digits in the coefficient, except
  /// when the coefficient is zero. This value is computed lazily and
  /// cached.
  /// </para>
  /// <para>
  /// This is not a clean-room implementation. other code was examined,
  /// especially OpenJDK implementation of java.math.BigDecimal, to look
  /// for special cases and other gotchas.
  /// credit was given in the few places where unthinking translation was done.
  /// However, there are only so many ways to
  /// skim certain cats, so some similarities are unavoidable.
  /// </para>
  /// </remarks>

  TDecimalX = record

    /// <summary>
    /// The coefficient of this <see cref="TDecimalX" />.
    /// </summary>
    _coeff: TIntegerX;

    /// <summary>
    /// The exponent of this <see cref="TDecimalX" />.
    /// </summary>
    _exp: Integer;

    /// <summary>
    /// Get the precision (number of decimal digits) of this <see cref="TDecimalX" />.
    /// </summary>
    /// <remarks>The value 0 indicated that the number is not known.</remarks>
    _precision: UInt32;

  strict private
    function GetCoefficient: TIntegerX;
    function GetExponent: Integer;
    function GetPrecision: UInt32;
    function CheckExponent(candidate: Int64; out Exponent: Integer)
      : Boolean; overload;
    function CheckExponent(candidate: Int64): Integer; overload;
    function StripZerosToMatchExponent(preferredExp: Int64): TDecimalX;
    class constructor Create();
    /// <summary>
    /// Create a <see cref="TDecimalX" /> with given coefficient, exponent, and precision.
    /// </summary>
    /// <param name="coeff">The coefficient</param>
    /// <param name="exp">The exponent</param>
    /// <param name="Precision">The precision</param>
    /// <remarks>For internal use only.  We can't trust someone outside to set the precision for us.
    /// Only for use when we know the precision explicitly.</remarks>
    constructor Create(coeff: TIntegerX; exp: Integer;
      Precision: UInt32); overload;

  const
    /// <summary>
    /// Min Integer value.
    /// </summary>
    MinIntValue: Integer = -2147483648;
    /// <summary>
    /// Max Integer value.
    /// </summary>
    MaxIntValue: Integer = 2147483647;
    /// <summary>
    /// Max Int64 value.
    /// </summary>
    MaxInt64Value: Int64 = 9223372036854775807;
    /// <summary>
    /// Exponent bias in the 64-bit floating point representation.
    /// </summary>
    DoubleExponentBias = Integer(1023);

    /// <summary>
    /// The size in bits of the significand in the 64-bit floating point representation.
    /// </summary>
    DoubleSignificandBitLength = Integer(52);

    /// <summary>
    /// How much to shift to accommodate the exponent and the binary digits of the significand.
    /// </summary>
    DoubleShiftBias = Integer(DoubleExponentBias + DoubleSignificandBitLength);

    DoublePositiveInfinity: Double = 1.0 / 0.0;

    DoubleNegativeInfinity: Double = -1.0 / 0.0;

    /// <summary>
    /// Allowed Digits.
    /// </summary>
{$WARNINGS OFF}
    Digits: TSysCharSet = ['0' .. '9'];
{$WARNINGS ON}
    /// <summary>
    /// Creates TArray&lt;Char&gt; from a string.
    /// </summary>
    /// <param name="S">string to use</param>
    /// <returns>TArray&lt;Char&gt;</returns>
    class function ToCharArray(const S: String): TArray<Char>; inline; static;

    class function BIPowerOfTen(n: Integer): TIntegerX; static;

    /// <summary>
    /// Check to see if the result of exponent arithmetic is valid.
    /// </summary>
    /// <param name="candidate">The value resulting from exponent arithmetic.</param>
    /// <param name="IsZero">Are we computing an exponent for a zero coefficient?</param>
    /// <param name="Exponent">The exponent to use</param>
    /// <returns>True if the candidate is valid, false otherwise.</returns>
    /// <remarks>
    /// <para>Exponent arithmetic during various operations may result in values
    /// that are out of range of an Integer.  We can do the computation as a long,
    /// then use this to make sure the result is okay to use.</para>
    /// <para>If the exponent is out of range, but the coefficient is zero,
    /// the exponent in some sense is not that relevant, so we just clamp to
    /// the appropriate (pos/neg) extreme value for Integer.  (This handling inspired by
    /// the OpenJDK implementation.)</para>
    /// </remarks>
    class function CheckExponent(candidate: Int64; IsZero: Boolean;
      out Exponent: Integer): Boolean; overload; static;

    /// <summary>
    /// Reduce exponent to Integer.  Throw error if out of range.
    /// </summary>
    /// <param name="candidate">The value resulting from exponent arithmetic.</param>
    /// <param name="isZero">Are we computing an exponent for a zero coefficient?</param>
    /// <returns>The exponent to use</returns>
    class function CheckExponent(candidate: Int64; IsZero: Boolean): Integer;
      overload; static;

    /// <summary>
    /// Getter function for <see cref="TDecimalX.Zero" />
    /// </summary>
    class function GetZero: TDecimalX; static;
    /// <summary>
    /// Getter function for <see cref="TDecimalX.One" />
    /// </summary>
    class function GetOne: TDecimalX; static;
    /// <summary>
    /// Getter function for <see cref="TDecimalX.Ten" />
    /// </summary>
    class function GetTen: TDecimalX; static;
    /// <summary>
    /// Parse a substring of a character array as a <see cref="TDecimalX" />.
    /// </summary>
    /// <param name="buf">
    /// The character array to parse
    /// </param>
    /// <param name="offset">
    /// Start index for parsing
    /// </param>
    /// <param name="len">
    /// Number of chars to parse.
    /// </param>
    /// <param name="throwOnError">
    /// If true, an error causes an exception to be thrown. If false, false
    /// is returned.
    /// </param>
    /// <param name="v">
    /// The <see cref="TDecimalX" /> corresponding to the characters.
    /// </param>
    /// <returns>
    /// True if successful, false if not (or throws if throwOnError is true).
    /// </returns>
    /// <remarks>
    /// Ugly. We could use a RegEx, but trying to avoid unnecessary
    /// allocation, I guess. [+-]?\d*(\.\d*)?([Ee][+-]?\d+)? with additional
    /// constraint that one of the two d* must have at least one char.
    /// </remarks>
    class function DoParse(buf: TArray<Char>; offset: Integer; len: Integer;
      throwOnError: Boolean; out v: TDecimalX): Boolean; static;

  public
    /// <summary>
    /// The coefficient of this <see cref="TDecimalX" />.
    /// </summary>
    property Coefficient: TIntegerX read GetCoefficient;
    /// <summary>
    /// The exponent of this <see cref="TDecimalX" />.
    /// </summary>
    property Exponent: Integer read GetExponent;
    /// <summary>
    /// Get the (number of decimal digits) of this <see cref="TDecimalX" />.  Will trigger computation if not already known.
    /// </summary>
    /// <returns>The precision.</returns>
    property Precision: UInt32 read GetPrecision;

    procedure RoundInPlace(c: TContext);
    function Round(c: TContext): TDecimalX; overload;

    /// <summary>
    /// Create the canonical string representation for a <see cref="TDecimalX" />.
    /// </summary>
    /// <returns>string representation of <see cref="TDecimalX" />.</returns>
    function ToScientificString(): String;

    /// <summary>
    /// Return a string representing the <see cref="TDecimalX" /> value.
    /// </summary>
    /// <returns>string representation of <see cref="TDecimalX" />.</returns>
    function ToString(): String;

    function CompareTo(other: TDecimalX): Integer;

    function Equals(other: TDecimalX): Boolean;

    function ToDouble(): Double;

    function ToByte(): Byte;

    function ToShortInt(): ShortInt;

    function ToSmallInt(): SmallInt;

    function ToWord(): Word;

    function ToInteger(): Integer;

    function ToUInt32(): UInt32;

    function ToInt64(): Int64;

    function ToUInt64(): UInt64;

    function ToTIntegerX(): TIntegerX;

    /// <summary>
    /// A Zero.
    /// </summary>
    class property Zero: TDecimalX read GetZero;
    /// <summary>
    /// A Positive One.
    /// </summary>
    class property One: TDecimalX read GetOne;
    /// <summary>
    /// A Ten.
    /// </summary>
    class property Ten: TDecimalX read GetTen;
    /// <summary>
    /// Create a <see cref="TDecimalX" /> with given coefficient and exponent.
    /// </summary>
    /// <param name="coeff">The coefficient</param>
    /// <param name="exp">The exponent</param>
    constructor Create(coeff: TIntegerX; exp: Integer); overload;
    /// <summary>
    /// Creates a copy of given <see cref="TDecimalX" />.
    /// </summary>
    /// <param name="copy">A copy of the given <see cref="TDecimalX" /></param>
    /// <remarks>Really only needed internally.  TDecimalX's are immutable, so why copy?
    /// Internally, we sometimes need to copy and modify before releasing into the wild.</remarks>
    constructor Create(copy: TDecimalX); overload;

    /// <summary>
    ///
    /// </summary>
    /// <param name="v"><see cref="TDecimalX" /> to process</param>
    /// <param name="c"><see cref="TContext" /> to use</param>
    /// <returns>processed <see cref="TDecimalX" /></returns>
    /// <remarks>The OpenJDK implementation has an efficiency hack to only compute the precision
    /// (call to .GetPrecision) if the value is outside the range of the context's precision
    /// (-10^precision to 10^precision), with those bounds being cached on the Context.
    /// TODO: See if it is worth implementing the hack.
    /// </remarks>
    class function Round(v: TDecimalX; c: TContext): TDecimalX;
      overload; static;

    /// <summary>
    /// Create a <see cref="TDecimalX" /> from a double.
    /// </summary>
    /// <param name="v">The double value</param>
    /// <returns>A <see cref="TDecimalX" /> corresponding to the double value.</returns>
    /// <remarks>Watch out!  TDecimalX.Create(0.1) is not the same as TDecimalX.Parse("0.1").
    /// We create exact representations of doubles,
    /// and 1/10 does not have an exact representation as a double. So the double 1.0 is not exactly 1/10.</remarks>

    class function Create(v: Double): TDecimalX; overload; static;
    /// <summary>
    /// Create a <see cref="TDecimalX" /> from a double, rounded as specified.
    /// </summary>
    /// <param name="v">The double value</param>
    /// <param name="c">The rounding context</param>
    /// <returns>A <see cref="TDecimalX" /> corresponding to the double value, rounded as specified.</returns>
    /// <remarks>Watch out!  BigDecimal.Create(0.1) is not the same as BigDecimal.Parse("0.1").
    /// We create exact representations of doubles,
    /// and 1/10 does not have an exact representation as a double.  So the double 1.0 is not exactly 1/10.</remarks>
    class function Create(v: Double; c: TContext): TDecimalX; overload; static;
    /// <summary>
    /// Create a <see cref="TDecimalX" /> with the same value as the given
    // Integer.
    /// </summary>
    /// <param name="v">The initial value</param>
    /// <returns>A <see cref="TDecimalX" /> with the same value.</returns>
    class function Create(v: Integer): TDecimalX; overload; static;
    /// <summary>
    /// Create a <see cref="TDecimalX" /> with the same value as the given Integer, rounded appropriately.
    /// </summary>
    /// <param name="v">The initial value</param>
    /// <param name="c">The rounding context</param>
    /// <returns>A <see cref="TDecimalX" /> with the same value, appropriately rounded</returns>
    class function Create(v: Integer; c: TContext): TDecimalX; overload; static;
    /// <summary>
    /// Create a <see cref="TDecimalX" /> with the same value as the given UInt32.
    /// </summary>
    /// <param name="v">The initial value</param>
    /// <returns>A <see cref="TDecimalX" /> with the same value.</returns>
    class function Create(v: UInt32): TDecimalX; overload; static;
    /// <summary>
    /// Create a <see cref="TDecimalX" /> with the same value as the given UInt32, rounded appropriately.
    /// </summary>
    /// <param name="v">The initial value</param>
    /// <param name="c">The rounding context</param>
    /// <returns>A <see cref="TDecimalX" /> with the same value, appropriately rounded</returns>
    class function Create(v: UInt32; c: TContext): TDecimalX; overload; static;
    /// <summary>
    /// Create a <see cref="TDecimalX" /> with the same value as the given Int64.
    /// </summary>
    /// <param name="v">The initial value</param>
    /// <returns>A <see cref="TDecimalX" /> with the same value.</returns>
    class function Create(v: Int64): TDecimalX; overload; static;
    /// <summary>
    /// Create a <see cref="TDecimalX" /> with the same value as the given Int64, rounded appropriately.
    /// </summary>
    /// <param name="v">The initial value</param>
    /// <param name="c">The rounding context</param>
    /// <returns>A <see cref="TDecimalX" /> with the same value, appropriately rounded</returns>
    class function Create(v: Int64; c: TContext): TDecimalX; overload; static;
    /// <summary>
    /// Create a <see cref="TDecimalX" /> with the same value as the given UInt64.
    /// </summary>
    /// <param name="v">The initial value</param>
    /// <returns>A <see cref="TDecimalX" /> with the same value.</returns>
    class function Create(v: UInt64): TDecimalX; overload; static;
    /// <summary>
    /// Create a <see cref="TDecimalX" /> with the same value as the given UInt64, rounded appropriately.
    /// </summary>
    /// <param name="v">The initial value</param>
    /// <param name="c">The rounding context</param>
    /// <returns>A <see cref="TDecimalX" /> with the same value, appropriately rounded</returns>
    class function Create(v: UInt64; c: TContext): TDecimalX; overload; static;
    /// <summary>
    /// Create a <see cref="TDecimalX" /> with the same value as the given <see cref="TIntegerX" />.
    /// </summary>
    /// <param name="v">The initial value</param>
    /// <returns>A <see cref="TDecimalX" /> with the same value.</returns>
    class function Create(v: TIntegerX): TDecimalX; overload; static;
    /// <summary>
    /// Create a <see cref="TDecimalX" /> with the same value as the given <see cref="TIntegerX" />, rounded appropriately.
    /// </summary>
    /// <param name="v">The initial value</param>
    /// <param name="c">The rounding context</param>
    /// <returns>A <see cref="TDecimalX" /> with the same value, appropriately rounded</returns>
    class function Create(v: TIntegerX; c: TContext): TDecimalX;
      overload; static;
    /// <summary>
    /// Create a <see cref="TDecimalX" /> by parsing a string.
    /// </summary>
    /// <param name="v">The initial value</param>
    /// <returns>A <see cref="TDecimalX" /> with the same value.</returns>
    class function Create(v: String): TDecimalX; overload; static;
    /// <summary>
    /// Create a <see cref="TDecimalX" /> by parsing a string.
    /// </summary>
    /// <param name="v">The initial value</param>
    /// <param name="c">The context to use</param>
    /// <returns>A <see cref="TDecimalX" /> treated according to the passed context.</returns>
    class function Create(v: String; c: TContext): TDecimalX; overload; static;
    /// <summary>
    /// Create a <see cref="TDecimalX" /> by parsing a character array.
    /// </summary>
    /// <param name="v">The initial value</param>
    /// <returns>A <see cref="TDecimalX" /> with the same value.</returns>
    class function Create(v: TArray<Char>): TDecimalX; overload; static;
    /// <summary>
    /// Create a <see cref="TDecimalX" /> by parsing a character array.
    /// </summary>
    /// <param name="v">The initial value</param>
    /// <param name="c">The context to use</param>
    /// <returns>A <see cref="TDecimalX" /> treated according to the passed context.</returns>
    class function Create(v: TArray<Char>; c: TContext): TDecimalX;
      overload; static;
    /// <summary>
    /// Create a <see cref="TDecimalX" /> by parsing a segment of character array.
    /// </summary>
    /// <param name="v">The initial value</param>
    /// <param name="offset">offset to start from</param>
    /// <param name="len">length</param>
    /// <returns>A <see cref="TDecimalX" /> containing processed value.</returns>
    class function Create(v: TArray<Char>; offset: Integer; len: Integer)
      : TDecimalX; overload; static;
    /// <summary>
    /// Create a <see cref="TDecimalX" /> by parsing a segment of character array.
    /// </summary>
    /// <param name="v">The initial value</param>
    /// <param name="offset">offset to start from</param>
    /// <param name="len">length</param>
    /// <param name="c">The context to use</param>
    /// <returns>A <see cref="TDecimalX" /> containing processed value according to passed context.</returns>
    class function Create(v: TArray<Char>; offset: Integer; len: Integer;
      c: TContext): TDecimalX; overload; static;
    /// <summary>
    /// Create a <see cref="TDecimalX" /> from a string representation
    /// </summary>
    /// <param name="S">String to parse into <see cref="TDecimalX" /></param>
    /// <returns>A <see cref="TDecimalX" /> containing processed value.</returns>
    class function Parse(S: String): TDecimalX; overload; static;
    /// <summary>
    /// Create a <see cref="TDecimalX" /> from a string representation, rounded as indicated.
    /// </summary>
    /// <param name="S">String to parse into <see cref="TDecimalX" /></param>
    /// <param name="c">The context to use</param>
    /// <returns>A <see cref="TDecimalX" /> containing processed value according to passed context.</returns>
    class function Parse(S: String; c: TContext): TDecimalX; overload; static;
    /// <summary>
    /// Try to create a <see cref="TDecimalX" /> from a string representation.
    /// </summary>
    /// <param name="S">The string to convert</param>
    /// <param name="v">Set to the <see cref="TDecimalX" /> corresponding to the string.</param>
    /// <returns>True if successful, false if there is an error parsing.</returns>
    class function TryParse(S: String; out v: TDecimalX): Boolean;
      overload; static;
    /// <summary>
    /// Try to create a <see cref="TDecimalX" /> from a string representation, rounded as indicated.
    /// </summary>
    /// <param name="S">The string to convert</param>
    /// <param name="c">The rounding context</param>
    /// <param name="v">Set to the <see cref="TDecimalX" /> corresponding to the string.</param>
    /// <returns>True if successful, false if there is an error parsing.</returns>
    class function TryParse(S: String; c: TContext; out v: TDecimalX): Boolean;
      overload; static;
    /// <summary>
    /// Create a <see cref="TDecimalX" /> from an array of characters.
    /// </summary>
    /// <param name="buf">input char array</param>
    /// <returns>A <see cref="TDecimalX" /> containing processed value.</returns>
    class function Parse(buf: TArray<Char>): TDecimalX; overload; static;

    /// <summary>
    /// Create a <see cref="TDecimalX" /> from an array of characters, rounded as indicated.
    /// </summary>
    /// <param name="buf">input char array</param>
    /// <param name="c">context to use</param>
    /// <returns>A <see cref="TDecimalX" /> containing processed value according to passed context.</returns>
    class function Parse(buf: TArray<Char>; c: TContext): TDecimalX;
      overload; static;
    /// <summary>
    /// Try to create a <see cref="TDecimalX" /> from an array of characters.
    /// </summary>
    /// <param name="buf">input char array</param>
    /// <param name="v">out result</param>
    /// <returns>True if successful; false otherwise</returns>
    class function TryParse(buf: TArray<Char>; out v: TDecimalX): Boolean;
      overload; static;
    /// <summary>
    /// Try to create a <see cref="TDecimalX" /> from an array of characters, rounded as indicated.
    /// </summary>
    /// <param name="buf">input char array</param>
    /// <param name="c">context to use</param>
    /// <param name="v">out result</param>
    /// <returns>True if successful; false otherwise</returns>
    class function TryParse(buf: TArray<Char>; c: TContext; out v: TDecimalX)
      : Boolean; overload; static;

    /// <summary>
    /// Create a <see cref="TDecimalX" /> corresponding to a sequence of characters from an array.
    /// </summary>
    /// <param name="buf">input char array</param>
    /// <param name="offset">offset to start from</param>
    /// <param name="len">length</param>
    /// <returns>A <see cref="TDecimalX" /> containing processed value.</returns>
    class function Parse(buf: TArray<Char>; offset: Integer; len: Integer)
      : TDecimalX; overload; static;
    /// <summary>
    /// Create a <see cref="TDecimalX" /> corresponding to a sequence of characters from an array, rounded as indicated.
    /// </summary>
    /// <param name="buf">input char array</param>
    /// <param name="offset">offset to start from</param>
    /// <param name="len">length</param>
    /// <param name="c">context to use</param>
    /// <returns>A <see cref="TDecimalX" /> containing processed value according to passed context.</returns>
    class function Parse(buf: TArray<Char>; offset: Integer; len: Integer;
      c: TContext): TDecimalX; overload; static;
    /// <summary>
    /// Try to create a <see cref="TDecimalX" /> corresponding to a sequence of characters from an array.
    /// </summary>
    /// <param name="buf">input char array</param>
    /// <param name="offset">offset to start from</param>
    /// <param name="len">length</param>
    /// <param name="v">out result</param>
    /// <returns>True if successful; false otherwise</returns>
    class function TryParse(buf: TArray<Char>; offset: Integer; len: Integer;
      out v: TDecimalX): Boolean; overload; static;
    /// <summary>
    /// Try to create a <see cref="TDecimalX" /> corresponding to a sequence of characters from an array.
    /// </summary>
    /// <param name="buf">input char array</param>
    /// <param name="offset">offset to start from</param>
    /// <param name="len">length</param>
    /// <param name="c">context to use</param>
    /// <param name="v">out result</param>
    /// <returns>True if successful; false otherwise</returns>
    class function TryParse(buf: TArray<Char>; offset: Integer; len: Integer;
      c: TContext; out v: TDecimalX): Boolean; overload; static;

    class operator Explicit(value: TDecimalX): Double;
    class operator Explicit(value: TDecimalX): Byte;
    class operator Explicit(value: TDecimalX): ShortInt;
    class operator Explicit(value: TDecimalX): SmallInt;
    class operator Explicit(value: TDecimalX): Word;
    class operator Explicit(value: TDecimalX): Integer;
    class operator Explicit(value: TDecimalX): UInt32;
    class operator Explicit(value: TDecimalX): Int64;
    class operator Explicit(value: TDecimalX): UInt64;
    class operator Explicit(value: TDecimalX): TIntegerX;

    class operator Equal(x: TDecimalX; y: TDecimalX): Boolean;
    class operator NotEqual(x: TDecimalX; y: TDecimalX): Boolean;
    class operator LessThan(x: TDecimalX; y: TDecimalX): Boolean;
    class operator GreaterThan(x: TDecimalX; y: TDecimalX): Boolean;
    /// <summary>
    /// Compute <paramref name="x"/> + <paramref name="y"/>.
    /// </summary>
    /// <param name="x"></param>
    /// <param name="y"></param>
    /// <returns>The sum</returns>
    class operator Add(x: TDecimalX; y: TDecimalX): TDecimalX;
    /// <summary>
    /// Compute <paramref name="x"/> - <paramref name="y"/>.
    /// </summary>
    /// <param name="x"></param>
    /// <param name="y"></param>
    /// <returns>The difference</returns>
    class operator Subtract(x: TDecimalX; y: TDecimalX): TDecimalX;
    /// <summary>
    /// returns <paramref name="x"/>.
    /// </summary>
    /// <param name="x"></param>
    /// <returns>This</returns>
    class operator Positive(x: TDecimalX): TDecimalX;
    /// <summary>
    /// Compute the negation of <paramref name="x"/>.
    /// </summary>
    /// <param name="x"></param>
    /// <returns>The negation</returns>
    class operator Negative(x: TDecimalX): TDecimalX;
    /// <summary>
    /// Compute <paramref name="x"/> * <paramref name="y"/>.
    /// </summary>
    /// <param name="x"></param>
    /// <param name="y"></param>
    /// <returns>The product</returns>
    class operator Multiply(x: TDecimalX; y: TDecimalX): TDecimalX;
    /// <summary>
    /// Compute <paramref name="x"/> / <paramref name="y"/>.
    /// </summary>
    /// <param name="x"></param>
    /// <param name="y"></param>
    /// <returns>The quotient</returns>
    class operator Divide(x: TDecimalX; y: TDecimalX): TDecimalX;
    /// <summary>
    /// Compute <paramref name="x"/> mod <paramref name="y"/>.
    /// </summary>
    /// <param name="x"></param>
    /// <param name="y"></param>
    /// <returns>The modulus</returns>
    class operator Modulus(x: TDecimalX; y: TDecimalX): TDecimalX;

    /// <summary>
    /// Compute <paramref name="x"/> + <paramref name="y"/>.
    /// </summary>
    /// <param name="x"></param>
    /// <param name="y"></param>
    /// <returns>The sum</returns>
    class function Add(x: TDecimalX; y: TDecimalX): TDecimalX; overload; static;
    /// <summary>
    /// Compute <paramref name="x"/> + <paramref name="y"/> with the result rounded per the context.
    /// </summary>
    /// <param name="x"></param>
    /// <param name="y"></param>
    /// <param name="c">context to use</param>
    /// <returns>The sum</returns>
    class function Add(x: TDecimalX; y: TDecimalX; c: TContext): TDecimalX;
      overload; static;

    /// <summary>
    /// Compute <paramref name="x"/> - <paramref name="y"/>.
    /// </summary>
    /// <param name="x"></param>
    /// <param name="y"></param>
    /// <returns>The difference</returns>
    class function Subtract(x: TDecimalX; y: TDecimalX): TDecimalX;
      overload; static;
    /// <summary>
    /// Compute <paramref name="x"/> - <paramref name="y"/> with the result rounded per the context.
    /// </summary>
    /// <param name="x"></param>
    /// <param name="y"></param>
    /// <param name="c">context to use</param>
    /// <returns>The difference</returns>
    class function Subtract(x: TDecimalX; y: TDecimalX; c: TContext): TDecimalX;
      overload; static;
    /// <summary>
    /// Compute the negation of <paramref name="x"/>.
    /// </summary>
    /// <param name="x"></param>
    /// <param name="y"></param>
    /// <returns>The negation</returns>
    class function Negate(x: TDecimalX): TDecimalX; overload; static;
    /// <summary>
    /// Compute the negation of <paramref name="x"/>, with result rounded according to the context
    /// </summary>
    /// <param name="x"></param>
    /// <param name="y"></param>
    /// <param name="c">context to use</param>
    /// <returns>The negation</returns>
    class function Negate(x: TDecimalX; c: TContext): TDecimalX;
      overload; static;
    /// <summary>
    /// Compute <paramref name="x"/> * <paramref name="y"/>.
    /// </summary>
    /// <param name="x"></param>
    /// <param name="y"></param>
    /// <returns>The product</returns>
    class function Multiply(x: TDecimalX; y: TDecimalX): TDecimalX;
      overload; static;
    /// <summary>
    /// Compute <paramref name="x"/> * <paramref name="y"/>, with result rounded according to the context.
    /// </summary>
    /// <param name="x"></param>
    /// <param name="y"></param>
    /// <param name="c">context to use</param>
    /// <returns>The product</returns>
    class function Multiply(x: TDecimalX; y: TDecimalX; c: TContext): TDecimalX;
      overload; static;
    /// <summary>
    /// Compute <paramref name="x"/> / <paramref name="y"/>.
    /// </summary>
    /// <param name="x"></param>
    /// <param name="y"></param>
    /// <returns>The quotient</returns>
    class function Divide(x: TDecimalX; y: TDecimalX): TDecimalX;
      overload; static;
    /// <summary>
    /// Compute <paramref name="x"/> / <paramref name="y"/>, with result rounded according to the context.
    /// </summary>
    /// <param name="x"></param>
    /// <param name="y"></param>
    /// <param name="c">context to use</param>
    /// <returns>The quotient</returns>
    class function Divide(x: TDecimalX; y: TDecimalX; c: TContext): TDecimalX;
      overload; static;
    /// <summary>
    /// Returns <paramref name="x"/> mod <paramref name="y"/>.
    /// </summary>
    /// <param name="x"></param>
    /// <param name="y"></param>
    /// <returns>The modulus</returns>
    class function Modulus(x: TDecimalX; y: TDecimalX): TDecimalX;
      overload; static;
    /// <summary>
    /// Returns <paramref name="x"/> mod <paramref name="y"/>, with result rounded according to the context.
    /// </summary>
    /// <param name="x"></param>
    /// <param name="y"></param>
    /// <param name="c">context to use</param>
    /// <returns>The modulus</returns>
    class function Modulus(x: TDecimalX; y: TDecimalX; c: TContext): TDecimalX;
      overload; static;
    /// <summary>
    /// Compute the quotient and remainder of dividing one <see cref="TDecimalX"/> by another.
    /// </summary>
    /// <param name="x"></param>
    /// <param name="y"></param>
    /// <param name="remainder">Set to the remainder after division</param>
    /// <returns>The quotient</returns>
    class function DivRem(x: TDecimalX; y: TDecimalX; out remainder: TDecimalX)
      : TDecimalX; overload; static;
    /// <summary>
    /// Compute the quotient and remainder of dividing one <see cref="TDecimalX"/> by another, with result rounded according to the context.
    /// </summary>
    /// <param name="x"></param>
    /// <param name="y"></param>
    /// <param name="c">context to use</param>
    /// <param name="remainder">Set to the remainder after division</param>
    /// <returns>The quotient</returns>
    class function DivRem(x: TDecimalX; y: TDecimalX; c: TContext;
      out remainder: TDecimalX): TDecimalX; overload; static;
    /// <summary>
    /// Compute the absolute value.
    /// </summary>
    /// <param name="x"></param>
    /// <returns>The absolute value</returns>
    class function Abs(x: TDecimalX): TDecimalX; overload; static;
    /// <summary>
    /// Compute the absolute value, with result rounded according to the context.
    /// </summary>
    /// <param name="x"></param>
    /// <param name="c">context to use</param>
    /// <returns>The absolute value</returns>
    class function Abs(x: TDecimalX; c: TContext): TDecimalX; overload; static;
    /// <summary>
    /// Computes a <see cref="TIntegerX"/> raised to an integer power.
    /// </summary>
    /// <param name="x">The value to exponentiate</param>
    /// <param name="exp">The exponent</param>
    /// <returns>The exponent</returns>
    class function Power(x: TDecimalX; exp: Integer): TDecimalX;
      overload; static;
    /// <summary>
    /// Computes a <see cref="TIntegerX"/> raised to an integer power, with result rounded according to the context.
    /// </summary>
    /// <param name="x">The value to exponentiate</param>
    /// <param name="exp">The exponent</param>
    /// <param name="c">context to use</param>
    /// <returns>The exponent</returns>
    class function Power(x: TDecimalX; exp: Integer; c: TContext): TDecimalX;
      overload; static;
    /// <summary>
    /// Returns "x".
    /// </summary>
    /// <param name="x"></param>
    /// <returns>"x"</returns>
    class function Plus(x: TDecimalX): TDecimalX; overload; static;
    /// <summary>
    /// Returns "x" rounded to context.
    /// </summary>
    /// <param name="x"></param>
    /// <param name="c">context to use</param>
    /// <returns>"x" rounded to context</returns>
    class function Plus(x: TDecimalX; c: TContext): TDecimalX; overload; static;
    /// <summary>
    /// Returns the negation of "x".
    /// </summary>
    /// <param name="x"></param>
    /// <returns>"x" negated</returns>
    class function Minus(x: TDecimalX): TDecimalX; overload; static;
    /// <summary>
    /// Returns the negation of "x" rounded to context.
    /// </summary>
    /// <param name="x"></param>
    /// <param name="c">context to use</param>
    /// <returns>"x" negated and rounded to context</returns>
    class function Minus(x: TDecimalX; c: TContext): TDecimalX;
      overload; static;
    /// <summary>
    /// Assuming
    /// </summary>
    /// <param name="x"></param>
    /// <param name="y"></param>
    /// <param name="mode"></param>
    /// <returns></returns>
    class function RoundingDivide2(x: TIntegerX; y: TIntegerX;
      mode: TRoundingMode): TIntegerX; static;
    class function Quantize(lhs: TDecimalX; rhs: TDecimalX; mode: TRoundingMode)
      : TDecimalX; overload; static;
    class function Rescale(lhs: TDecimalX; newExponent: Integer;
      mode: TRoundingMode): TDecimalX; overload; static;

    function Quantize(v: TDecimalX; mode: TRoundingMode): TDecimalX; overload;
    /// <summary>
    /// Returns self + y.
    /// </summary>
    /// <param name="y">The augend.</param>
    /// <returns>The sum</returns>
    function Add(y: TDecimalX): TDecimalX; overload;
    /// <summary>
    /// Returns self + y, with the result rounded according to the context.
    /// </summary>
    /// <param name="y">The augend.</param>
    /// <param name="c">context to use.</param>
    /// <returns>The sum</returns>
    /// <remarks>Translated the Sun Java code pretty directly.</remarks>
    function Add(y: TDecimalX; c: TContext): TDecimalX; overload;
    /// <summary>
    /// Change either x or y by a power of 10 in order to align them.
    /// </summary>
    /// <param name="x"></param>
    /// <param name="y"></param>
    class procedure Align(var x: TDecimalX; var y: TDecimalX); static;
    /// <summary>
    /// Modify a larger <see cref="TDecimalX" /> to have the same exponent as a smaller one by multiplying the coefficient by a power of 10.
    /// </summary>
    /// <param name="big"></param>
    /// <param name="small"></param>
    /// <returns>computed value</returns>
    class function ComputeAlign(big: TDecimalX; small: TDecimalX)
      : TDecimalX; static;
    /// <summary>
    /// Returns self - y
    /// </summary>
    /// <param name="y">The subtrahend</param>
    /// <returns>The difference</returns>
    function Subtract(y: TDecimalX): TDecimalX; overload;
    /// <summary>
    /// Returns self - y
    /// </summary>
    /// <param name="y">The subtrahend</param>
    /// <param name="c">context to use</param>
    /// <returns>The difference</returns>
    function Subtract(y: TDecimalX; c: TContext): TDecimalX; overload;
    /// <summary>
    /// Returns the negation of this value.
    /// </summary>
    /// <returns>The negation</returns>
    function Negate(): TDecimalX; overload;
    /// <summary>
    /// Returns the negation of this value, with result rounded according to the context.
    /// </summary>
    /// <param name="c">context to use</param>
    /// <returns>The negation rounded to context</returns>
    function Negate(c: TContext): TDecimalX; overload;
    /// <summary>
    /// Returns self * y
    /// </summary>
    /// <param name="y">The multiplicand</param>
    /// <returns>The product</returns>
    function Multiply(y: TDecimalX): TDecimalX; overload;
    /// <summary>
    /// Returns self * y
    /// </summary>
    /// <param name="y">The multiplicand</param>
    /// <param name="c">context to use</param>
    /// <returns>The product</returns>
    function Multiply(y: TDecimalX; c: TContext): TDecimalX; overload;
    /// <summary>
    /// Returns self / divisor.
    /// </summary>
    /// <param name="divisor">The divisor</param>
    /// <returns>The division result</returns>
    /// <exception cref="EArithmeticException">If rounding mode is TRoundingMode.UNNECESSARY and we have a repeating fraction"</exception>
    /// <remarks>I completely ripped off the OpenJDK implementation.
    /// Their analysis of the basic algorithm I could not compete with.</remarks>
    function Divide(divisor: TDecimalX): TDecimalX; overload;
    /// <summary>
    /// Returns self / rhs.
    /// </summary>
    /// <param name="rhs">right hand side (divisor)</param>
    /// <param name="c">The context</param>
    /// <returns>The division result</returns>
    /// <remarks>
    /// <para>The specification talks about the division algorithm in terms of repeated subtraction.
    /// I'll try to re-analyze this in terms of divisions on integers.</para>
    /// <para>Assume we want to divide one <see cref="TDecimalX" /> by another:</para>
    /// <code> [x,a] / [y,b] = [(x/y), a-b]</code>
    /// <para>where [x,a] signifies x is integer, a is exponent so [x,a] has value x * 10^a.
    /// Here, (x/y) indicates a result rounded to the desired precision p. For the moment, assume x, y non-negative.</para>
    /// <para>We want to compute (x/y) using integer-only arithmetic, yielding a quotient+remainder q+r
    /// where q has up to p precision and r is used to compute the rounding.  So actually, the result will be [q, a-b+c],
    /// where c is some adjustment factor to make q be in the range [0,10^0).</para>
    /// <para>We will need to adjust either x or y to make sure we can compute x/y and make q be in this range.</para>
    /// <para>Let px be the precision of x (number of digits), let py be the precision of y. Then </para>
    /// <code>
    /// x = x' * 10^px
    /// y = y' * 10^py
    /// </code>
    /// <para>where x' and y' are in the range [.1,1).  However, we'd really like to have:</para>
    /// <code>
    /// (a) x' in [.1,1)
    /// (b) y' in [x',10*x')
    /// </code>
    /// <para>So that  x'/y' is in the range (.1,1].
    /// We can use y' as defined above if y' meets (b), else multiply y' by 10 (and decrease py by 1).
    /// Having done this, we now have</para>
    /// <code>
    /// x/y = (x'/y') * 10^(px-py)
    /// </code>
    /// <para>
    /// This gives us
    /// <code>
    /// 10^(px-py-1) &lt; x/y &lt; 10^(px-py)
    /// </code>
    /// We'd like q to have p digits of precision.  So,
    /// </para>
    /// <code>
    /// if px-py = p, ok.
    /// if px-py &lt; p, multiply x by 10^(p - (px-py)).
    /// if px-py &gt; p, multiply y by 10^(px-py-p).
    /// </code>
    /// <para>Using these adjusted values of x and y, divide to get q and r, round using those, then adjust the exponent.</para>
    /// </remarks>
    function Divide(rhs: TDecimalX; c: TContext): TDecimalX; overload;
    /// <summary>
    /// Returns self mod y
    /// </summary>
    /// <param name="y">The divisor</param>
    /// <returns>The modulus</returns>
    function Modulus(y: TDecimalX): TDecimalX; overload;
    /// <summary>
    /// Returns self mod y
    /// </summary>
    /// <param name="y">The divisor</param>
    /// <param name="c">The context</param>
    /// <returns>The modulus</returns>
    function Modulus(y: TDecimalX; c: TContext): TDecimalX; overload;
    /// <summary>
    /// Returns the quotient and remainder of self divided by another.
    /// </summary>
    /// <param name="y">The divisor</param>
    /// <param name="remainder">The remainder</param>
    /// <returns>The quotient</returns>
    function DivRem(y: TDecimalX; out remainder: TDecimalX): TDecimalX;
      overload;
    /// <summary>
    /// Returns the quotient and remainder of self divided by another.
    /// </summary>
    /// <param name="y">The divisor</param>
    /// <param name="c">The context</param>
    /// <param name="remainder">The remainder</param>
    /// <returns>The quotient</returns>
    function DivRem(y: TDecimalX; c: TContext; out remainder: TDecimalX)
      : TDecimalX; overload;
    /// <summary>
    /// Returns the integer part of self / y.
    /// </summary>
    /// <param name="y"></param>
    /// <param name="c"></param>
    /// <returns>Returns the integer part of self / y.</returns>
    /// <remarks>I am indebted to the OpenJDK implementation for the algorithm.
    /// <para>However, the spec I'm working from specifies an exponent of zero always!
    /// The OpenJDK implementation does otherwise.  So I've modified it to yield a zero exponent.</para>
    /// </remarks>
    function DivideInteger(y: TDecimalX; c: TContext): TDecimalX; overload;
    /// <summary>
    /// Returns the integer part of self / y.
    /// </summary>
    /// <param name="y"></param>
    /// <returns>Returns the integer part of self / y.</returns>
    /// <remarks>I am indebted to the OpenJDK implementation for the algorithm.
    /// <para>However, the spec I'm working from specifies an exponent of zero always!
    /// The OpenJDK implementation does otherwise.  So I've modified it to yield a zero exponent.</para>
    /// </remarks>
    function DivideInteger(y: TDecimalX): TDecimalX; overload;
    /// <summary>
    /// Returns the absolute value of this instance.
    /// </summary>
    /// <returns>The absolute value</returns>
    function Abs(): TDecimalX; overload;
    /// <summary>
    /// Returns the absolute value of this instance.
    /// <param name="c">context to use</param>
    /// </summary>
    /// <returns>The absolute value</returns>
    function Abs(c: TContext): TDecimalX; overload;
    /// <summary>
    /// Returns the value of this instance raised to an integral power.
    /// </summary>
    /// <param name="n">The exponent</param>
    /// <returns>The exponentiated value</returns>
    /// <exception cref="EArithmeticException">Thrown if the exponent is negative or exceeds a certain range.</exception>
    function Power(n: Integer): TDecimalX; overload;
    /// <summary>
    /// Returns the value of this instance raised to an integral power.
    /// </summary>
    /// <param name="n">The exponent</param>
    /// <param name="c">context to use</param>
    /// <returns>The exponentiated value</returns>
    /// <remarks>
    /// <para>Follows the OpenJDK implementation.  This is an implementation of the X3.274-1996 algorithm:</para>
    /// <list>
    /// <item> An EArithmeticException exception is thrown if
    /// <list>
    /// <item>Abs(n) > 999999999</item>
    /// <item>c.precision = 0 and code n &lt; 0</item>
    /// <item>c.precision > 0 and n has more than c.precision decimal digits</item>
    /// </list>
    /// </item>
    /// <item>if n is zero, ONE is returned even if this is zero, otherwise
    /// <list>
    /// <item>if n is positive, the result is calculated via
    /// the repeated squaring technique into a single accumulator.
    /// The individual multiplications with the accumulator use the
    /// same context settings as in c except for a
    /// precision increased to c.precision + elength + 1
    /// where elength is the number of decimal digits in n.
    /// </item>
    /// <item>if n is negative, the result is calculated as if
    /// n were positive; this value is then divided into one
    /// using the working precision specified above.
    /// </item>
    /// <item>The final value from either the positive or negative case
    /// is then rounded to the destination precision.
    /// </item>
    /// </list>
    /// </list>
    /// </remarks>
    function Power(n: Integer; c: TContext): TDecimalX; overload;
    function Plus(): TDecimalX; overload;
    function Plus(c: TContext): TDecimalX; overload;
    function Minus(): TDecimalX; overload;
    function Minus(c: TContext): TDecimalX; overload;

    /// <summary>
    /// Does this <see cref="TDecimalX" /> have a zero value?
    /// </summary>
    function IsZero: Boolean;
    /// <summary>
    /// Does this <see cref="TDecimalX" /> represent a positive value?
    /// </summary>
    function IsPositive: Boolean;
    /// <summary>
    /// Does this <see cref="TDecimalX" /> represent a negative value?
    /// </summary>
    function IsNegative: Boolean;
    /// <summary>
    /// Returns the sign (-1, 0, +1) of this <see cref="TDecimalX" />.
    /// </summary>
    function Signum: Integer;

    function MovePointRight(n: Integer): TDecimalX;

    function MovePointLeft(n: Integer): TDecimalX;

    /// <summary>
    /// Returns a <see cref="TDecimalX" /> numerically equal to this one, but with
    /// any trailing zeros removed.
    /// </summary>
    /// <returns>processed value</returns>
    /// <remarks>Ended up needing this in ClojureCLR, grabbed from OpenJDK.</remarks>
    function StripTrailingZeros(): TDecimalX;

  end;

  TFormatSettings = SysUtils.TFormatSettings;
  EArgumentException = SysUtils.EArgumentException;
  EArithmeticException = SysUtils.EMathError;
  EOverflowException = SysUtils.EOverflow;
  EFormatException = class(Exception);

var

  /// <summary>
  /// Temporary Variable to Hold <c>Zero </c><see cref="TDecimalX" />.
  /// </summary>
  ZeroX: TDecimalX;
  /// <summary>
  /// Temporary Variable to Hold <c>One </c><see cref="TDecimalX" />.
  /// </summary>
  OneX: TDecimalX;
  /// <summary>
  /// Temporary Variable to Hold <c>Ten </c><see cref="TDecimalX" />.
  /// </summary>
  TenX: TDecimalX;

  // Source : ClojureCLR BigDecimal Source on GitHub.
  /// <summary>
  /// _biPowersOfTen.
  /// </summary>
  _biPowersOfTen: TArray<TIntegerX>;
  /// <summary>
  /// <c>length </c> of <see cref="_biPowersOfTen" />.
  /// </summary>
  _maxCachedPowerOfTen: Integer;

  /// <summary>
  /// Temporary Variable to Hold <c>BASIC_DEFAULT </c><see cref="TContext" />.
  /// </summary>
  BASIC_DEFAULTX: TContext;
  /// <summary>
  /// Temporary Variable to Hold <c>Decimal32 </c><see cref="TContext" />.
  /// </summary>
  Decimal32X: TContext;
  /// <summary>
  /// Temporary Variable to Hold <c>Decimal64 </c><see cref="TContext" />.
  /// </summary>
  Decimal64X: TContext;
  /// <summary>
  /// Temporary Variable to Hold <c>Decimal128 </c><see cref="TContext" />.
  /// </summary>
  Decimal128X: TContext;
  /// <summary>
  /// Temporary Variable to Hold <c>Unlimited </c><see cref="TContext" />.
  /// </summary>
  UnlimitedX: TContext;

resourcestring
  NaNOrInfinite = 'Infinity/NaN not supported in TDecimalX (yet)';
  EmptyString = 'Empty string';
  OutofBounds = 'offset + len past the end of the char array';
  MissingExponent = 'Missing exponent';
  UnusedChars = 'Unused characters at end';
  EmptyCoefficient = 'No digits in coefficient';
  PowerofTenNonNegative = 'Power of ten must be non-negative';
  ScaleOverflow = 'Overflow in scale';
  ScaleUnderflow = 'Underflow in scale';
  DivisionUndefined = 'Division undefined (0/0)';
  DivisionByZero = 'Division by zero';
  NonTerminatingDecimal = 'Non-terminating decimal expansion; no exact ' +
    'representable decimal result.';
  DivisionImpossible = 'Division impossible';
  InvalidOperation = 'Invalid operation';
  RoundingProhibited = 'Rounding is required, but prohibited.';

implementation

class function TDecimalX.Create(v: Double): TDecimalX;
var
  dbytes: TArray<Byte>;
  significand: UInt64;
  biasedExp, leftShift, expToUse: Integer;
  coeff: TIntegerX;
begin
  if (IsNaN(v)) or (IsInfinite(v)) then
  begin
    raise EArithmeticException.Create(NaNOrInfinite);
  end;
  SetLength(dbytes, SizeOf(v));
  Move(v, dbytes[0], SizeOf(v));

  significand := TIntegerX.GetDoubleSignificand(dbytes);
  biasedExp := TIntegerX.GetDoubleBiasedExponent(dbytes);
  leftShift := biasedExp - DoubleShiftBias;

  if (significand = 0) then
  begin
    if (biasedExp = 0) then
    begin
      result := TDecimalX.Create(TIntegerX.Zero, 0, 1);
      Exit;
    end;
    if v < 0.0 then
      coeff := TIntegerX.NegativeOne
    else
      coeff := TIntegerX.One;

    leftShift := biasedExp - DoubleExponentBias;
  end
  else
  begin
    significand := significand or $10000000000000;
    coeff := TIntegerX.Create(significand);
    // TODO: avoid extra allocation
    if (v < 0.0) then
      coeff := coeff * -1;
  end;

  // at this point v = coeff * 2 ** exp
  // need to convert to appropriate exponent of 10.

  expToUse := 0;
  if (leftShift < 0) then
  begin
    coeff := coeff.Multiply(TIntegerX.Five.Power(-leftShift));
    expToUse := leftShift;
  end

  else if (leftShift > 0) then
    coeff := coeff shl leftShift;

  result := TDecimalX.Create(coeff, expToUse);
end;

class function TDecimalX.Create(v: Double; c: TContext): TDecimalX;
var
  d: TDecimalX;
begin
  d := TDecimalX.Create(v);
  d.RoundInPlace(c);
  result := d;
end;

class function TDecimalX.Create(v: Integer): TDecimalX;
begin
  result := TDecimalX.Create(TIntegerX.Create(v), 0);
end;

class function TDecimalX.Create(v: Integer; c: TContext): TDecimalX;
var
  d: TDecimalX;
begin
  d := TDecimalX.Create(TIntegerX.Create(v), 0);
  d.RoundInPlace(c);
  result := d;
end;

class function TDecimalX.Create(v: UInt32): TDecimalX;
begin
  result := TDecimalX.Create(TIntegerX.Create(v), 0);
end;

class function TDecimalX.Create(v: UInt32; c: TContext): TDecimalX;
var
  d: TDecimalX;
begin
  d := TDecimalX.Create(TIntegerX.Create(v), 0);
  d.RoundInPlace(c);
  result := d;
end;

class function TDecimalX.Create(v: Int64): TDecimalX;
begin
  result := TDecimalX.Create(TIntegerX.Create(v), 0);
end;

class function TDecimalX.Create(v: Int64; c: TContext): TDecimalX;
var
  d: TDecimalX;
begin
  d := TDecimalX.Create(TIntegerX.Create(v), 0);
  d.RoundInPlace(c);
  result := d;
end;

class function TDecimalX.Create(v: UInt64): TDecimalX;
begin
  result := TDecimalX.Create(TIntegerX.Create(v), 0);
end;

class function TDecimalX.Create(v: UInt64; c: TContext): TDecimalX;
var
  d: TDecimalX;
begin
  d := TDecimalX.Create(TIntegerX.Create(v), 0);
  d.RoundInPlace(c);
  result := d;
end;

class function TDecimalX.Create(v: TIntegerX): TDecimalX;
begin
  result := TDecimalX.Create(v, 0);
end;

class function TDecimalX.Create(v: TIntegerX; c: TContext): TDecimalX;
var
  d: TDecimalX;
begin
  d := TDecimalX.Create(v, 0);
  d.RoundInPlace(c);
  result := d;
end;

class function TDecimalX.Create(v: String): TDecimalX;
begin
  result := TDecimalX.Parse(v);
end;

class function TDecimalX.Create(v: String; c: TContext): TDecimalX;
begin
  result := TDecimalX.Parse(v, c);
end;

class function TDecimalX.Create(v: TArray<Char>): TDecimalX;
begin
  result := TDecimalX.Parse(v);
end;

class function TDecimalX.Create(v: TArray<Char>; c: TContext): TDecimalX;
begin
  result := TDecimalX.Parse(v, c);
end;

class function TDecimalX.Create(v: TArray<Char>; offset: Integer; len: Integer)
  : TDecimalX;
begin
  result := TDecimalX.Parse(v, offset, len);
end;

class function TDecimalX.Create(v: TArray<Char>; offset: Integer; len: Integer;
  c: TContext): TDecimalX;
begin
  result := TDecimalX.Parse(v, offset, len, c);
end;

constructor TDecimalX.Create(copy: TDecimalX);
begin
  Self.Create(copy._coeff, copy._exp, copy._precision);
end;

constructor TDecimalX.Create(coeff: TIntegerX; exp: Integer; Precision: UInt32);
begin
  Self._coeff := coeff;
  Self._exp := exp;
  Self._precision := Precision;
end;

constructor TDecimalX.Create(coeff: TIntegerX; exp: Integer);
begin
  Self.Create(coeff, exp, 0);
end;

class function TDecimalX.Parse(S: String): TDecimalX;
var
  v: TDecimalX;
begin
  DoParse(ToCharArray(S), 0, Length(S), true, v);
  result := v;
end;

class function TDecimalX.Parse(S: String; c: TContext): TDecimalX;
var
  v: TDecimalX;
begin

  DoParse(ToCharArray(S), 0, Length(S), true, v);
  v.RoundInPlace(c);
  result := v;
end;

class function TDecimalX.TryParse(S: String; out v: TDecimalX): Boolean;
begin
  result := DoParse(ToCharArray(S), 0, Length(S), false, v);
end;

class function TDecimalX.TryParse(S: String; c: TContext;
  out v: TDecimalX): Boolean;
var
  res: Boolean;
begin
  res := DoParse(ToCharArray(S), 0, Length(S), false, v);
  if (res) then
    v.RoundInPlace(c);
  result := res;
end;

class function TDecimalX.Parse(buf: TArray<Char>): TDecimalX;
var
  v: TDecimalX;
begin

  DoParse(buf, 0, Length(buf), true, v);
  result := v;
end;

class function TDecimalX.Parse(buf: TArray<Char>; c: TContext): TDecimalX;
var
  v: TDecimalX;
begin

  DoParse(buf, 0, Length(buf), true, v);
  v.RoundInPlace(c);
  result := v;
end;

class function TDecimalX.TryParse(buf: TArray<Char>; out v: TDecimalX): Boolean;
begin
  result := DoParse(buf, 0, Length(buf), false, v);
end;

class function TDecimalX.TryParse(buf: TArray<Char>; c: TContext;
  out v: TDecimalX): Boolean;
var
  res: Boolean;
begin
  res := DoParse(buf, 0, Length(buf), false, v);
  if (res) then
    v.RoundInPlace(c);
  result := res;
end;

class function TDecimalX.Parse(buf: TArray<Char>; offset: Integer; len: Integer)
  : TDecimalX;
var
  v: TDecimalX;
begin

  DoParse(buf, offset, len, true, v);
  result := v;
end;

class function TDecimalX.Parse(buf: TArray<Char>; offset: Integer; len: Integer;
  c: TContext): TDecimalX;
var
  v: TDecimalX;
begin

  DoParse(buf, offset, len, true, v);
  v.RoundInPlace(c);
  result := v;
end;

class function TDecimalX.TryParse(buf: TArray<Char>; offset: Integer;
  len: Integer; out v: TDecimalX): Boolean;
begin
  result := DoParse(buf, offset, len, false, v);
end;

class function TDecimalX.TryParse(buf: TArray<Char>; offset: Integer;
  len: Integer; c: TContext; out v: TDecimalX): Boolean;
var
  res: Boolean;
begin
  res := DoParse(buf, offset, len, false, v);
  if (res) then
    v.RoundInPlace(c);
  result := res;
end;

class function TDecimalX.DoParse(buf: TArray<Char>; offset: Integer;
  len: Integer; throwOnError: Boolean; out v: TDecimalX): Boolean;
var
  mainOffset, signedMainLen, signState, mainLen, fractionOffset, fractionLen,
    expOffset, expLen, Precision, exp, expToUse, i: Integer;
  hasSign: Boolean;
  c: Char;
  LDigits, expDigits: TArray<Char>;
  val: TIntegerX;
  MyString, expString: String;

begin
  v := Default (TDecimalX);
  // Make sure we have some characters
  if (len = 0) then
  begin
    if (throwOnError) then
      raise EFormatException.Create(EmptyString);
    result := false;
    Exit;
  end;

  // Make sure we're not going past the end of the array
  if ((offset + len) > Length(buf)) then
  begin
    if (throwOnError) then
      raise EFormatException.Create(OutofBounds);
    result := false;
    Exit;
  end;

  mainOffset := offset;

  // optional leading sign
  hasSign := false;
  c := buf[offset];

  if ((c = '-') or (c = '+')) then
  begin
    hasSign := true;
    Inc(offset);
    Dec(len);
  end;

  // yeah yeah, I know I should have used the TCharacter or TCharHelper Instance but i want
  // something that is simple enough and would compile in at least Delphi XE3 and Up).
{$WARNINGS OFF}
  while ((len > 0) and CharInSet(buf[offset], Digits)) do
{$WARNINGS ON}
  begin
    Inc(offset);
    Dec(len);
  end;
  signedMainLen := offset - mainOffset;
  if hasSign then
    signState := 1
  else
    signState := 0;

  mainLen := offset - mainOffset - signState;

  // parse the optional fraction
  fractionOffset := offset;
  fractionLen := 0;
  // using a TFormatSettings so that library will be Locale - Aware
  if ((len > 0) and (buf[offset] = TContext._TCFS.DecimalSeparator)) then
  begin
    Inc(offset);
    Dec(len);
    fractionOffset := offset;
{$WARNINGS OFF}
    while ((len > 0) and CharInSet(buf[offset], Digits)) do
{$WARNINGS ON}
    begin
      Inc(offset);
      Dec(len);
    end;

    fractionLen := offset - fractionOffset;
  end;

  // Parse the optional exponent.
  expOffset := -1;
  expLen := 0;

  if ((len > 0) and ((buf[offset] = 'e') or (buf[offset] = 'E'))) then
  begin
    Inc(offset);
    Dec(len);

    expOffset := offset;

    if (len = 0) then
    begin
      if (throwOnError) then
        raise EFormatException.Create(MissingExponent);
      result := false;
      Exit;
    end;

    // Parse the optional sign;
    c := buf[offset];
    if ((c = '-') or (c = '+')) then
    begin
      Inc(offset);
      Dec(len);
    end;

    if (len = 0) then
    begin
      if (throwOnError) then
        raise EFormatException.Create(MissingExponent);
      result := false;
      Exit;
    end;
{$WARNINGS OFF}
    while ((len > 0) and CharInSet(buf[offset], Digits)) do
{$WARNINGS ON}
    begin
      Inc(offset);
      Dec(len);
    end;

    expLen := offset - expOffset;

    if (expLen = 0) then
    begin
      if (throwOnError) then
        raise EFormatException.Create(MissingExponent);
      result := false;
      Exit;
    end;
  end;

  // we should be at the end
  if (len <> 0) then
  begin
    if (throwOnError) then
      raise EFormatException.Create(UnusedChars);
    result := false;
    Exit;
  end;

  Precision := mainLen + fractionLen;
  if (Precision = 0) then
  begin
    if (throwOnError) then
      raise EFormatException.Create(EmptyCoefficient);
    result := false;
    Exit;
  end;
  SetLength(LDigits, signedMainLen + fractionLen);

  Move(buf[mainOffset], LDigits[0], signedMainLen * SizeOf(Char));

  if (fractionLen > 0) then
    Move(buf[fractionOffset], LDigits[signedMainLen],
      fractionLen * SizeOf(Char));
  SetString(MyString, PChar(@LDigits[0]), Length(LDigits));
  val := TIntegerX.Parse(MyString);

  exp := 0;
  if (expLen > 0) then
  begin
    SetLength(expDigits, expLen);
    Move(buf[expOffset], expDigits[0], expLen * SizeOf(Char));
    SetString(expString, PChar(@expDigits[0]), Length(expDigits));
    if (throwOnError) then
    begin

      exp := StrToInt(expString);
    end
    else
    begin
      if not TryStrToInt(expString, exp) then
      begin
        result := false;
        Exit;
      end;
    end;
  end;

  expToUse := mainLen - Precision;

  if (exp <> 0) then

    try
      expToUse := CheckExponent(expToUse + exp, val.IsZero);

    except
      on E: EArithmeticException do
      begin
        if (throwOnError) then
          raise;
        result := false;
        Exit;

      end;
    end;

  if hasSign then
    i := 1
  else
    i := 0;

  // Remove leading zeros from precision count.
  while ((i < (signedMainLen + fractionLen)) and (Precision > 1) and
    (LDigits[i] = '0')) do
  begin

    Inc(i);
    Dec(Precision);
  end;

  v := TDecimalX.Create(val, expToUse, UInt32(Precision));
  result := true;
  Exit;
end;

function TDecimalX.ToScientificString(): String;
var
  sb: TStringBuilder;
  coeffLen, negOffset, numDec, numZeros: Integer;
  adjustedExp: Int64;
begin
  sb := TStringBuilder.Create(Self._coeff.ToString());
  try
    coeffLen := sb.Length;
    negOffset := 0;
    if (Self._coeff.IsNegative) then
    begin
      Dec(coeffLen);
      negOffset := 1;
    end;

    adjustedExp := Int64(Self._exp) + (coeffLen - 1);
    if ((Self._exp <= 0) and (adjustedExp >= -6)) then
    begin
      // not using exponential notation

      if (Self._exp <> 0) then
      begin
        // We do need a decimal point.
        numDec := -Self._exp;
        if (numDec < coeffLen) then
          sb.Insert(coeffLen - numDec + negOffset,
            TContext._TCFS.DecimalSeparator)
        else if (numDec = coeffLen) then
          sb.Insert(negOffset, '0' + TContext._TCFS.DecimalSeparator)
        else
        begin
          numZeros := numDec - coeffLen;
          sb.Insert(negOffset, '0', numZeros);
          sb.Insert(negOffset, '0' + TContext._TCFS.DecimalSeparator);
        end
      end
    end
    else
    begin
      // using exponential notation
      if (coeffLen > 1) then
        sb.Insert(negOffset + 1, TContext._TCFS.DecimalSeparator);
      sb.Append('E');
      if (adjustedExp >= 0) then
        sb.Append('+');
      sb.Append(Format('%d', [adjustedExp], TContext._TCFS));

    end;

    result := sb.ToString();
  finally
    sb.Free;
  end;
end;

function TDecimalX.ToString(): String;
begin
  result := Self.ToScientificString();
end;

function TDecimalX.CompareTo(other: TDecimalX): Integer;
var
  d1, d2: TDecimalX;
begin
  d1 := Self;
  d2 := other;
  Align(d1, d2);
  result := d1._coeff.CompareTo(d2._coeff);
end;

function TDecimalX.Equals(other: TDecimalX): Boolean;
begin

  if (Self._exp <> other._exp) then
  begin
    result := false;
    Exit;
  end;
  result := _coeff.Equals(other._coeff);
end;

function TDecimalX.ToDouble(): Double;
begin
  result := Double(Self);
end;

function TDecimalX.ToByte(): Byte;
begin
  result := Byte(Self);
end;

function TDecimalX.ToShortInt(): ShortInt;
begin
  result := ShortInt(Self);
end;

function TDecimalX.ToSmallInt(): SmallInt;
begin
  result := SmallInt(Self);
end;

function TDecimalX.ToWord(): Word;
begin
  result := Word(Self);
end;

function TDecimalX.ToInteger(): Integer;
begin
  result := Integer(Self);
end;

function TDecimalX.ToUInt32(): UInt32;
begin
  result := UInt32(Self);
end;

function TDecimalX.ToInt64(): Int64;
begin
  result := Int64(Self);
end;

function TDecimalX.ToUInt64(): UInt64;
begin
  result := UInt64(Self);
end;

function TDecimalX.ToTIntegerX(): TIntegerX;
begin
  result := TIntegerX(Self);
end;

class operator TDecimalX.Explicit(value: TDecimalX): Double;

begin
  // As j.m.BigDecimal puts it: "Somewhat inefficient, but guaranteed to work."
  // However, JVM's double parser goes to +/- Infinity when out of range,
  // while CLR's throws an exception.
  // Hate dealing with that.
  try
    begin
      result := StrToFloat(value.ToString, TContext._TCFS);
      Exit;
    end;
  except
    on E: EOverflowException do
    begin
      if value.IsNegative then
      begin
        result := DoubleNegativeInfinity;
        Exit;
      end
      else
      begin
        result := DoublePositiveInfinity;
        Exit;
      end;
    end;
  end;
end;

class operator TDecimalX.Explicit(value: TDecimalX): Byte;

begin
  result := Byte(TIntegerX(value));
end;

class operator TDecimalX.Explicit(value: TDecimalX): ShortInt;

begin
  result := ShortInt(TIntegerX(value));
end;

class operator TDecimalX.Explicit(value: TDecimalX): SmallInt;

begin
  result := SmallInt(TIntegerX(value));
end;

class operator TDecimalX.Explicit(value: TDecimalX): Word;

begin
  result := Word(TIntegerX(value));
end;

class operator TDecimalX.Explicit(value: TDecimalX): Integer;

begin
  result := Integer(TIntegerX(value));
end;

class operator TDecimalX.Explicit(value: TDecimalX): UInt32;

begin
  result := UInt32(TIntegerX(value));
end;

class operator TDecimalX.Explicit(value: TDecimalX): Int64;

begin
  result := Int64(TIntegerX(value));
end;

class operator TDecimalX.Explicit(value: TDecimalX): UInt64;

begin
  result := UInt64(TIntegerX(value));
end;

class operator TDecimalX.Explicit(value: TDecimalX): TIntegerX;

begin
  result := Rescale(value, 0, TRoundingMode.Down)._coeff;

end;

class operator TDecimalX.Equal(x: TDecimalX; y: TDecimalX): Boolean;
begin
  result := x.Equals(y);
end;

class operator TDecimalX.NotEqual(x: TDecimalX; y: TDecimalX): Boolean;
begin
  result := Not(x = y);
end;

class operator TDecimalX.LessThan(x: TDecimalX; y: TDecimalX): Boolean;
begin
  result := x.CompareTo(y) < 0;
end;

class operator TDecimalX.GreaterThan(x: TDecimalX; y: TDecimalX): Boolean;
begin
  result := x.CompareTo(y) > 0;
end;

class operator TDecimalX.Add(x: TDecimalX; y: TDecimalX): TDecimalX;
begin
  result := x.Add(y);
end;

class operator TDecimalX.Subtract(x: TDecimalX; y: TDecimalX): TDecimalX;
begin
  result := x.Subtract(y);
end;

class operator TDecimalX.Positive(x: TDecimalX): TDecimalX;
begin
  result := x;
end;

class operator TDecimalX.Negative(x: TDecimalX): TDecimalX;
begin
  result := x.Negate();
end;

class operator TDecimalX.Multiply(x: TDecimalX; y: TDecimalX): TDecimalX;
begin
  result := x.Multiply(y);
end;

class operator TDecimalX.Divide(x: TDecimalX; y: TDecimalX): TDecimalX;
begin
  result := x.Divide(y);
end;

class operator TDecimalX.Modulus(x: TDecimalX; y: TDecimalX): TDecimalX;
begin
  result := x.Modulus(y);
end;

class function TDecimalX.Add(x: TDecimalX; y: TDecimalX): TDecimalX;
begin
  result := x.Add(y);
end;

class function TDecimalX.Add(x: TDecimalX; y: TDecimalX; c: TContext)
  : TDecimalX;
begin
  result := x.Add(y, c);
end;

class function TDecimalX.Subtract(x: TDecimalX; y: TDecimalX): TDecimalX;
begin
  result := x.Subtract(y);
end;

class function TDecimalX.Subtract(x: TDecimalX; y: TDecimalX; c: TContext)
  : TDecimalX;
begin
  result := x.Subtract(y, c);
end;

class function TDecimalX.Negate(x: TDecimalX): TDecimalX;
begin
  result := x.Negate();
end;

class function TDecimalX.Negate(x: TDecimalX; c: TContext): TDecimalX;
begin
  result := x.Negate(c);
end;

class function TDecimalX.Multiply(x: TDecimalX; y: TDecimalX): TDecimalX;
begin
  result := x.Multiply(y);
end;

class function TDecimalX.Multiply(x: TDecimalX; y: TDecimalX; c: TContext)
  : TDecimalX;
begin
  result := x.Multiply(y, c);
end;

class function TDecimalX.Divide(x: TDecimalX; y: TDecimalX): TDecimalX;
begin
  result := x.Divide(y);
end;

class function TDecimalX.Divide(x: TDecimalX; y: TDecimalX; c: TContext)
  : TDecimalX;
begin
  result := x.Divide(y, c);
end;

class function TDecimalX.Modulus(x: TDecimalX; y: TDecimalX): TDecimalX;
begin
  result := x.Modulus(y);
end;

class function TDecimalX.Modulus(x: TDecimalX; y: TDecimalX; c: TContext)
  : TDecimalX;
begin
  result := x.Modulus(y, c);
end;

class function TDecimalX.DivRem(x: TDecimalX; y: TDecimalX;
  out remainder: TDecimalX): TDecimalX;
begin
  result := x.DivRem(y, remainder);
end;

class function TDecimalX.DivRem(x: TDecimalX; y: TDecimalX; c: TContext;
  out remainder: TDecimalX): TDecimalX;
begin
  result := x.DivRem(y, c, remainder);
end;

class function TDecimalX.Abs(x: TDecimalX): TDecimalX;
begin
  result := x.Abs();
end;

class function TDecimalX.Abs(x: TDecimalX; c: TContext): TDecimalX;
begin
  result := x.Abs(c);
end;

class function TDecimalX.Power(x: TDecimalX; exp: Integer): TDecimalX;
begin
  result := x.Power(exp);
end;

class function TDecimalX.Power(x: TDecimalX; exp: Integer; c: TContext)
  : TDecimalX;
begin
  result := x.Power(exp, c);
end;

class function TDecimalX.Plus(x: TDecimalX): TDecimalX;
begin
  result := x;
end;

class function TDecimalX.Plus(x: TDecimalX; c: TContext): TDecimalX;
begin
  result := x.Plus(c);
end;

class function TDecimalX.Minus(x: TDecimalX): TDecimalX;
begin
  result := x.Negate();

end;

class function TDecimalX.Minus(x: TDecimalX; c: TContext): TDecimalX;
begin
  result := x.Negate(c);
end;

function TDecimalX.Add(y: TDecimalX): TDecimalX;
var
  x: TDecimalX;
begin
  x := Self;
  Align(x, y);

  result := TDecimalX.Create(x._coeff + y._coeff, x._exp);
end;

function TDecimalX.Add(y: TDecimalX; c: TContext): TDecimalX;
var
  tempRes: TDecimalX;
begin
  // TODO: Optimize for one arg or the other being zero.
  // TODO: Optimize for differences in exponent along with the desired precision is large enough that the add is irreleveant
  tempRes := Self.Add(y);

  if ((c.Precision = 0) or (c.RoundingMode = TRoundingMode.Unnecessary)) then
  begin
    result := tempRes;
    Exit;
  end;

  result := tempRes.Round(c);
end;

class procedure TDecimalX.Align(var x: TDecimalX; var y: TDecimalX);
begin
  if (y._exp > x._exp) then
    y := ComputeAlign(y, x)

  else if (x._exp > y._exp) then
    x := ComputeAlign(x, y);
end;

class function TDecimalX.ComputeAlign(big: TDecimalX; small: TDecimalX)
  : TDecimalX;
var
  deltaExp: Integer;
begin
  deltaExp := big._exp - small._exp;

  result := TDecimalX.Create(big._coeff * BIPowerOfTen(deltaExp), small._exp);
end;

function TDecimalX.Subtract(y: TDecimalX): TDecimalX;
var
  x: TDecimalX;
begin
  x := Self;
  Align(x, y);

  result := TDecimalX.Create(x._coeff - y._coeff, x._exp);
end;

function TDecimalX.Subtract(y: TDecimalX; c: TContext): TDecimalX;
var
  tempRes: TDecimalX;
begin
  // TODO: Optimize for one arg or the other being zero.
  // TODO: Optimize for differences in exponent along with the desired precision is large enough that the subtraction is irreleveant
  tempRes := Self.Subtract(y);

  if ((c.Precision = 0) or (c.RoundingMode = TRoundingMode.Unnecessary)) then
  begin
    result := tempRes;
    Exit;
  end;

  result := tempRes.Round(c);
end;

function TDecimalX.Negate(): TDecimalX;
begin
  if (Self._coeff.IsZero) then
  begin
    result := Self;
    Exit;
  end;
  result := TDecimalX.Create((-Self._coeff), Self._exp, Self._precision);
end;

function TDecimalX.Negate(c: TContext): TDecimalX;
begin
  result := Round(Self.Negate(), c);

end;

function TDecimalX.Multiply(y: TDecimalX): TDecimalX;
begin
  result := TDecimalX.Create(Self._coeff * y._coeff, _exp + y._exp);
end;

function TDecimalX.Multiply(y: TDecimalX; c: TContext): TDecimalX;
var
  d: TDecimalX;
begin
  d := Self.Multiply(y);
  d.RoundInPlace(c);
  result := d;
end;

function TDecimalX.Divide(divisor: TDecimalX): TDecimalX;
var
  dividend, quotient: TDecimalX;
  preferredExp, quotientExp: Integer;
  c: TContext;

begin
  dividend := Self;

  if (divisor._coeff.IsZero) then // x/0
  begin
    if (dividend._coeff.IsZero) then // 0/0
      raise EArithmeticException.Create(DivisionUndefined); // NaN
    raise EArithmeticException.Create(DivisionByZero); // INF
  end;

  // Calculate preferred exponent
  preferredExp := Integer(Math.Max(Math.Min(Int64(dividend._exp) - divisor._exp,
    MaxIntValue), MinIntValue));

  if (dividend._coeff.IsZero) then // 0/y
  begin
    result := TDecimalX.Create(TIntegerX.Zero, preferredExp);
    Exit;
  end;

  (* /*  OpenJDK says:
    * If the quotient self/divisor has a terminating decimal
    * expansion, the expansion can have no more than
    * (a.precision() + ceil(10*b.precision)/3) digits.
    * Therefore, create a Context object with this
    * precision and do a divide with the UNNECESSARY rounding
    * mode.
    */ *)

  c := TContext.Create(UInt32(Math.Min(dividend.GetPrecision() +
    Int64(Math.Ceil(10.0 * divisor.GetPrecision() / 3.0)), MaxIntValue)),
    TRoundingMode.Unnecessary);

  try
    quotient := dividend.Divide(divisor, c);

  except
    on E: EArithmeticException do
    begin
      raise EArithmeticException.Create(NonTerminatingDecimal);
    end;

  end;

  quotientExp := quotient._exp;

  // divide(TDecimalX, c) tries to adjust the quotient to
  // the desired one by removing trailing zeros; since the
  // exact divide method does not have an explicit digit
  // limit, we can add zeros too.

  if (preferredExp < quotientExp) then
  begin
    result := Rescale(quotient, preferredExp, TRoundingMode.Unnecessary);
    Exit;
  end;

  result := quotient;
end;

function TDecimalX.Divide(rhs: TDecimalX; c: TContext): TDecimalX;
var
  lhs, tempRes: TDecimalX;
  x, y, xtest, ytest, roundedInt: TIntegerX;
  preferredExp: Int64;
  xprec, yprec, adjust, delta, exp: Integer;
begin
  if (c.Precision = 0) then
  begin
    result := Self.Divide(rhs);
    Exit;
  end;

  lhs := Self;

  preferredExp := Int64(lhs._exp) - rhs._exp;

  // Deal with x or y being zero.

  if (rhs._coeff.IsZero) then // x/0
  begin
    if (lhs._coeff.IsZero) then // 0/0
      raise EArithmeticException.Create(DivisionUndefined); // NaN
    raise EArithmeticException.Create(DivisionByZero); // Inf
  end;

  if (lhs._coeff.IsZero) then // 0/y
  begin
    result := TDecimalX.Create(TIntegerX.Zero,
      Integer(Math.Max(Math.Min(preferredExp, MaxIntValue), MinIntValue)));
    Exit;
  end;
  xprec := Integer(lhs.GetPrecision());
  yprec := Integer(rhs.GetPrecision());

  // Determine if we need to make an adjustment to get x', y' into relation (b).
  x := lhs._coeff;
  y := rhs._coeff;

  xtest := TIntegerX.Abs(x);
  ytest := TIntegerX.Abs(y);
  if (xprec < yprec) then
    xtest := x * BIPowerOfTen(yprec - xprec)
  else if (xprec > yprec) then
    ytest := y * BIPowerOfTen(xprec - yprec);

  adjust := 0;
  if (ytest < xtest) then
  begin
    y := y * TIntegerX.Ten;
    adjust := 1;
  end;


  // Now make sure x and y themselves are in the proper range.

  delta := Integer(c.Precision) - (xprec - yprec);
  if (delta > 0) then
    x := x * BIPowerOfTen(delta)
  else if (delta < 0) then
    y := y * BIPowerOfTen(-delta);

  roundedInt := RoundingDivide2(x, y, c.RoundingMode);

  exp := CheckExponent(preferredExp - delta + adjust, roundedInt.IsZero);

  tempRes := TDecimalX.Create(roundedInt, exp);

  tempRes.RoundInPlace(c);

  // Thanks to the OpenJDK implementation for pointing this out.
  // TODO: Have RoundingDivide2 return a flag indicating if the remainder is 0.  Then we can lose the multiply.
  if (tempRes.Multiply(rhs).CompareTo(Self) = 0) then
  begin
    // Apply preferred scale rules for exact quotients
    result := tempRes.StripZerosToMatchExponent(preferredExp);
    Exit;
  end

  else
  begin
    result := tempRes;
    Exit;
  end;

  // var
  // temp: TRoundingMode;
  // c: TContext;
  // if ((c.RoundingMode = TRoundingMode.Ceiling) or
  // (c.RoundingMode = TRoundingMode.Floor)) then
  // begin
  // // OpenJDK code says:
  // // The floor (round toward negative infinity) and ceil
  // // (round toward positive infinity) rounding modes are not
  // // invariant under a sign flip.  If xprime/yprime has a
  // // different sign than lhs/rhs, the rounding mode must be
  // // changed.
  // if ((xprime._coeff.Signum <> lhs._coeff.Signum) xor
  // (yprime._coeff.Signum <> rhs._coeff.Signum)) then
  // begin
  // if c.RoundingMode = TRoundingMode.Ceiling then
  // temp := TRoundingMode.Floor
  // else
  // temp := TRoundingMode.Ceiling;
  // c = TContext.Create(c.Precision, temp);
  // end;
  // end;
end;

function TDecimalX.Modulus(y: TDecimalX): TDecimalX;
var
  r: TDecimalX;
begin

  DivRem(y, r);
  result := r;
end;

function TDecimalX.Modulus(y: TDecimalX; c: TContext): TDecimalX;
var
  r: TDecimalX;
begin

  DivRem(y, c, r);
  result := r;
end;

function TDecimalX.DivRem(y: TDecimalX; out remainder: TDecimalX): TDecimalX;
var
  q: TDecimalX;
begin
  // x = q * y + r
  q := Self.DivideInteger(y);
  remainder := Self - q * y;
  result := q;

end;

function TDecimalX.DivRem(y: TDecimalX; c: TContext; out remainder: TDecimalX)
  : TDecimalX;
var
  q: TDecimalX;
begin
  // x = q * y + r
  if (c.RoundingMode = TRoundingMode.Unnecessary) then
  begin
    result := Self.DivRem(y, remainder);
  end;

  q := Self.DivideInteger(y, c);
  remainder := Self - q * y;
  result := q;
end;

function TDecimalX.DivideInteger(y: TDecimalX; c: TContext): TDecimalX;
var
  preferredExp, tempResExp: Integer;
  tempRes, product: TDecimalX;
begin
  if ((c.Precision = 0) or // exact result
    (Self.Abs().CompareTo(y.Abs()) < 0)) then // zero result
  begin
    result := Self.DivideInteger(y);
    Exit;
  end;

  // Calculate preferred scale
  // int preferredExp = (int)Math.Max(Math.Min((long)this._exp - y._exp,
  // Int32.MaxValue),Int32.MinValue);
  preferredExp := 0;

  (* /*  OpenJDK says:
    * Perform a normal divide to c.precision digits.  If the
    * remainder has absolute value less than the divisor, the
    * integer portion of the quotient fits into mc.precision
    * digits.  Next, remove any fractional digits from the
    * quotient and adjust the scale to the preferred value.
    */ *)
  tempRes := Self.Divide(y, TContext.Create(c.Precision, TRoundingMode.Down));
  tempResExp := tempRes._exp;

  if (tempResExp > 0) then
  begin
    (* /*
      * tempRes is an integer. See if quotient represents the
      * full integer portion of the exact quotient; if it does,
      * the computed remainder will be less than the divisor.
      */ *)
    product := tempRes.Multiply(y);
    // If the quotient is the full integer value,
    // |dividend-product| < |divisor|.
    if (Self.Subtract(product).Abs().CompareTo(y.Abs()) >= 0) then
    begin
      raise EArithmeticException.Create(DivisionImpossible);
    end;

  end
  else if (tempResExp < 0) then
  begin
    (* /*
      * Integer portion of quotient will fit into precision
      * digits; recompute quotient to scale 0 to avoid double
      * rounding and then try to adjust, if necessary.
      */ *)
    tempRes := Rescale(tempRes, 0, TRoundingMode.Down);
  end;
  // else resultExp = 0;

  // int precisionDiff;
  if ((preferredExp < tempResExp) and
    (Integer(c.Precision - tempRes.GetPrecision()) > 0)) then
  begin
    // return Rescale(tempRes, tempResExp + Math.Max(precisionDiff, preferredExp - tempResExp), RoundingMode.Unnecessary);
    result := Rescale(tempRes, 0, TRoundingMode.Unnecessary);
    Exit;

  end
  else
  begin
    result := tempRes.StripZerosToMatchExponent(preferredExp);
    Exit;
  end;
end;

function TDecimalX.DivideInteger(y: TDecimalX): TDecimalX;
var
  preferredExp, maxDigits: Integer;
  quotient: TDecimalX;
begin

  // Calculate preferred exponent
  // int preferredExp = (int)Math.Max(Math.Min((long)this._exp - y._exp,
  // Int32.MaxValue), Int32.MinValue);
  preferredExp := 0;

  if (Self.Abs().CompareTo(y.Abs()) < 0) then
  begin
    result := TDecimalX.Create(TIntegerX.Zero, preferredExp);
    Exit;
  end;

  if ((Self._coeff.IsZero) and (not y._coeff.IsZero)) then
  begin
    result := Rescale(Self, preferredExp, TRoundingMode.Unnecessary);
    Exit;
  end;

  // Perform a divide with enough digits to round to a correct
  // integer value; then remove any fractional digits

  maxDigits := Integer(Math.Min(Self.GetPrecision() +
    Int64(Math.Ceil(10.0 * y.GetPrecision() / 3.0)) +
    System.Abs(Int64(Self._exp) - y._exp) + 2, MaxIntValue));

  quotient := Self.Divide(y, TContext.Create(UInt32(maxDigits),
    TRoundingMode.Down));
  if (y._exp < 0) then
  begin
    quotient := Rescale(quotient, 0, TRoundingMode.Down)
      .StripZerosToMatchExponent(preferredExp);
  end;

  if (quotient._exp > preferredExp) then
  begin
    // pad with zeros if necessary
    quotient := Rescale(quotient, preferredExp, TRoundingMode.Unnecessary);
  end;

  result := quotient;
end;

function TDecimalX.Abs(): TDecimalX;
begin
  if (_coeff.IsNegative) then
  begin
    result := Self.Negate();
    Exit;
  end;
  result := Self;
end;

function TDecimalX.Abs(c: TContext): TDecimalX;
begin
  if (_coeff.IsNegative) then
  begin
    result := Self.Negate(c);
    Exit;
  end;
  result := Round(Self, c);
end;

function TDecimalX.Power(n: Integer): TDecimalX;
var
  exp: Integer;
begin
  if ((n < 0) or (n > 999999999)) then
    raise EArithmeticException.Create(InvalidOperation);

  exp := CheckExponent(Int64(_exp) * n);
  result := TDecimalX.Create(TIntegerX.Power(Self._coeff, UInt32(n)), exp);
end;

function TDecimalX.Power(n: Integer; c: TContext): TDecimalX;
var
  lhs, acc: TDecimalX;
  workc: TContext;
  mag, elength, i: Integer;
  seenbit: Boolean;
begin
  if (c.Precision = 0) then
  begin
    result := Self.Power(n);
    Exit;
  end;
  if ((n < -999999999) or (n > 999999999)) then
  begin
    raise EArithmeticException.Create(InvalidOperation);
  end;
  if (n = 0) then
  begin
    result := TDecimalX.One;
    Exit;
  end;
  lhs := Self;
  workc := c;
  mag := System.Abs(n);
  if (c.Precision > 0) then
  begin
    elength := Integer(TIntegerX.UIntPrecision(UInt32(mag)));
    if (UInt32(elength) > c.Precision) then // X3.274 rule
      raise EArithmeticException.Create(InvalidOperation);
    workc := TContext.Create(c.Precision + UInt32(elength + 1), c.RoundingMode);
  end;

  acc := TDecimalX.One;
  seenbit := false;

  i := 1;

  while true do
  begin
    mag := mag + mag; // shift left 1 bit
    if (mag < 0) then
    begin // top bit is set
      seenbit := true; // OK, we're off
      acc := acc.Multiply(lhs, workc); // acc=acc*x
    end;
    if (i = 31) then
      break; // that was the last bit
    if (seenbit) then
      acc := acc.Multiply(acc, workc); // acc=acc*acc [square]
    // else (!seenbit) no point in squaring ONE
    Inc(i);
  end;
  // if negative n, calculate the reciprocal using working precision
  if (n < 0) then // [hence c.precision > 0]
    acc := TDecimalX.One.Divide(acc, workc);
  // round to final precision and strip zeros
  result := acc.Round(c);
end;

function TDecimalX.Plus(): TDecimalX;
begin
  result := Self;
end;

function TDecimalX.Plus(c: TContext): TDecimalX;
begin
  if (c.Precision = 0) then
  begin
    result := Self;
    Exit;
  end;
  result := Self.Round(c);
end;

function TDecimalX.Minus(): TDecimalX;
begin
  result := Self.Negate();
end;

function TDecimalX.Minus(c: TContext): TDecimalX;
begin
  result := Self.Negate(c);
end;

function TDecimalX.IsZero: Boolean;
begin
  result := Self._coeff.IsZero;
end;

function TDecimalX.IsPositive: Boolean;
begin
  result := Self._coeff.IsPositive;
end;

function TDecimalX.IsNegative: Boolean;
begin
  result := Self._coeff.IsNegative;
end;

function TDecimalX.Signum: Integer;
begin
  result := Self._coeff.Signum;
end;

function TDecimalX.MovePointRight(n: Integer): TDecimalX;
var
  d: TDecimalX;
  newExp: Integer;
begin
  newExp := CheckExponent(Int64(Self._exp) + n);
  d := TDecimalX.Create(Self._coeff, newExp);
  result := d;
end;

function TDecimalX.MovePointLeft(n: Integer): TDecimalX;
var
  d: TDecimalX;
  newExp: Integer;
begin
  newExp := CheckExponent(Int64(Self._exp) - n);
  d := TDecimalX.Create(Self._coeff, newExp);
  result := d;
end;

function TDecimalX.StripTrailingZeros(): TDecimalX;
var
  tempRes: TDecimalX;
begin
  tempRes := TDecimalX.Create(Self._coeff, Self._exp);
  tempRes.StripZerosToMatchExponent(MaxInt64Value);
  result := tempRes;
end;

function TDecimalX.GetCoefficient: TIntegerX;
begin
  result := Self._coeff;

end;

function TDecimalX.GetExponent: Integer;
begin
  result := Self._exp;
end;

function TDecimalX.GetPrecision: UInt32;
begin
  if (Self._precision = 0) then
  begin
    if (Self._coeff.IsZero) then
      Self._precision := 1
    else

      Self._precision := Self._coeff.Precision;
  end;
  result := Self._precision;
end;

procedure TDecimalX.RoundInPlace(c: TContext);
var
  v: TDecimalX;
begin
  v := Round(Self, c);
  if (v <> Self) then
  begin
    Self._coeff := v._coeff;
    Self._exp := v._exp;
    Self._precision := v._precision;
  end;
end;

function TDecimalX.Round(c: TContext): TDecimalX;
begin
  result := Round(Self, c);
end;

class function TDecimalX.Round(v: TDecimalX; c: TContext): TDecimalX;
var
  drop, exp: Integer;
  divisor, roundedInteger: TIntegerX;
  tempRes: TDecimalX;
begin
  { if (c.Precision = 0) then
    begin
    result := v;
    Exit;
    end; }

  if (v.GetPrecision() < c.Precision) then
  begin
    result := v;
    Exit;
  end;

  drop := Integer(v._precision - c.Precision);

  if (drop <= 0) then
  begin
    result := v;
    Exit;
  end;

  // we need to lose some digits on the coefficient.
  divisor := BIPowerOfTen(drop);

  roundedInteger := RoundingDivide2(v._coeff, divisor, c.RoundingMode);

  exp := CheckExponent(Int64(v._exp) + drop, roundedInteger.IsZero);

  tempRes := TDecimalX.Create(roundedInteger, exp);

  if (c.Precision > 0) then
    tempRes.RoundInPlace(c);

  result := tempRes;
end;

class function TDecimalX.RoundingDivide2(x: TIntegerX; y: TIntegerX;
  mode: TRoundingMode): TIntegerX;
var
  r, q: TIntegerX;
  increment, isNeg: Boolean;
  cmp: Integer;
begin
  q := x.DivRem(y, r);

  increment := false;
  if (not r.IsZero) then // we need to pay attention
  begin
    isNeg := q.IsNegative;

    case (mode) of

      TRoundingMode.Unnecessary:

        begin
          raise EArithmeticException.Create(RoundingProhibited);
        end;
      TRoundingMode.Ceiling:

        begin
          increment := not isNeg;
        end;
      TRoundingMode.Floor:

        begin
          increment := isNeg;
        end;
      TRoundingMode.Down:

        begin
          increment := false;
        end;
      TRoundingMode.Up:

        begin
          increment := true;
        end

    else
      begin

        cmp := (r + r).Abs().CompareTo(y);
        case (mode) of

          TRoundingMode.HalfDown:

            begin
              increment := cmp > 0;
            end;
          TRoundingMode.HalfUp:

            begin
              increment := cmp >= 0;
            end;
          TRoundingMode.HalfEven:

            begin
              increment := (cmp > 0) or ((cmp = 0) and (q.TestBit(0)));
            end;

        end;
      end;
    end;

    if (increment) then
    begin
      if ((q.IsNegative) or ((q.IsZero) and (x.IsNegative))) then
        q := q - TIntegerX.One
      else
        q := q + TIntegerX.One;
    end;

  end;

  result := q;
end;

class function TDecimalX.Quantize(lhs: TDecimalX; rhs: TDecimalX;
  mode: TRoundingMode): TDecimalX;
begin
  result := Rescale(lhs, rhs._exp, mode);
end;

function TDecimalX.Quantize(v: TDecimalX; mode: TRoundingMode): TDecimalX;
begin
  result := Quantize(Self, v, mode);
end;

class function TDecimalX.Rescale(lhs: TDecimalX; newExponent: Integer;
  mode: TRoundingMode): TDecimalX;
var
  delta, decrease: Integer;
  p, newPrecision, newPrec: UInt32;
  r: TDecimalX;
  newCoeff: TIntegerX;
begin

  delta := CheckExponent(Int64(lhs._exp) - newExponent, false);

  if (delta = 0) then
  // no change
  begin
    result := lhs;
    Exit;
  end;

  if (lhs._coeff.IsZero) then
  begin
    result := TDecimalX.Create(TIntegerX.Zero, newExponent);
    // Not clear on the precision
    Exit;
  end;
  if (delta < 0) then
  begin
    // Essentially, we have to round to a new precision.
    // we need this new precision to be non-zero, else we are zero.
    decrease := -delta;
    p := lhs.GetPrecision();

    if (p < UInt32(decrease)) then
    begin
      result := TDecimalX.Create(TIntegerX.Zero, newExponent);
      Exit;
    end;

    newPrecision := p - UInt32(decrease);

    r := lhs.Round(TContext.Create(newPrecision, mode));
    if (r._exp = newExponent) then
    begin
      result := r;
      Exit;
    end
    else
    begin
      result := Rescale(r, newExponent, mode);
      // happens for example with 9.9999 & 1e-2 where we have a round 10.0
      Exit;
    end;
  end;

  // decreasing the exponent (delta is positive)
  // multiply by an appropriate power of 10
  // Make sure we don't underflow

  newCoeff := lhs._coeff * BIPowerOfTen(delta);
  newPrec := lhs._precision;
  if (newPrec <> 0) then
    newPrec := newPrec + UInt32(delta);
  result := TDecimalX.Create(newCoeff, newExponent, newPrec);
end;

class constructor TDecimalX.Create();
begin
  // Create a Zero TDecimalX (a big decimal with value as Zero)
  ZeroX := TDecimalX.Create(TIntegerX.Zero, 0, 1);
  // Create a One TDecimalX (a big decimal with value as One)
  OneX := TDecimalX.Create(TIntegerX.One, 0, 1);
  // Create a Ten TDecimalX (a big decimal with value as Ten)
  TenX := TDecimalX.Create(TIntegerX.Ten, 0, 2);

  _biPowersOfTen := TArray<TIntegerX>.Create(TIntegerX.One,
    TIntegerX.Create(10), TIntegerX.Create(100), TIntegerX.Create(1000),
    TIntegerX.Create(10000), TIntegerX.Create(100000),
    TIntegerX.Create(1000000), TIntegerX.Create(10000000),
    TIntegerX.Create(100000000), TIntegerX.Create(1000000000),
    TIntegerX.Create(10000000000), TIntegerX.Create(100000000000));

  _maxCachedPowerOfTen := Length(_biPowersOfTen);

end;

class function TDecimalX.GetZero: TDecimalX;
begin
  result := ZeroX;
end;

class function TDecimalX.GetOne: TDecimalX;
begin
  result := OneX;
end;

class function TDecimalX.GetTen: TDecimalX;
begin
  result := TenX;
end;

class function TDecimalX.ToCharArray(const S: String): TArray<Char>;
begin
  SetLength(result, Length(S));

  // Moves the string contents to a char array
  Move((PChar(S))^, result[0], Length(S) * SizeOf(Char));
end;

class function TDecimalX.CheckExponent(candidate: Int64; IsZero: Boolean;
  out Exponent: Integer): Boolean;
begin
  Exponent := Integer(candidate);
  if (Exponent = candidate) then
  begin
    result := true;
    Exit;
  end;

  // We have underflow/overflow.
  // If Zero, use the max value of the appropriate sign.
  if (IsZero) then
  begin
    if candidate > MaxIntValue then
      Exponent := MaxIntValue
    else
      Exponent := MinIntValue;

    result := true;
    Exit;
  end;

  result := false;
end;

class function TDecimalX.CheckExponent(candidate: Int64;
  IsZero: Boolean): Integer;
var
  Exponent: Integer;
  tempRes: Boolean;
begin

  tempRes := CheckExponent(candidate, IsZero, Exponent);
  if (tempRes) then
  begin
    result := Exponent;
    Exit;
  end;

  // Report error condition
  if (candidate > MaxIntValue) then
    raise EArithmeticException.Create(ScaleOverflow)
  else
    raise EArithmeticException.Create(ScaleUnderflow);
end;

function TDecimalX.CheckExponent(candidate: Int64;
  out Exponent: Integer): Boolean;
begin
  result := CheckExponent(candidate, Self._coeff.IsZero, Exponent);
end;

function TDecimalX.CheckExponent(candidate: Int64): Integer;
begin
  result := CheckExponent(candidate, Self._coeff.IsZero);
end;

class function TDecimalX.BIPowerOfTen(n: Integer): TIntegerX;
var
  buf: TArray<Char>;
  i: Integer;
  tempStr: String;
begin
  if (n < 0) then
    raise EArgumentException.Create(PowerofTenNonNegative);

  if (n < _maxCachedPowerOfTen) then
  begin
    result := _biPowersOfTen[n];
    Exit;
  end;
  SetLength(buf, n + 1);
  buf[0] := '1';
  i := 1;
  while i <= n do
  begin
    buf[i] := '0';
    Inc(i);
  end;
  SetString(tempStr, PChar(@buf[0]), Length(buf));

  result := TIntegerX.Parse(tempStr);
end;

function TDecimalX.StripZerosToMatchExponent(preferredExp: Int64): TDecimalX;
var
  rem, quo: TIntegerX;
begin
  while ((TIntegerX.Abs(Self._coeff).CompareTo(TIntegerX.Ten) >= 0) and
    (Self._exp < preferredExp)) do
  begin
    if (_coeff.IsOdd) then
      break; // odd number.  cannot end in 0
    quo := TIntegerX.DivRem(Self._coeff, TIntegerX.Ten, rem);
    if (not rem.IsZero) then
      break; // non-0 remainder
    Self._coeff := quo;
    Self._exp := CheckExponent(Int64(Self._exp) + 1); // could overflow
    if (Self._precision > 0) then // adjust precision if known
      Self._precision := Self._precision - 1;
  end;

  result := Self;
end;

class constructor TContext.Create();
begin
  _TCFS := TFormatSettings.Create;
  BASIC_DEFAULTX := TContext.Create(9, TRoundingMode.HalfUp);
  Decimal32X := TContext.Create(7, TRoundingMode.HalfEven);
  Decimal64X := TContext.Create(16, TRoundingMode.HalfEven);
  Decimal128X := TContext.Create(34, TRoundingMode.HalfEven);
  UnlimitedX := TContext.Create(0, TRoundingMode.HalfUp);
end;

class function TContext.GetBasicDefault(): TContext;
begin
  result := BASIC_DEFAULTX;
end;

class function TContext.GetDecimal32(): TContext;
begin
  result := Decimal32X;
end;

class function TContext.GetDecimal64(): TContext;
begin
  result := Decimal64X;
end;

class function TContext.GetDecimal128(): TContext;
begin
  result := Decimal128X;
end;

class function TContext.GetUnlimited(): TContext;
begin
  result := UnlimitedX;
end;

class function TContext.ExtendedDefault(Precision: UInt32): TContext;
begin
  result := TContext.Create(Precision, TRoundingMode.HalfEven)
end;

constructor TContext.Create(Precision: UInt32; mode: TRoundingMode);
begin

  Self._precision := Precision;
  Self._roundingMode := mode;
end;

constructor TContext.Create(Precision: UInt32);
begin
  Self.Create(Precision, TRoundingMode.HalfUp)
end;

class operator TContext.Equal(c1: TContext; c2: TContext): Boolean;
begin

  result := c1.Equals(c2);
end;

class operator TContext.NotEqual(c1: TContext; c2: TContext): Boolean;
begin

  result := not(c1 = c2);
end;

function TContext.Equals(other: TContext): Boolean;
begin
  result := ((other._precision = Self._precision) and
    (other._roundingMode = Self._roundingMode));
end;

function TContext.ToString(): String;
begin
  result := Format('precision = %u roundingMode= %s',
    [Self._precision, GetEnumName(TypeInfo(TRoundingMode),
    Ord(Self._roundingMode))], Self._TCFS);

end;

function TContext.RoundingNeeded(bi: TIntegerX): Boolean;
begin
  // TODO: Really
  result := true;

end;

function TContext.GetPrecision: UInt32;
begin
  result := Self._precision;
end;

function TContext.GetRoundingMode: TRoundingMode;
begin
  result := Self._roundingMode;
end;

end.
