unit IntegerXTest;

// Comprehensive Unit Test for TIntegerX.

{ **
  *   Copyright (c) Rich Hickey. All rights reserved.
  *   The use and distribution terms for this software are covered by the
  *   Eclipse Public License 1.0 (http://opensource.org/licenses/eclipse-1.0.php)
  *   which can be found in the file epl-v10.html at the root of this distribution.
  *   By using this software in any fashion, you are agreeing to be bound by
  * 	 the terms of this license.
  *   You must not remove this notice, or any other, from this software.
  ** }

{ **
  *   Author: David Miller
  ** }

{ **
  *   Delphi Implementation by Ugochukwu Mmaduekwe
  ** }

interface

uses
  DUnitX.TestFramework, SysUtils, Math, IntegerX;

type

  [TestFixture]
  TIntegerXTest = class(TObject)
  strict private
    procedure TestDivRem(y: TIntegerX; mult: TIntegerX; add: TIntegerX);
    procedure GenerateKnuthExample(m, n: Integer; out bmn: TIntegerX;
      out bm: TIntegerX; out bn: TIntegerX);
    procedure TestGCD(primes: TArray<Integer>; apos: Boolean;
      apowers: TArray<Integer>; bpos: Boolean; bpowers: TArray<Integer>);
    function CreateFromPrimePowers(primes: TArray<Integer>;
      powers: TArray<Integer>): TIntegerX;
    function MinPowers(apowers: TArray<Integer>; bpowers: TArray<Integer>)
      : TArray<Integer>;
    procedure AsInt32Test(i: TIntegerX; expRet: Boolean; expInt: Integer);
    procedure AsInt64Test(i: TIntegerX; expRet: Boolean; expInt: Int64);
    procedure AsUInt32Test(i: TIntegerX; expRet: Boolean; expInt: UInt32);
    procedure AsUInt64Test(i: TIntegerX; expRet: Boolean; expInt: UInt64);
  public
    [Test]
    procedure Signum_is_zero_for_zero();
    [Test]
    procedure Magnitude_is_same_for_pos_and_neg();
    [Test]
    procedure Magnitude_is_zero_length_for_zero();
    [Test]
    procedure Signum_is_m1_for_negative();
    [Test]
    procedure Signum_is_1_for_negative();
    [Test]
    procedure IsPositive_works();
    [Test]
    procedure IsNegative_works();
    [Test]
    procedure IsZero_works();
    [Test]
    procedure Create_uint64_various();
    [Test]
    procedure Create_uint32_various();
    [Test]
    procedure Create_int64_various();
    [Test]
    procedure Create_integer_various();
    [Test]
    procedure Create_double_various();
    [Test]
    procedure Create_double_powers_of_two();
    [Test]
    procedure Create_double_fails_on_pos_infinity();
    [Test]
    procedure Create_double_fails_on_neg_infinity();
    [Test]
    procedure Create_double_fails_on_NaN();
    [Test]
    procedure TI_basic_constructor_handles_zero();
    [Test]
    procedure TI_basic_constructor_handles_basic_data_positive();
    [Test]
    procedure TI_basic_constructor_handles_basic_data_negative();
    [Test]
    procedure TI_basic_constructor_fails_on_bad_sign_neg();
    [Test]
    procedure TI_basic_constructor_fails_on_bad_sign_pos();
    [Test]
    procedure TI_basic_constructor_fails_on_zero_sign_on_nonzero_mag();
    [Test]
    procedure TI_basic_constructor_normalized_magnitude();
    [Test]
    procedure TI_basic_constructor_detects_all_zero_mag();
    [Test]
    procedure TI_copy_constructor_works();
    [Test]
    procedure Parse_detects_radix_too_small();
    [Test]
    procedure Parse_detects_radix_too_large();
    [Test]
    procedure Parse_zero();
    [Test]
    procedure Parse_negative_zero_just_zero();
    [Test]
    procedure Parse_multiple_zeros_is_zero();
    [Test]
    procedure Parse_multiple_zeros_with_leading_minus_is_zero();
    [Test]
    procedure Parse_multiple_hyphens_fails();
    [Test]
    procedure Parse_adjacent_hyphens_fails();
    [Test]
    procedure Parse_just_adjacent_hyphens_fails();
    [Test]
    procedure Parse_hyphen_only_fails();
    [Test]
    procedure Parse_fails_on_bogus_char();
    [Test]
    procedure Parse_fails_on_digit_out_of_range_base_2();
    [Test]
    procedure Parse_fails_on_digit_out_of_range_base_8();
    [Test]
    procedure Parse_fails_on_digit_out_of_range_base_16();
    [Test]
    procedure Parse_fails_on_digit_out_of_range_in_later_super_digit_base_16();
    [Test]
    procedure Parse_simple_base_2();
    [Test]
    procedure Parse_simple_base_10();
    [Test]
    procedure Parse_simple_base_16();
    [Test]
    procedure Parse_simple_base_36();
    [Test]
    procedure Parse_works_on_long_string_base_16();
    [Test]
    procedure Parse_works_on_long_string_base_10();
    [Test]
    procedure Parse_works_with_leading_minus_sign();
    [Test]
    procedure Parse_works_with_leading_plus_sign();
    [Test]
    procedure Parse_works_on_long_string_base_10_2();
    [Test]
    procedure ToString_fails_on_radix_too_small();
    [Test]
    procedure ToString_detects_radix_too_large();
    [Test]
    procedure ToString_on_zero_works_for_all_radixes();
    [Test]
    procedure ToString_simple_base_2();
    [Test]
    procedure ToString_simple_base_10();
    [Test]
    procedure ToString_simple_base_16();
    [Test]
    procedure ToString_simple_base_26();
    [Test]
    procedure ToString_long_base_16();
    [Test]
    procedure ToString_long_base_10();
    [Test]
    procedure ToString_long_base_10_2();
    [Test]
    procedure Compare_on_zeros_is_0();
    [Test]
    procedure Compare_neg_pos_is_minus1();
    [Test]
    procedure Compare_pos_neg_is_plus1();
    [Test]
    procedure Compare_negs_smaller_len_first_is_plus1();
    [Test]
    procedure Compare_negs_larger_len_first_is_minus1();
    [Test]
    procedure Compare_pos_smaller_len_first_is_minus1();
    [Test]
    procedure Compare_pos_larger_len_first_is_plus1();
    [Test]
    procedure Compare_same_len_smaller_first_diff_in_MSB_is_minus1();
    [Test]
    procedure Compare_same_len_smaller_first_diff_in_middle_is_minus1();
    [Test]
    procedure Compare_same_len_larger_first_diff_in_MSB_is_plus1();
    [Test]
    procedure Compare_same_len_larger_first_diff_in_LSB_is_plus1();
    [Test]
    procedure Compare_same_len_larger_first_diff_in_middle_is_plus1();
    [Test]
    procedure Compare_same_is_0();
    [Test]
    procedure Negate_zero_is_zero();
    [Test]
    procedure Negate_positive_is_same_mag_neg();
    [Test]
    procedure Negate_negative_is_same_mag_pos();
    [Test]
    procedure Add_pos_same_length_no_carry();
    [Test]
    procedure Add_neg_same_length_no_carry();
    [Test]
    procedure Add_pos_same_length_some_carry();
    [Test]
    procedure Add_neg_same_length_some_carry();
    [Test]
    procedure Add_pos_first_longer_one_carry();
    [Test]
    procedure Add_pos_first_longer_more_carry();
    [Test]
    procedure Add_pos_first_longer_carry_extend();
    [Test]
    procedure Add_pos_neg_first_larger_mag();
    [Test]
    procedure Add_pos_neg_second_larger_mag();
    [Test]
    procedure Add_pos_neg_same_mag();
    [Test]
    procedure Add_neg_pos_first_larger_mag();
    [Test]
    procedure Add_neg_pos_second_larger_mag();
    [Test]
    procedure Add_neg_pos_same_mag();
    [Test]
    procedure Add_zero_to_pos();
    [Test]
    procedure Subtract_zero_yields_this();
    [Test]
    procedure Subtract_from_zero_yields_negation();
    [Test]
    procedure Subtract_opposite_sign_first_pos_is_add();
    [Test]
    procedure Subtract_opposite_sign_first_neg_is_add();
    [Test]
    procedure Subtract_equal_pos_is_zero();
    [Test]
    procedure Subtract_equal_neg_is_zero();
    [Test]
    procedure Subtract_both_pos_first_larger_no_borrow();
    [Test]
    procedure Subtract_both_pos_first_smaller_no_borrow();
    [Test]
    procedure Subtract_both_neg_first_larger_no_borrow();
    [Test]
    procedure Subtract_both_neg_first_smaller_no_borrow();
    [Test]
    procedure Subtract_both_pos_first_larger_some_borrow();
    [Test]
    procedure Subtract_both_pos_first_larger_lose_MSB();
    [Test]
    procedure Subtract_both_pos_first_larger_lose_several_MSB();
    [Test]
    procedure Abs_zero_is_zero();
    [Test]
    procedure Abs_pos_is_pos();
    [Test]
    procedure Abs_neg_is_pos();
    [Test]
    procedure Mult_x_by_zero_is_zero();
    [Test]
    procedure Mult_zero_by_y_is_zero();
    [Test]
    procedure Mult_two_pos_is_pos();
    [Test]
    procedure Mult_two_neg_is_pos();
    [Test]
    procedure Mult_pos_neg_is_neg();
    [Test]
    procedure Mult_neg_pos_is_neg();
    [Test]
    procedure Mult_1();
    [Test]
    procedure Mult_2();
    [Test]
    procedure Mult_3();
    [Test]
    procedure Normalize_shifts_happens_different_len();
    [Test]
    procedure Normalize_shifts_happens_same_len();
    [Test]
    procedure Normalize_shifts_over_left_end_throws();
    [Test]
    procedure Divide_by_zero_throws();
    [Test]
    procedure Divide_into_zero_is_zero();
    [Test]
    procedure Divide_into_smaller_is_zero_plus_remainder_is_dividend();
    [Test]
    procedure Divide_into_smaller_is_zero_plus_remainder_is_dividend_len_difference
      ();
    [Test]
    procedure Divide_same_on_len_1();
    [Test]
    procedure Divide_same_on_len_3();
    [Test]
    procedure Divide_same_except_small_remainder();
    [Test]
    procedure Divide_same_except_small_remainder_2();
    [Test]
    procedure Divide_two_digits_with_small_remainder_no_shift();
    [Test]
    procedure Divide_two_digits_with_small_remainder_no_shift2();
    [Test]
    procedure Divide_two_digits_with_small_remainder_small_shift();
    [Test]
    procedure TestKnuthExamples();
    [Test]
    procedure Power_on_negative_exponent_fails();
    [Test]
    procedure Power_with_exponent_0_is_one();
    [Test]
    procedure Power_on_zero_is_zero();
    [Test]
    procedure Power_on_small_exponent_works();
    [Test]
    procedure Power_on_completely_odd_exponent_works();
    [Test]
    procedure Power_on_power_of_two_exponent_works();
    [Test]
    procedure ModPow_on_negative_exponent_fails();
    [Test]
    procedure ModPow_with_exponent_0_is_one();
    [Test]
    procedure ModPow_on_zero_is_zero();
    [Test]
    procedure ModPow_on_small_exponent_works();
    [Test]
    procedure ModPow_on_completely_odd_exponent_works();
    [Test]
    procedure ModPow_on_power_of_two_exponent_works();
    [Test]
    procedure IsOddWorks();
    [Test]
    procedure GCD_simple_case();
    [Test]
    procedure GCD_test_signs();
    [Test]
    procedure GCD_test_disparity_in_size();
    [Test]
    procedure GCD_test_many_powers_of_two();
    [Test]
    procedure GCD_test_relatively_prime();
    [Test]
    procedure GCD_test_multiple();
    [Test]
    procedure BitAnd_pos_pos();
    [Test]
    procedure BitAnd_pos_neg();
    [Test]
    procedure BitAnd_neg_pos();
    [Test]
    procedure BitAnd_neg_neg();
    [Test]
    procedure BitOr_pos_pos();
    [Test]
    procedure BitOr_pos_neg();
    [Test]
    procedure BitOr_neg_pos();
    [Test]
    procedure BitOr_neg_neg();
    [Test]
    procedure BitXor_pos_pos();
    [Test]
    procedure BitXor_pos_neg();
    [Test]
    procedure BitXor_neg_pos();
    [Test]
    procedure BitXor_neg_neg();
    [Test]
    procedure BitAndNot_pos_pos();
    [Test]
    procedure BitAndNot_pos_neg();
    [Test]
    procedure BitAndNot_neg_pos();
    [Test]
    procedure BitAndNot_neg_neg();
    [Test]
    procedure BitNot_pos();
    [Test]
    procedure BitNot_neg();
    [Test]
    procedure TestBit_pos_inside();
    [Test]
    procedure TestBit_neg_inside();
    [Test]
    procedure TestBit_pos_outside();
    [Test]
    procedure TestBit_neg_outside();
    [Test]
    procedure SetBit_pos_inside_initial_set();
    [Test]
    procedure SetBit_pos_inside_initial_clear();
    [Test]
    procedure SetBit_pos_outside();
    [Test]
    procedure SetBit_neg_inside_initial_set();
    [Test]
    procedure SetBit_neg_inside_initial_clear();
    [Test]
    procedure SetBit_neg_outside();
    [Test]
    procedure ClearBit_pos_inside_initial_set();
    [Test]
    procedure ClearBit_pos_inside_initial_clear();
    [Test]
    procedure ClearBit_pos_outside();
    [Test]
    procedure ClearBit_neg_inside_initial_set();
    [Test]
    procedure ClearBit_neg_inside_initial_clear();
    [Test]
    procedure ClearBit_neg_outside();
    [Test]
    procedure FlipBit_pos_inside_initial_set();
    [Test]
    procedure FlipBit_pos_inside_initial_clear();
    [Test]
    procedure FlipBit_pos_outside();
    [Test]
    procedure FlipBit_neg_inside_initial_set();
    [Test]
    procedure FlipBit_neg_inside_initial_clear();
    [Test]
    procedure FlipBit_neg_outside();
    [Test]
    procedure LeftShift_zero_is_zero();
    [Test]
    procedure LeftShift_neg_shift_same_as_right_shift();
    [Test]
    procedure LeftShift_zero_shift_is_this();
    [Test]
    procedure LeftShift_pos_whole_digit_shift_adds_zeros_at_end();
    [Test]
    procedure LeftShift_pos_small_shift();
    [Test]
    procedure LeftShift_neg_small_shift();
    [Test]
    procedure LeftShift_pos_big_shift();
    [Test]
    procedure LeftShift_neg_big_shift();
    [Test]
    procedure LeftShift_pos_big_shift_zero_high_bits();
    [Test]
    procedure RightShift_zero_is_zero();
    [Test]
    procedure RightShift_neg_shift_same_as_left_shift();
    [Test]
    procedure RightShift_zero_shift_is_this();
    [Test]
    procedure RightShift_pos_whole_digit_shift_loses_whole_digits();
    [Test]
    procedure RightShift_neg_whole_digit_shift_loses_whole_digits();
    [Test]
    procedure RightShift_pos_small_shift();
    [Test]
    procedure RightShift_neg_small_shift();
    [Test]
    procedure RightShift_pos_big_shift();
    [Test]
    procedure RightShift_neg_big_shift();
    [Test]
    procedure RightShift_pos_big_shift_zero_high_bits();
    [Test]
    procedure AsInt32_various();
    [Test]
    procedure AsInt64_various();
    [Test]
    procedure AsUInt32_various();
    [Test]
    procedure AsUInt64_various();
    [Test]
    procedure Equals_TI_on_default_is_false();
    [Test]
    procedure Equals_TI_on_same_is_true();
    [Test]
    procedure Equals_TI_on_different_is_false();
    [Test]
    procedure PrecisionSingleDigitsIsOne();
    [Test]
    procedure PrecisionTwoDigitsIsTwo();
    [Test]
    procedure PrecisionThreeDigitsIsThree();
    [Test]
    procedure PrecisionBoundaryCases();
    [Test]
    procedure PrecisionBoundaryCase2();

    class function SameValue(i: TIntegerX; sign: Integer;
      mag: TArray<UInt32>): Boolean;
    class function SameSign(s1: Integer; s2: Integer): Boolean;
    class function SameMag(xs: TArray<UInt32>; ys: TArray<UInt32>): Boolean;
  end;

implementation

{$REGION 'Basic accessor tests'}

procedure TIntegerXTest.Signum_is_zero_for_zero();
var
  i: TIntegerX;
begin
  i := TIntegerX.Create(0);
  Assert.IsTrue(i.Signum = 0);

end;

procedure TIntegerXTest.Magnitude_is_same_for_pos_and_neg();
var
  neg, pos: TIntegerX;
begin
  neg := TIntegerX.Create(-100);
  pos := TIntegerX.Create(+100);
  Assert.IsTrue(SameMag(neg.GetMagnitude(), pos.GetMagnitude()));

end;

procedure TIntegerXTest.Magnitude_is_zero_length_for_zero();
var
  i: TIntegerX;
begin
  i := TIntegerX.Create(0);
  Assert.IsTrue(Length(i.GetMagnitude()) = 0);
end;

procedure TIntegerXTest.Signum_is_m1_for_negative();
var
  i: TIntegerX;
begin
  i := TIntegerX.Create(-100);
  Assert.IsTrue(i.Signum = -1);
end;

procedure TIntegerXTest.Signum_is_1_for_negative();
var
  i: TIntegerX;
begin
  i := TIntegerX.Create(+100);
  Assert.IsTrue(i.Signum = 1);
end;

procedure TIntegerXTest.IsPositive_works();
var
  i: TIntegerX;
begin
  i := TIntegerX.Create(0);
  Assert.IsTrue(i.IsPositive = False);

  i := TIntegerX.Create(100);
  Assert.IsTrue(i.IsPositive);

  i := TIntegerX.Create(-100);
  Assert.IsTrue(i.IsPositive = False);
end;

procedure TIntegerXTest.IsNegative_works();
var
  i: TIntegerX;
begin
  i := TIntegerX.Create(0);
  Assert.IsTrue(i.IsNegative = False);

  i := TIntegerX.Create(-100);
  Assert.IsTrue(i.IsNegative);

  i := TIntegerX.Create(100);
  Assert.IsTrue(i.IsNegative = False);
end;

procedure TIntegerXTest.IsZero_works();
var
  i: TIntegerX;
begin
  i := TIntegerX.Create(0);
  Assert.IsTrue(i.IsZero);

  i := TIntegerX.Create(-100);
  Assert.IsTrue(i.IsZero = False);

  i := TIntegerX.Create(100);
  Assert.IsTrue(i.IsZero = False);
end;
{$ENDREGION}
{$REGION 'Basic factory tests'}

procedure TIntegerXTest.Create_uint64_various();
var
  i: TIntegerX;
  temp: TArray<UInt32>;
begin

  i := TIntegerX.Create(UInt64(0));
  SetLength(temp, 0);
  Assert.IsTrue(SameValue(i, 0, temp));

  i := TIntegerX.Create(UInt64(100));
  Assert.IsTrue(SameValue(i, 1, TArray<UInt32>.Create(100)));

  i := TIntegerX.Create(UInt64($00FFEEDDCCBBAA99));
  Assert.IsTrue(SameValue(i, 1, TArray<UInt32>.Create($00FFEEDD, $CCBBAA99)));
end;

procedure TIntegerXTest.Create_uint32_various();
var
  i: TIntegerX;
  temp: TArray<UInt32>;
begin
  i := TIntegerX.Create(UInt32(0));
  SetLength(temp, 0);
  Assert.IsTrue(SameValue(i, 0, temp));

  i := TIntegerX.Create(UInt32(100));
  Assert.IsTrue(SameValue(i, 1, TArray<UInt32>.Create(100)));

  i := TIntegerX.Create(UInt64($FFEEDDCC));
  Assert.IsTrue(SameValue(i, 1, TArray<UInt32>.Create($FFEEDDCC)));
end;

procedure TIntegerXTest.Create_int64_various();
var
  i: TIntegerX;
  temp: TArray<UInt32>;
begin

  i := TIntegerX.Create(Int64(0));
  SetLength(temp, 0);
  Assert.IsTrue(SameValue(i, 0, temp));

  i := TIntegerX.Create(Int64.MinValue);
  Assert.IsTrue(SameValue(i, -1, TArray<UInt32>.Create($80000000, 0)));

  i := TIntegerX.Create(Int64(100));
  Assert.IsTrue(SameValue(i, 1, TArray<UInt32>.Create(100)));

  i := TIntegerX.Create(Int64(-100));
  Assert.IsTrue(SameValue(i, -1, TArray<UInt32>.Create(100)));

  i := TIntegerX.Create(Int64($00FFEEDDCCBBAA99));
  Assert.IsTrue(SameValue(i, 1, TArray<UInt32>.Create($00FFEEDD, $CCBBAA99)));

  i := TIntegerX.Create(Int64($FFFFEEDDCCBBAA99));
  Assert.IsTrue(SameValue(i, -1, TArray<UInt32>.Create($00001122, $33445567)));
end;

procedure TIntegerXTest.Create_integer_various();
var
  i: TIntegerX;
  temp: TArray<UInt32>;
begin

  i := TIntegerX.Create(Integer(0));
  SetLength(temp, 0);
  Assert.IsTrue(SameValue(i, 0, temp));

  i := TIntegerX.Create(Int32.MinValue);
  Assert.IsTrue(SameValue(i, -1, TArray<UInt32>.Create($80000000)));

  i := TIntegerX.Create(Integer(100));
  Assert.IsTrue(SameValue(i, 1, TArray<UInt32>.Create(100)));

  i := TIntegerX.Create(Integer(-100));
  Assert.IsTrue(SameValue(i, -1, TArray<UInt32>.Create(100)));

  i := TIntegerX.Create(Integer($00FFEEDD));
  Assert.IsTrue(SameValue(i, 1, TArray<UInt32>.Create($00FFEEDD)));

  i := TIntegerX.Create((Integer($FFFFEEDD)));
  Assert.IsTrue(SameValue(i, -1, TArray<UInt32>.Create($00001123)));
end;

[Test]
procedure TIntegerXTest.Create_double_various();
var
  i: TIntegerX;
  temp: TArray<UInt32>;
begin
  i := TIntegerX.Create(0.0);
  SetLength(temp, 0);
  Assert.IsTrue(SameValue(i, 0, temp));

  i := TIntegerX.Create(1.0);
  Assert.IsTrue(SameValue(i, 1, TArray<UInt32>.Create(1)));

  i := TIntegerX.Create(-1.0);
  Assert.IsTrue(SameValue(i, -1, TArray<UInt32>.Create(1)));

  i := TIntegerX.Create(10.0);
  Assert.IsTrue(SameValue(i, 1, TArray<UInt32>.Create(10)));

  i := TIntegerX.Create(12345678.123);
  Assert.IsTrue(SameValue(i, 1, TArray<UInt32>.Create(12345678)));

  i := TIntegerX.Create(4.2949672950000000E+009);
  Assert.IsTrue(SameValue(i, 1, TArray<UInt32>.Create(4294967295)));

  i := TIntegerX.Create(4.2949672960000000E+009);
  Assert.IsTrue(SameValue(i, 1, TArray<UInt32>.Create($1, $0)));

  i := TIntegerX.Create(-1.2345678901234569E+300);
  Assert.IsTrue(SameValue(i, -1, TArray<UInt32>.Create($1D, $7EE8BCBB,
    $D3520000, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0,
    $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0)));

end;

procedure TIntegerXTest.Create_double_powers_of_two();
var
  i: Integer;
  b: TIntegerX;
begin
  i := 0;
  // Powers of two are special-cased in the code.
  while i < Math.LogN(2, Double.MaxValue) do
  begin
    b := TIntegerX.Create(Math.Power(2.0, i));
    Assert.IsTrue(b = (TIntegerX.One shl i));
    Inc(i);
  end;
end;

procedure TIntegerXTest.Create_double_fails_on_pos_infinity();
var
  lMethod: TTestLocalMethod;
begin
  lMethod := procedure
    begin
      TIntegerX.Create(Double.PositiveInfinity);
    end;
  Assert.WillRaise(lMethod, EOverFlowException);

end;

procedure TIntegerXTest.Create_double_fails_on_neg_infinity();
var
  lMethod: TTestLocalMethod;
begin
  lMethod := procedure
    begin
      TIntegerX.Create(Double.NegativeInfinity);
    end;
  Assert.WillRaise(lMethod, EOverFlowException);

end;

procedure TIntegerXTest.Create_double_fails_on_NaN();
var
  lMethod: TTestLocalMethod;
begin
  lMethod := procedure
    begin
      TIntegerX.Create(Double.NaN);
    end;
  Assert.WillRaise(lMethod, EOverFlowException);

end;

{$ENDREGION}
{$REGION 'Constructor tests'}

procedure TIntegerXTest.TI_basic_constructor_handles_zero();
var
  i: TIntegerX;
  temp: TArray<UInt32>;
begin
  i := TIntegerX.Create(0);
  SetLength(temp, 0);
  Assert.IsTrue(SameValue(i, 0, temp));
end;

procedure TIntegerXTest.TI_basic_constructor_handles_basic_data_positive();
var
  data: TArray<UInt32>;
  i: TIntegerX;
begin
  data := TArray<UInt32>.Create($FFEEDDCC, $BBAA9988, $77665544);
  i := TIntegerX.Create(1, data);
  Assert.IsTrue(i.IsPositive);
  Assert.IsTrue(SameValue(i, 1, data));
end;

[Test]
procedure TIntegerXTest.TI_basic_constructor_handles_basic_data_negative();
var
  data: TArray<UInt32>;
  i: TIntegerX;
begin
  data := TArray<UInt32>.Create($FFEEDDCC, $BBAA9988, $77665544);
  i := TIntegerX.Create(-1, data);
  Assert.IsTrue(i.IsNegative);
  Assert.IsTrue(SameValue(i, -1, data));
end;

procedure TIntegerXTest.TI_basic_constructor_fails_on_bad_sign_neg();
var
  lMethod: TTestLocalMethod;
  data: TArray<UInt32>;
begin
  data := TArray<UInt32>.Create(1);
  lMethod := procedure
    begin
      TIntegerX.Create(-2, data);
    end;
  Assert.WillRaise(lMethod, EArgumentException);
end;

procedure TIntegerXTest.TI_basic_constructor_fails_on_bad_sign_pos();
var
  lMethod: TTestLocalMethod;
  data: TArray<UInt32>;
begin
  data := TArray<UInt32>.Create(1);
  lMethod := procedure
    begin
      TIntegerX.Create(2, data);
    end;
  Assert.WillRaise(lMethod, EArgumentException);
end;

procedure TIntegerXTest.
  TI_basic_constructor_fails_on_zero_sign_on_nonzero_mag();
var
  lMethod: TTestLocalMethod;
  data: TArray<UInt32>;
begin
  data := TArray<UInt32>.Create(1);
  lMethod := procedure
    begin
      TIntegerX.Create(0, data);
    end;
  Assert.WillRaise(lMethod, EArgumentException);
end;

procedure TIntegerXTest.TI_basic_constructor_normalized_magnitude();
var
  data, normData: TArray<UInt32>;
  i: TIntegerX;
begin
  data := TArray<UInt32>.Create(0, 0, 1, 0);
  normData := TArray<UInt32>.Create(1, 0);
  i := TIntegerX.Create(1, data);
  Assert.IsTrue(SameValue(i, 1, normData));
end;

procedure TIntegerXTest.TI_basic_constructor_detects_all_zero_mag();
var
  data, temp: TArray<UInt32>;
  i: TIntegerX;
begin
  data := TArray<UInt32>.Create(0, 0, 0, 0, 0);
  i := TIntegerX.Create(1, data);
  SetLength(temp, 0);
  Assert.IsTrue(SameValue(i, 0, temp));
end;

procedure TIntegerXTest.TI_copy_constructor_works();
var
  i, c: TIntegerX;
begin
  i := TIntegerX.Create(1, TArray<UInt32>.Create(1, 2, 3));
  c := TIntegerX.Create(i);
  Assert.IsTrue(SameValue(c, i.Signum, i.GetMagnitude()));
end;

{$ENDREGION}
{$REGION 'Parsing tests'}

procedure TIntegerXTest.Parse_detects_radix_too_small();
var
  i: TIntegerX;
  result: Boolean;
begin
  result := TIntegerX.TryParse('0', 1, i);
  Assert.IsTrue(result = False);
end;

procedure TIntegerXTest.Parse_detects_radix_too_large();
var
  i: TIntegerX;
  result: Boolean;
begin
  result := TIntegerX.TryParse('0', 37, i);
  Assert.IsTrue(result = False);
end;

procedure TIntegerXTest.Parse_zero();
var
  i: TIntegerX;
  result: Boolean;
  temp: TArray<UInt32>;
begin
  result := TIntegerX.TryParse('0', 10, i);
  Assert.IsTrue(result);
  SetLength(temp, 0);
  Assert.IsTrue(SameValue(i, 0, temp));
end;

procedure TIntegerXTest.Parse_negative_zero_just_zero();
var
  i: TIntegerX;
  result: Boolean;
  temp: TArray<UInt32>;
begin
  result := TIntegerX.TryParse('-0', 10, i);
  Assert.IsTrue(result);
  SetLength(temp, 0);
  Assert.IsTrue(SameValue(i, 0, temp));
end;

procedure TIntegerXTest.Parse_multiple_zeros_is_zero();
var
  i: TIntegerX;
  result: Boolean;
  temp: TArray<UInt32>;
begin
  result := TIntegerX.TryParse('00000', 10, i);
  Assert.IsTrue(result);
  SetLength(temp, 0);
  Assert.IsTrue(SameValue(i, 0, temp));
end;

procedure TIntegerXTest.Parse_multiple_zeros_with_leading_minus_is_zero();
var
  i: TIntegerX;
  result: Boolean;
  temp: TArray<UInt32>;
begin
  result := TIntegerX.TryParse('-00000', 10, i);
  Assert.IsTrue(result);
  SetLength(temp, 0);
  Assert.IsTrue(SameValue(i, 0, temp));
end;

procedure TIntegerXTest.Parse_multiple_hyphens_fails();
var
  i: TIntegerX;
  result: Boolean;
begin
  result := TIntegerX.TryParse('-123-4', 10, i);
  Assert.IsTrue(result = False);
end;

procedure TIntegerXTest.Parse_adjacent_hyphens_fails();
var
  i: TIntegerX;
  result: Boolean;
begin
  result := TIntegerX.TryParse('--1234', 10, i);
  Assert.IsTrue(result = False);
end;

procedure TIntegerXTest.Parse_just_adjacent_hyphens_fails();
var
  i: TIntegerX;
  result: Boolean;
begin
  result := TIntegerX.TryParse('--', 10, i);
  Assert.IsTrue(result = False);
end;

procedure TIntegerXTest.Parse_hyphen_only_fails();
var
  i: TIntegerX;
  result: Boolean;
begin
  result := TIntegerX.TryParse('-', 10, i);
  Assert.IsTrue(result = False);
end;

procedure TIntegerXTest.Parse_fails_on_bogus_char();
var
  i: TIntegerX;
  result: Boolean;
begin
  result := TIntegerX.TryParse('123.56', 10, i);
  Assert.IsTrue(result = False);
end;

procedure TIntegerXTest.Parse_fails_on_digit_out_of_range_base_2();
var
  i: TIntegerX;
  result: Boolean;
begin
  result := TIntegerX.TryParse('01010120101', 2, i);
  Assert.IsTrue(result = False);
end;

procedure TIntegerXTest.Parse_fails_on_digit_out_of_range_base_8();
var
  i: TIntegerX;
  result: Boolean;
begin
  result := TIntegerX.TryParse('01234567875', 8, i);
  Assert.IsTrue(result = False);
end;

procedure TIntegerXTest.Parse_fails_on_digit_out_of_range_base_16();
var
  i: TIntegerX;
  result: Boolean;
begin
  result := TIntegerX.TryParse('CabBaGe', 16, i);
  Assert.IsTrue(result = False);
end;

procedure TIntegerXTest.
  Parse_fails_on_digit_out_of_range_in_later_super_digit_base_16();
var
  i: TIntegerX;
  result: Boolean;
begin
  result := TIntegerX.TryParse('AAAAAAAAAAAAAAAAAAAAAAACabBaGe', 16, i);
  Assert.IsTrue(result = False);
end;

procedure TIntegerXTest.Parse_simple_base_2();
var
  i: TIntegerX;
  result: Boolean;
begin
  result := TIntegerX.TryParse('100', 2, i);
  Assert.IsTrue(result);
  Assert.IsTrue(SameValue(i, 1, TArray<UInt32>.Create(4)));
end;

procedure TIntegerXTest.Parse_simple_base_10();
var
  i: TIntegerX;
  result: Boolean;
begin
  result := TIntegerX.TryParse('100', 10, i);
  Assert.IsTrue(result);
  Assert.IsTrue(SameValue(i, 1, TArray<UInt32>.Create(100)));
end;

procedure TIntegerXTest.Parse_simple_base_16();
var
  i: TIntegerX;
  result: Boolean;
begin
  result := TIntegerX.TryParse('100', 16, i);
  Assert.IsTrue(result);
  Assert.IsTrue(SameValue(i, 1, TArray<UInt32>.Create($100)));
end;

procedure TIntegerXTest.Parse_simple_base_36();
var
  i: TIntegerX;
  result: Boolean;
begin
  result := TIntegerX.TryParse('100', 36, i);
  Assert.IsTrue(result);
  Assert.IsTrue(SameValue(i, 1, TArray<UInt32>.Create(36 * 36)));
end;

procedure TIntegerXTest.Parse_works_on_long_string_base_16();
var
  i: TIntegerX;
  result: Boolean;
begin
  result := TIntegerX.TryParse('100000000000000000000', 16, i);
  Assert.IsTrue(result);
  Assert.IsTrue(SameValue(i, 1, TArray<UInt32>.Create($00010000, 0, 0)));
end;

procedure TIntegerXTest.Parse_works_on_long_string_base_10();
var
  i: TIntegerX;
  result: Boolean;
begin
  result := TIntegerX.TryParse('123456789012345678901234567890', 10, i);
  Assert.IsTrue(result);
  Assert.IsTrue(SameValue(i, 1, TArray<UInt32>.Create($1, $8EE90FF6, $C373E0EE,
    $4E3F0AD2)));
end;

procedure TIntegerXTest.Parse_works_with_leading_minus_sign();
var
  i: TIntegerX;
  result: Boolean;
begin
  result := TIntegerX.TryParse('-123456789012345678901234567890', 10, i);
  Assert.IsTrue(result);
  Assert.IsTrue(SameValue(i, -1, TArray<UInt32>.Create($1, $8EE90FF6, $C373E0EE,
    $4E3F0AD2)));
end;

procedure TIntegerXTest.Parse_works_with_leading_plus_sign();
var
  i: TIntegerX;
  result: Boolean;
begin
  result := TIntegerX.TryParse('+123456789012345678901234567890', 10, i);
  Assert.IsTrue(result);
  Assert.IsTrue(SameValue(i, 1, TArray<UInt32>.Create($1, $8EE90FF6, $C373E0EE,
    $4E3F0AD2)));
end;

procedure TIntegerXTest.Parse_works_on_long_string_base_10_2();
var
  i: TIntegerX;
  result: Boolean;
begin
  result := TIntegerX.TryParse('1024000001024000001024', 10, i);
  Assert.IsTrue(result);
  Assert.IsTrue(SameValue(i, 1, TArray<UInt32>.Create($37, $82DACF8B,
    $FB280400)));
end;

{$ENDREGION}
{$REGION 'ToString tests'}

procedure TIntegerXTest.ToString_fails_on_radix_too_small();
var
  lMethod: TTestLocalMethod;
  data: TArray<UInt32>;
  i: TIntegerX;
begin
  SetLength(data, 0);
  lMethod := procedure
    begin
      i := TIntegerX.Create(0, data);
      i.ToString(1);
    end;
  Assert.WillRaise(lMethod, EArgumentOutOfRangeException);
end;

procedure TIntegerXTest.ToString_detects_radix_too_large();
var
  lMethod: TTestLocalMethod;
  data: TArray<UInt32>;
  i: TIntegerX;
begin
  SetLength(data, 0);
  lMethod := procedure
    begin
      i := TIntegerX.Create(0, data);
      i.ToString(37);
    end;
  Assert.WillRaise(lMethod, EArgumentOutOfRangeException);
end;

procedure TIntegerXTest.ToString_on_zero_works_for_all_radixes();
const
  MinRadix = Integer(2);
  MaxRadix = Integer(36);
var
  i: TIntegerX;
  radix: UInt32;
  data: TArray<UInt32>;
begin
  SetLength(data, 0);
  i := TIntegerX.Create(0, data);
  radix := MinRadix;
  while radix <= UInt32(MaxRadix) do
  begin
    Assert.IsTrue(i.ToString(radix) = '0');
    Inc(radix);
  end;
end;

procedure TIntegerXTest.ToString_simple_base_2();
var
  i: TIntegerX;
  result: String;
begin
  i := TIntegerX.Create(1, TArray<UInt32>.Create(4));
  result := i.ToString(2);
  Assert.IsTrue(result = '100');
end;

procedure TIntegerXTest.ToString_simple_base_10();
var
  i: TIntegerX;
  result: String;
begin
  i := TIntegerX.Create(1, TArray<UInt32>.Create(927));
  result := i.ToString(10);
  Assert.IsTrue(result = '927');
end;

procedure TIntegerXTest.ToString_simple_base_16();
var
  i: TIntegerX;
  result: String;
begin
  i := TIntegerX.Create(1, TArray<UInt32>.Create($A20F5));
  result := i.ToString(16);
  Assert.IsTrue(result = 'A20F5');
end;

procedure TIntegerXTest.ToString_simple_base_26();
var
  i: TIntegerX;
  result: String;
begin
  i := TIntegerX.Create(1, TArray<UInt32>.Create(23 * 26 * 26 + 12 * 26 + 15));
  result := i.ToString(26);
  Assert.IsTrue(result = 'NCF');
end;

procedure TIntegerXTest.ToString_long_base_16();
var
  i: TIntegerX;
  result: String;
begin
  i := TIntegerX.Create(-1, TArray<UInt32>.Create($00FEDCBA, $12345678,
    $87654321));
  result := i.ToString(16);
  Assert.IsTrue(result = '-FEDCBA1234567887654321');
end;

procedure TIntegerXTest.ToString_long_base_10();
var
  i: TIntegerX;
  result: String;
begin
  i := TIntegerX.Create(1, TArray<UInt32>.Create($1, $8EE90FF6, $C373E0EE,
    $4E3F0AD2));
  result := i.ToString(10);
  Assert.IsTrue(result = '123456789012345678901234567890');
end;

procedure TIntegerXTest.ToString_long_base_10_2();
var
  i: TIntegerX;
  result: String;
begin
  i := TIntegerX.Create(1, TArray<UInt32>.Create($37, $82DACF8B, $FB280400));
  result := i.ToString(10);
  Assert.IsTrue(result = '1024000001024000001024');
end;

{$ENDREGION}
{$REGION 'Comparison tests'}

procedure TIntegerXTest.Compare_on_zeros_is_0();
var
  x, y: TIntegerX;
  temp: TArray<UInt32>;
begin
  SetLength(temp, 0);
  x := TIntegerX.Create(0, temp);
  y := TIntegerX.Create(0, temp);
  Assert.IsTrue(TIntegerX.Compare(x, y) = 0);
end;

procedure TIntegerXTest.Compare_neg_pos_is_minus1();
var
  x, y: TIntegerX;
begin
  x := TIntegerX.Create(-1, TArray<UInt32>.Create($FFFFFFFF, $FFFFFFFF));
  y := TIntegerX.Create(1, TArray<UInt32>.Create($1));
  Assert.IsTrue(TIntegerX.Compare(x, y) = -1);
end;

procedure TIntegerXTest.Compare_pos_neg_is_plus1();
var
  x, y: TIntegerX;
begin
  x := TIntegerX.Create(1, TArray<UInt32>.Create($1));
  y := TIntegerX.Create(-1, TArray<UInt32>.Create($FFFFFFFF, $FFFFFFFF));

  Assert.IsTrue(TIntegerX.Compare(x, y) = 1);
end;

procedure TIntegerXTest.Compare_negs_smaller_len_first_is_plus1();
var
  x, y: TIntegerX;
begin
  x := TIntegerX.Create(-1, TArray<UInt32>.Create($FFFFFFFF));
  y := TIntegerX.Create(-1, TArray<UInt32>.Create($FFFFFFFF, $FFFFFFFF));

  Assert.IsTrue(TIntegerX.Compare(x, y) = 1);
end;

procedure TIntegerXTest.Compare_negs_larger_len_first_is_minus1();
var
  x, y: TIntegerX;
begin
  x := TIntegerX.Create(-1, TArray<UInt32>.Create($FFFFFFFF, $FFFFFFFF));
  y := TIntegerX.Create(-1, TArray<UInt32>.Create($FFFFFFFF));

  Assert.IsTrue(TIntegerX.Compare(x, y) = -1);
end;

procedure TIntegerXTest.Compare_pos_smaller_len_first_is_minus1();
var
  x, y: TIntegerX;
begin
  x := TIntegerX.Create(1, TArray<UInt32>.Create($FFFFFFFF));
  y := TIntegerX.Create(1, TArray<UInt32>.Create($FFFFFFFF, $FFFFFFFF));

  Assert.IsTrue(TIntegerX.Compare(x, y) = -1);
end;

procedure TIntegerXTest.Compare_pos_larger_len_first_is_plus1();
var
  x, y: TIntegerX;
begin
  x := TIntegerX.Create(1, TArray<UInt32>.Create($FFFFFFFF, $FFFFFFFF));
  y := TIntegerX.Create(1, TArray<UInt32>.Create($FFFFFFFF));

  Assert.IsTrue(TIntegerX.Compare(x, y) = 1);
end;

procedure TIntegerXTest.Compare_same_len_smaller_first_diff_in_MSB_is_minus1();
var
  x, y: TIntegerX;
begin
  x := TIntegerX.Create(1, TArray<UInt32>.Create($FFFFFFFE, $12345678,
    $FFFFFFFF));
  y := TIntegerX.Create(1, TArray<UInt32>.Create($FFFFFFFF, $12345678,
    $FFFFFFFF));

  Assert.IsTrue(TIntegerX.Compare(x, y) = -1);
end;

procedure TIntegerXTest.
  Compare_same_len_smaller_first_diff_in_middle_is_minus1();
var
  x, y: TIntegerX;
begin
  x := TIntegerX.Create(1, TArray<UInt32>.Create($FFFFFFFF, $12345678,
    $FFFFFFFE));
  y := TIntegerX.Create(1, TArray<UInt32>.Create($FFFFFFFF, $12345678,
    $FFFFFFFF));

  Assert.IsTrue(TIntegerX.Compare(x, y) = -1);
end;

procedure TIntegerXTest.Compare_same_len_larger_first_diff_in_MSB_is_plus1();
var
  x, y: TIntegerX;
begin
  x := TIntegerX.Create(1, TArray<UInt32>.Create($FFFFFFFE, $12345678,
    $FFFFFFFF));
  y := TIntegerX.Create(1, TArray<UInt32>.Create($FFFFFFFF, $12345678,
    $FFFFFFFF));

  Assert.IsTrue(TIntegerX.Compare(x, y) = -1);
end;

procedure TIntegerXTest.Compare_same_len_larger_first_diff_in_LSB_is_plus1();
var
  x, y: TIntegerX;
begin
  x := TIntegerX.Create(1, TArray<UInt32>.Create($FFFFFFFF, $12345678,
    $FFFFFFFE));
  y := TIntegerX.Create(1, TArray<UInt32>.Create($FFFFFFFF, $12345678,
    $FFFFFFFF));

  Assert.IsTrue(TIntegerX.Compare(x, y) = -1);
end;

procedure TIntegerXTest.Compare_same_len_larger_first_diff_in_middle_is_plus1();
var
  x, y: TIntegerX;
begin
  x := TIntegerX.Create(1, TArray<UInt32>.Create($FFFFFFFF, $12335678,
    $FFFFFFFF));
  y := TIntegerX.Create(1, TArray<UInt32>.Create($FFFFFFFF, $12345678,
    $FFFFFFFF));

  Assert.IsTrue(TIntegerX.Compare(x, y) = -1);
end;

procedure TIntegerXTest.Compare_same_is_0();
var
  x, y: TIntegerX;
begin
  x := TIntegerX.Create(1, TArray<UInt32>.Create($FFFFFFFF, $12345678,
    $FFFFFFFF));
  y := TIntegerX.Create(1, TArray<UInt32>.Create($FFFFFFFF, $12345678,
    $FFFFFFFF));

  Assert.IsTrue(TIntegerX.Compare(x, y) = 0);
end;

{$ENDREGION}
{$REGION 'Add/Subtract/Negate/Abs tests'}

procedure TIntegerXTest.Negate_zero_is_zero();
var
  x, xn: TIntegerX;
  temp: TArray<UInt32>;
begin
  SetLength(temp, 0);
  x := TIntegerX.Create(0, temp);
  xn := x.Negate();
  Assert.IsTrue(SameValue(xn, 0, temp));
end;

procedure TIntegerXTest.Negate_positive_is_same_mag_neg();
var
  x, xn: TIntegerX;
begin
  x := TIntegerX.Create(1, TArray<UInt32>.Create($FEDCBA98, $87654321));
  xn := x.Negate();
  Assert.IsTrue(SameValue(xn, -1, x.GetMagnitude()));
end;

procedure TIntegerXTest.Negate_negative_is_same_mag_pos();
var
  x, xn: TIntegerX;
begin
  x := TIntegerX.Create(-1, TArray<UInt32>.Create($FEDCBA98, $87654321));
  xn := x.Negate();
  Assert.IsTrue(SameValue(xn, 1, x.GetMagnitude()));
end;

procedure TIntegerXTest.Add_pos_same_length_no_carry();
var
  x, y, z: TIntegerX;
begin
  x := TIntegerX.Create(1, TArray<UInt32>.Create($12345678, $12345678));
  y := TIntegerX.Create(1, TArray<UInt32>.Create($23456789, $13243546));
  z := x.add(y);

  Assert.IsTrue(SameValue(z, 1, TArray<UInt32>.Create($3579BE01, $25588BBE)));
end;

procedure TIntegerXTest.Add_neg_same_length_no_carry();
var
  x, y, z: TIntegerX;
begin
  x := TIntegerX.Create(-1, TArray<UInt32>.Create($12345678, $12345678));
  y := TIntegerX.Create(-1, TArray<UInt32>.Create($23456789, $13243546));
  z := x.add(y);

  Assert.IsTrue(SameValue(z, -1, TArray<UInt32>.Create($3579BE01, $25588BBE)));
end;

procedure TIntegerXTest.Add_pos_same_length_some_carry();
var
  x, y, z: TIntegerX;
begin
  x := TIntegerX.Create(1, TArray<UInt32>.Create($12345678, $12345678,
    $FFFFFFFF));
  y := TIntegerX.Create(1, TArray<UInt32>.Create($23456789, $13243546,
    $11111111));
  z := x.add(y);

  Assert.IsTrue(SameValue(z, 1, TArray<UInt32>.Create($3579BE01, $25588BBF,
    $11111110)));
end;

procedure TIntegerXTest.Add_neg_same_length_some_carry();
var
  x, y, z: TIntegerX;
begin
  x := TIntegerX.Create(-1, TArray<UInt32>.Create($12345678, $12345678,
    $FFFFFFFF));
  y := TIntegerX.Create(-1, TArray<UInt32>.Create($23456789, $13243546,
    $11111111));
  z := x.add(y);

  Assert.IsTrue(SameValue(z, -1, TArray<UInt32>.Create($3579BE01, $25588BBF,
    $11111110)));
end;

procedure TIntegerXTest.Add_pos_first_longer_one_carry();
var
  x, y, z: TIntegerX;
begin
  x := TIntegerX.Create(1, TArray<UInt32>.Create($12345678, $12345678,
    $FFFFFFFF, $22222222));
  y := TIntegerX.Create(1, TArray<UInt32>.Create($11111111, $11111111));
  z := x.add(y);

  Assert.IsTrue(SameValue(z, 1, TArray<UInt32>.Create($12345678, $12345679,
    $11111110, $33333333)));
end;

procedure TIntegerXTest.Add_pos_first_longer_more_carry();
var
  x, y, z: TIntegerX;
begin
  x := TIntegerX.Create(1, TArray<UInt32>.Create($12345678, $12345678,
    $FFFFFFFF, $FFFFFFFF, $22222222));
  y := TIntegerX.Create(1, TArray<UInt32>.Create($11111111, $11111111));
  z := x.add(y);

  Assert.IsTrue(SameValue(z, 1, TArray<UInt32>.Create($12345678, $12345679,
    $00000000, $11111110, $33333333)));
end;

procedure TIntegerXTest.Add_pos_first_longer_carry_extend();
var
  x, y, z: TIntegerX;
begin
  x := TIntegerX.Create(1, TArray<UInt32>.Create($FFFFFFFF, $FFFFFFFF,
    $FFFFFFFF, $22222222));
  y := TIntegerX.Create(1, TArray<UInt32>.Create($11111111, $11111111));
  z := x.add(y);

  Assert.IsTrue(SameValue(z, 1, TArray<UInt32>.Create($00000001, $00000000,
    $00000000, $11111110, $33333333)));
end;

procedure TIntegerXTest.Add_pos_neg_first_larger_mag();
var
  x, y, z: TIntegerX;
begin
  x := TIntegerX.Create(1, TArray<UInt32>.Create($5));
  y := TIntegerX.Create(-1, TArray<UInt32>.Create($3));
  z := x.add(y);

  Assert.IsTrue(SameValue(z, 1, TArray<UInt32>.Create($2)));
end;

procedure TIntegerXTest.Add_pos_neg_second_larger_mag();
var
  x, y, z: TIntegerX;
begin
  x := TIntegerX.Create(1, TArray<UInt32>.Create($3));
  y := TIntegerX.Create(-1, TArray<UInt32>.Create($5));
  z := x.add(y);

  Assert.IsTrue(SameValue(z, -1, TArray<UInt32>.Create($2)));
end;

procedure TIntegerXTest.Add_pos_neg_same_mag();
var
  x, y, z: TIntegerX;
begin
  x := TIntegerX.Create(1, TArray<UInt32>.Create($3));
  y := TIntegerX.Create(-1, TArray<UInt32>.Create($3));
  z := x.add(y);

  Assert.IsTrue(z.IsZero);
end;

procedure TIntegerXTest.Add_neg_pos_first_larger_mag();
var
  x, y, z: TIntegerX;
begin
  x := TIntegerX.Create(-1, TArray<UInt32>.Create($5));
  y := TIntegerX.Create(1, TArray<UInt32>.Create($3));
  z := x.add(y);

  Assert.IsTrue(SameValue(z, -1, TArray<UInt32>.Create($2)));
end;

procedure TIntegerXTest.Add_neg_pos_second_larger_mag();
var
  x, y, z: TIntegerX;
begin
  x := TIntegerX.Create(-1, TArray<UInt32>.Create($3));
  y := TIntegerX.Create(1, TArray<UInt32>.Create($5));
  z := x.add(y);

  Assert.IsTrue(SameValue(z, 1, TArray<UInt32>.Create($2)));
end;

procedure TIntegerXTest.Add_neg_pos_same_mag();
var
  x, y, z: TIntegerX;
begin
  x := TIntegerX.Create(-1, TArray<UInt32>.Create($3));
  y := TIntegerX.Create(1, TArray<UInt32>.Create($3));
  z := x.add(y);

  Assert.IsTrue(z.IsZero);
end;

procedure TIntegerXTest.Add_zero_to_pos();
var
  x, y, z: TIntegerX;
  temp: TArray<UInt32>;
begin
  SetLength(temp, 0);
  x := TIntegerX.Create(0, temp);
  y := TIntegerX.Create(1, TArray<UInt32>.Create($3));
  z := x.add(y);

  Assert.IsTrue(z = y);
end;

procedure TIntegerXTest.Subtract_zero_yields_this();
var
  x, y, z: TIntegerX;
  temp: TArray<UInt32>;
begin
  SetLength(temp, 0);
  x := TIntegerX.Create(1, TArray<UInt32>.Create($12345678, $12345678,
    $FFFFFFFF, $FFFFFFFF, $22222222));
  y := TIntegerX.Create(0, temp);
  z := x.Subtract(y);

  Assert.IsTrue(z = x);
end;

procedure TIntegerXTest.Subtract_from_zero_yields_negation();
var
  x, y, z: TIntegerX;
  temp: TArray<UInt32>;
begin
  SetLength(temp, 0);
  x := TIntegerX.Create(0, temp);
  y := TIntegerX.Create(1, TArray<UInt32>.Create($12345678, $12345678,
    $FFFFFFFF, $FFFFFFFF, $22222222));
  z := x.Subtract(y);

  Assert.IsTrue(SameValue(z, -1, y.GetMagnitude()));
end;

procedure TIntegerXTest.Subtract_opposite_sign_first_pos_is_add();
var
  x, y, z: TIntegerX;
begin
  x := TIntegerX.Create(1, TArray<UInt32>.Create($FFFFFFFF, $FFFFFFFF,
    $FFFFFFFF, $22222222));
  y := TIntegerX.Create(-1, TArray<UInt32>.Create($11111111, $11111111));
  z := x.Subtract(y);
  Assert.IsTrue(SameValue(z, 1, TArray<UInt32>.Create($00000001, $00000000,
    $00000000, $11111110, $33333333)));
end;

procedure TIntegerXTest.Subtract_opposite_sign_first_neg_is_add();
var
  x, y, z: TIntegerX;
begin
  x := TIntegerX.Create(-1, TArray<UInt32>.Create($FFFFFFFF, $FFFFFFFF,
    $FFFFFFFF, $22222222));
  y := TIntegerX.Create(1, TArray<UInt32>.Create($11111111, $11111111));
  z := x.Subtract(y);
  Assert.IsTrue(SameValue(z, -1, TArray<UInt32>.Create($00000001, $00000000,
    $00000000, $11111110, $33333333)));
end;

procedure TIntegerXTest.Subtract_equal_pos_is_zero();
var
  x, y, z: TIntegerX;
begin
  x := TIntegerX.Create(1, TArray<UInt32>.Create($FFFFFFFF, $FFFFFFFF,
    $FFFFFFFF, $22222222));
  y := TIntegerX.Create(1, TArray<UInt32>.Create($FFFFFFFF, $FFFFFFFF,
    $FFFFFFFF, $22222222));
  z := x.Subtract(y);
  Assert.IsTrue(z.IsZero);
end;

procedure TIntegerXTest.Subtract_equal_neg_is_zero();
var
  x, y, z: TIntegerX;
begin
  x := TIntegerX.Create(-1, TArray<UInt32>.Create($FFFFFFFF, $FFFFFFFF,
    $FFFFFFFF, $22222222));
  y := TIntegerX.Create(-1, TArray<UInt32>.Create($FFFFFFFF, $FFFFFFFF,
    $FFFFFFFF, $22222222));
  z := x.Subtract(y);
  Assert.IsTrue(z.IsZero);
end;

procedure TIntegerXTest.Subtract_both_pos_first_larger_no_borrow();
var
  x, y, z: TIntegerX;
begin
  x := TIntegerX.Create(1, TArray<UInt32>.Create($12345678, $12345678,
    $FFFFFFFF, $33333333));
  y := TIntegerX.Create(1, TArray<UInt32>.Create($11111111, $11111111));
  z := x.Subtract(y);
  Assert.IsTrue(SameValue(z, 1, TArray<UInt32>.Create($12345678, $12345678,
    $EEEEEEEE, $22222222)));;
end;

[Test]
procedure TIntegerXTest.Subtract_both_pos_first_smaller_no_borrow();
var
  x, y, z: TIntegerX;
begin
  x := TIntegerX.Create(1, TArray<UInt32>.Create($11111111, $11111111));
  y := TIntegerX.Create(1, TArray<UInt32>.Create($12345678, $12345678,
    $FFFFFFFF, $33333333));
  z := x.Subtract(y);
  Assert.IsTrue(SameValue(z, -1, TArray<UInt32>.Create($12345678, $12345678,
    $EEEEEEEE, $22222222)));;
end;

procedure TIntegerXTest.Subtract_both_neg_first_larger_no_borrow();
var
  x, y, z: TIntegerX;
begin
  x := TIntegerX.Create(1, TArray<UInt32>.Create($12345678, $12345678,
    $FFFFFFFF, $33333333));
  y := TIntegerX.Create(1, TArray<UInt32>.Create($11111111, $11111111));
  z := x.Subtract(y);
  Assert.IsTrue(SameValue(z, 1, TArray<UInt32>.Create($12345678, $12345678,
    $EEEEEEEE, $22222222)));;
end;

procedure TIntegerXTest.Subtract_both_neg_first_smaller_no_borrow();
var
  x, y, z: TIntegerX;
begin
  x := TIntegerX.Create(1, TArray<UInt32>.Create($11111111, $11111111));
  y := TIntegerX.Create(1, TArray<UInt32>.Create($12345678, $12345678,
    $FFFFFFFF, $33333333));
  z := x.Subtract(y);
  Assert.IsTrue(SameValue(z, -1, TArray<UInt32>.Create($12345678, $12345678,
    $EEEEEEEE, $22222222)));;
end;

procedure TIntegerXTest.Subtract_both_pos_first_larger_some_borrow();
var
  x, y, z: TIntegerX;
begin
  x := TIntegerX.Create(1, TArray<UInt32>.Create($12345678, $12345678,
    $00000000, $03333333));
  y := TIntegerX.Create(1, TArray<UInt32>.Create($11111111, $11111111));
  z := x.Subtract(y);
  Assert.IsTrue(SameValue(z, 1, TArray<UInt32>.Create($12345678, $12345677,
    $EEEEEEEE, $F2222222)));;
end;

procedure TIntegerXTest.Subtract_both_pos_first_larger_lose_MSB();
var
  x, y, z: TIntegerX;
begin
  x := TIntegerX.Create(1, TArray<UInt32>.Create($12345678, $12345678,
    $00000000, $33333333));
  y := TIntegerX.Create(1, TArray<UInt32>.Create($12345678, $12345676,
    $00000000, $44444444));
  z := x.Subtract(y);
  Assert.IsTrue(SameValue(z, 1, TArray<UInt32>.Create($1, $FFFFFFFF,
    $EEEEEEEF)));
end;

procedure TIntegerXTest.Subtract_both_pos_first_larger_lose_several_MSB();
var
  x, y, z: TIntegerX;
begin
  x := TIntegerX.Create(1, TArray<UInt32>.Create($12345678, $12345678,
    $12345678, $00000000, $33333333));
  y := TIntegerX.Create(1, TArray<UInt32>.Create($12345678, $12345678,
    $12345676, $00000000, $44444444));
  z := x.Subtract(y);
  Assert.IsTrue(SameValue(z, 1, TArray<UInt32>.Create($1, $FFFFFFFF,
    $EEEEEEEF)));;
end;

procedure TIntegerXTest.Abs_zero_is_zero();
var
  z: TIntegerX;
begin
  z := TIntegerX.Create(0);
  Assert.IsTrue(z.Abs().IsZero);
end;

procedure TIntegerXTest.Abs_pos_is_pos();
var
  data: TArray<UInt32>;
  i: TIntegerX;
begin
  data := TArray<UInt32>.Create($1, $2, $3);
  i := TIntegerX.Create(1, data);
  Assert.IsTrue(SameValue(i.Abs(), 1, data));
end;

procedure TIntegerXTest.Abs_neg_is_pos();
var
  data: TArray<UInt32>;
  i: TIntegerX;
begin
  data := TArray<UInt32>.Create($1, $2, $3);
  i := TIntegerX.Create(-1, data);
  Assert.IsTrue(SameValue(i.Abs(), 1, data));
end;

{$ENDREGION}
{$REGION 'Multiplication'}

procedure TIntegerXTest.Mult_x_by_zero_is_zero();
var
  x, y, z: TIntegerX;
  data: TArray<UInt32>;
begin
  SetLength(data, 0);
  x := TIntegerX.Create(1, TArray<UInt32>.Create($12345678));
  y := TIntegerX.Create(0, data);
  z := x.Multiply(y);
  Assert.IsTrue(z.IsZero);

end;

procedure TIntegerXTest.Mult_zero_by_y_is_zero();
var
  x, y, z: TIntegerX;
  data: TArray<UInt32>;
begin
  SetLength(data, 0);
  x := TIntegerX.Create(0, data);
  y := TIntegerX.Create(1, TArray<UInt32>.Create($12345678));
  z := x.Multiply(y);
  Assert.IsTrue(z.IsZero);

end;

procedure TIntegerXTest.Mult_two_pos_is_pos();
var
  x, y, z: TIntegerX;
begin
  x := TIntegerX.Create(1, TArray<UInt32>.Create($DEFCBA98));
  y := TIntegerX.Create(1, TArray<UInt32>.Create($12345678));
  z := x.Multiply(y);
  Assert.IsTrue(z.IsPositive);

end;

procedure TIntegerXTest.Mult_two_neg_is_pos();
var
  x, y, z: TIntegerX;
begin
  x := TIntegerX.Create(-1, TArray<UInt32>.Create($DEFCBA98));
  y := TIntegerX.Create(-1, TArray<UInt32>.Create($12345678));
  z := x.Multiply(y);
  Assert.IsTrue(z.IsPositive);

end;

procedure TIntegerXTest.Mult_pos_neg_is_neg();
var
  x, y, z: TIntegerX;
begin
  x := TIntegerX.Create(1, TArray<UInt32>.Create($DEFCBA98));
  y := TIntegerX.Create(-1, TArray<UInt32>.Create($12345678));
  z := x.Multiply(y);
  Assert.IsTrue(z.IsNegative);

end;

[Test]
procedure TIntegerXTest.Mult_neg_pos_is_neg();
var
  x, y, z: TIntegerX;
begin
  x := TIntegerX.Create(-1, TArray<UInt32>.Create($DEFCBA98));
  y := TIntegerX.Create(1, TArray<UInt32>.Create($12345678));
  z := x.Multiply(y);
  Assert.IsTrue(z.IsNegative);

end;

procedure TIntegerXTest.Mult_1();
var
  x, y, z: TIntegerX;
begin
  x := TIntegerX.Create(1, TArray<UInt32>.Create(100));
  y := TIntegerX.Create(1, TArray<UInt32>.Create(200));
  z := x.Multiply(y);
  Assert.IsTrue(SameValue(z, 1, TArray<UInt32>.Create(20000)));

end;

[Test]
procedure TIntegerXTest.Mult_2();
var
  x, y, z: TIntegerX;
begin
  x := TIntegerX.Create(1, TArray<UInt32>.Create($FFFFFFFF, $F0000000));
  y := TIntegerX.Create(1, TArray<UInt32>.Create($2));
  z := x.Multiply(y);
  Assert.IsTrue(SameValue(z, 1, TArray<UInt32>.Create($1, $FFFFFFFF,
    $E0000000)));

end;

[Test]
procedure TIntegerXTest.Mult_3();
var
  x, y, z: TIntegerX;
begin
  x := TIntegerX.Create(1, TArray<UInt32>.Create($FFFFFFFF, $FFFFFFFF,
    $FFFFFFFF));
  y := TIntegerX.Create(1, TArray<UInt32>.Create($1, $1));
  z := x.Multiply(y);
  Assert.IsTrue(SameValue(z, 1, TArray<UInt32>.Create($1, $0, $FFFFFFFF,
    $FFFFFFFE, $FFFFFFFF)));

end;

{$ENDREGION}
{$REGION 'Internal Tests'}

// We test some of the internals, too.
procedure TIntegerXTest.Normalize_shifts_happens_different_len();
var
  x, xn: TArray<UInt32>;
  i, rshift: Integer;
begin
  x := TArray<UInt32>.Create($8421FEC8, $FE62F731);
  SetLength(xn, 3);
  TIntegerX.Normalize(xn, 3, x, 2, 0);
  Assert.IsTrue(xn[2] = x[1]);
  Assert.IsTrue(xn[1] = x[0]);
  Assert.IsTrue(xn[0] = 0);
  i := 1;
  while i < 32 do
  begin
    rshift := 32 - i;
    TIntegerX.Normalize(xn, 3, x, 2, i);
    Assert.IsTrue(xn[2] = (x[1] shl i));
    Assert.IsTrue(xn[1] = (x[0] shl i or x[1] shr rshift));
    Assert.IsTrue(xn[0] = (x[0] shr rshift));
    Inc(i);
  end;

end;

procedure TIntegerXTest.Normalize_shifts_happens_same_len();
var
  x, xn: TArray<UInt32>;
  i, rshift: Integer;
begin
  x := TArray<UInt32>.Create($0421FEC8, $FE62F731);
  SetLength(xn, 2);

  TIntegerX.Normalize(xn, 2, x, 2, 0);
  Assert.IsTrue(xn[1] = x[1]);
  Assert.IsTrue(xn[0] = x[0]);

  i := 1;
  while i < 5 do
  begin
    rshift := 32 - i;
    TIntegerX.Normalize(xn, 2, x, 2, i);
    Assert.IsTrue(xn[1] = (x[1] shl i));
    Assert.IsTrue(xn[0] = (x[0] shl i or x[1] shr rshift));
    Inc(i);
  end;

end;

procedure TIntegerXTest.Normalize_shifts_over_left_end_throws();
var
  x, xn: TArray<UInt32>;
  lMethod: TTestLocalMethod;
begin
  x := TArray<UInt32>.Create($0421FEC8, $FE62F731);
  SetLength(xn, 2);
  lMethod := procedure
    begin
      TIntegerX.Normalize(xn, 2, x, 2, 8);
    end;
  Assert.WillRaise(lMethod, EInvalidOperationException);
end;

{$ENDREGION}
{$REGION 'Division'}

procedure TIntegerXTest.Divide_by_zero_throws();
var
  x, y: TIntegerX;
  temp: TArray<UInt32>;
  lMethod: TTestLocalMethod;
begin

  x := TIntegerX.Create(1, TArray<UInt32>.Create($FFFFFFFF));
  SetLength(temp, 0);
  y := TIntegerX.Create(0, temp);
  lMethod := procedure
    begin
      x.Divide(y);
    end;
  Assert.WillRaise(lMethod, EDivByZeroException);

end;

procedure TIntegerXTest.Divide_into_zero_is_zero();
var
  y, q, r: TIntegerX;
  temp, temp2: TArray<UInt32>;
begin
  y := TIntegerX.Create(1, TArray<UInt32>.Create($1234, $ABCD));
  SetLength(temp, 0);
  q := TIntegerX.Create(0, temp);
  SetLength(temp2, 0);
  r := TIntegerX.Create(0, temp2);
  TestDivRem(y, q, r);
end;

procedure TIntegerXTest.
  Divide_into_smaller_is_zero_plus_remainder_is_dividend();
var
  x, y, q, r: TIntegerX;
begin
  x := TIntegerX.Create(1, TArray<UInt32>.Create($12345678, $ABCDEF23,
    $88776654));
  y := TIntegerX.Create(1, TArray<UInt32>.Create($12345678, $ABCDEF23,
    $88776655));
  q := x.DivRem(y, r);
  Assert.IsTrue(r = x);
  Assert.IsTrue(q.IsZero);
end;

// This is because the code had a fall-through error due to a missing return
// statement.
procedure TIntegerXTest.
  Divide_into_smaller_is_zero_plus_remainder_is_dividend_len_difference();
var
  x, y, q, r: TIntegerX;
begin
  x := TIntegerX.Create(1, TArray<UInt32>.Create($12345678));
  y := TIntegerX.Create(1, TArray<UInt32>.Create($12345678, $ABCDEF23,
    $88776655));
  q := x.DivRem(y, r);
  Assert.IsTrue(r = x);
  Assert.IsTrue(q.IsZero);
end;

procedure TIntegerXTest.Divide_same_on_len_1();
var
  y, q, r: TIntegerX;
  temp: TArray<UInt32>;
begin
  y := TIntegerX.Create(1, TArray<UInt32>.Create($12345678));
  q := TIntegerX.Create(1, TArray<UInt32>.Create($1));
  SetLength(temp, 0);
  r := TIntegerX.Create(0, temp);

  TestDivRem(y, q, r);
end;

procedure TIntegerXTest.Divide_same_on_len_3();
var
  y, q, r: TIntegerX;
  temp: TArray<UInt32>;
begin
  y := TIntegerX.Create(1, TArray<UInt32>.Create($12345678, $ABCDEF23,
    $88776655));
  q := TIntegerX.Create(1, TArray<UInt32>.Create($1));
  SetLength(temp, 0);
  r := TIntegerX.Create(0, temp);

  TestDivRem(y, q, r);
end;

procedure TIntegerXTest.Divide_same_except_small_remainder();
var
  y, q, r: TIntegerX;
begin
  y := TIntegerX.Create(1, TArray<UInt32>.Create($12345678));
  q := TIntegerX.Create(1, TArray<UInt32>.Create($1));
  r := TIntegerX.Create(1, TArray<UInt32>.Create($45));

  TestDivRem(y, q, r);
end;

procedure TIntegerXTest.Divide_same_except_small_remainder_2();
var
  y, q, r: TIntegerX;
begin
  y := TIntegerX.Create(1, TArray<UInt32>.Create($12345678, $ABCDEF23,
    $88776655));
  q := TIntegerX.Create(1, TArray<UInt32>.Create($1));
  r := TIntegerX.Create(1, TArray<UInt32>.Create($45));

  TestDivRem(y, q, r);
end;

procedure TIntegerXTest.Divide_two_digits_with_small_remainder_no_shift();
var
  y, q, r: TIntegerX;
begin
  y := TIntegerX.Create(1, TArray<UInt32>.Create($FF000000));
  q := TIntegerX.Create(1, TArray<UInt32>.Create($1, $1, $1));
  r := TIntegerX.Create(1, TArray<UInt32>.Create($AB));

  TestDivRem(y, q, r);
end;

procedure TIntegerXTest.Divide_two_digits_with_small_remainder_no_shift2();
var
  y, q, r: TIntegerX;
begin
  y := TIntegerX.Create(1, TArray<UInt32>.Create($FF000000, $000000AA));
  q := TIntegerX.Create(1, TArray<UInt32>.Create($1, $1, $1));
  r := TIntegerX.Create(1, TArray<UInt32>.Create($AB, $45));

  TestDivRem(y, q, r);
end;

[Test]
procedure TIntegerXTest.Divide_two_digits_with_small_remainder_small_shift();
var
  y, q, r: TIntegerX;
begin
  y := TIntegerX.Create(1, TArray<UInt32>.Create($0F000000, $000000AA));
  q := TIntegerX.Create(1, TArray<UInt32>.Create($1, $1, $1));
  r := TIntegerX.Create(1, TArray<UInt32>.Create($AB, $45));

  TestDivRem(y, q, r);
end;


// THe following is taken from a suggestion in Knuth.
// In Radix t,
// (t^m - 1)*(t^n - 1) has expansion
// (t-1) ... (t-1) (t-2) (t-1) ... (t-1) 0 ... 0 1
// --------------------- --------------- --------
// m-1 places         n-m places    m-1 places
//
// if m < n
//
// Of course, (t^m -1) is (t-1)  repeated m-1 places.
//
// So, we can construct lots of cute little test samples

procedure TIntegerXTest.GenerateKnuthExample(m: Integer; n: Integer;
  out bmn: TIntegerX; out bm: TIntegerX; out bn: TIntegerX);
var
  bmnArray, bmArray, bnArray: TArray<UInt32>;
  i: Integer;
begin
  if (m >= n) then
    raise EInvalidOperationException.Create('m must be less than n');
  SetLength(bmnArray, m + n);
  SetLength(bmArray, m);
  SetLength(bnArray, n);
  i := 0;
  while i < m do
  begin
    bmArray[i] := $FFFFFFFF;
    Inc(i);
  end;

  i := 0;
  while i < n do
  begin
    bnArray[i] := $FFFFFFFF;
    Inc(i);
  end;

  i := 0;
  while i < (m - 1) do
  begin
    bmnArray[i] := $FFFFFFFF;
    Inc(i);
  end;

  bmnArray[m - 1] := $FFFFFFFE;

  i := 0;
  while i < (n - m) do
  begin
    bmnArray[m + i] := $FFFFFFFF;
    Inc(i);
  end;

  i := 0;
  while i < (m - 2) do
  begin
    bmnArray[n + i] := 0;
    Inc(i);
  end;

  bmnArray[m + n - 1] := 1;

  bmn := TIntegerX.Create(1, bmnArray);
  bm := TIntegerX.Create(1, bmArray);
  bn := TIntegerX.Create(1, bnArray);
end;

[Test]
procedure TIntegerXTest.TestKnuthExamples();
var
  bm, bn, bmn, add, q, r, x: TIntegerX;
  m, n: Integer;
begin
  m := 2;
  while m < 5 do
  begin
    n := m + 1;
    while n < (m + 5) do
    begin
      GenerateKnuthExample(m, n, bmn, bm, bn);

      add := bm - TIntegerX.Create(1, TArray<UInt32>.Create($ABCD));
      x := bmn + add;
      q := x.DivRem(bm, r);
      Assert.IsTrue(r = add);
      Assert.IsTrue(q = bn);
      Inc(n);
    end;

    Inc(m);
  end;

end;

procedure TIntegerXTest.TestDivRem(y: TIntegerX; mult: TIntegerX;
  add: TIntegerX);
var
  x, q, r: TIntegerX;
begin
  x := y * mult + add;
  q := x.DivRem(y, r);

  Assert.IsTrue(q = mult);
  Assert.IsTrue(r = add);
end;

{$ENDREGION}
{$REGION 'Power, ModPower tests'}

procedure TIntegerXTest.Power_on_negative_exponent_fails();
var
  i: TIntegerX;
  lMethod: TTestLocalMethod;
begin
  i := TIntegerX.Create(1, [$1]);
  lMethod := procedure
    begin
      i.Power(-2);
    end;
  Assert.WillRaise(lMethod, EArgumentOutOfRangeException);
end;

procedure TIntegerXTest.Power_with_exponent_0_is_one();
var
  i: TIntegerX;
begin
  i := TIntegerX.Create(1, [$1]);
  Assert.IsTrue(SameValue(i.Power(0), 1, TArray<UInt32>.Create(1)));
end;

procedure TIntegerXTest.Power_on_zero_is_zero();
var
  z: TIntegerX;
begin
  z := TIntegerX.Create(0);
  Assert.IsTrue(z.Power(12).IsZero);
end;

procedure TIntegerXTest.Power_on_small_exponent_works();
var
  i, p, e: TIntegerX;
begin
  i := TIntegerX.Create(3);
  p := i.Power(6);
  e := TIntegerX.Create(729);
  Assert.IsTrue(p = e);
end;

procedure TIntegerXTest.Power_on_completely_odd_exponent_works();
var
  i, p, p2_to_255: TIntegerX;
begin
  i := TIntegerX.Create(1, [$2]);
  p := i.Power(255);
  p2_to_255 := TIntegerX.Create(1, [$80000000, $0, $0, $0, $0, $0, $0, $0]);
  Assert.IsTrue(p = p2_to_255);
end;

procedure TIntegerXTest.Power_on_power_of_two_exponent_works();
var
  i, p, p2_to_256: TIntegerX;
begin
  i := TIntegerX.Create(1, [$2]);
  p := i.Power(256);
  p2_to_256 := TIntegerX.Create(1, [$1, $0, $0, $0, $0, $0, $0, $0, $0]);
  Assert.IsTrue(p = p2_to_256);
end;

procedure TIntegerXTest.ModPow_on_negative_exponent_fails();
var
  i, m: TIntegerX;
  lMethod: TTestLocalMethod;
begin
  i := TIntegerX.Create(1, [$1]);
  m := TIntegerX.Create(1, [$1]);
  lMethod := procedure
    begin
      i.ModPow(-2, m);
    end;
  Assert.WillRaise(lMethod, EArgumentOutOfRangeException);
end;

procedure TIntegerXTest.ModPow_with_exponent_0_is_one();
var
  i, m: TIntegerX;
begin
  i := TIntegerX.Create(1, [$1]);
  m := TIntegerX.Create(1, [$1]);
  Assert.IsTrue(SameValue(i.ModPow(0, m), 1, TArray<UInt32>.Create(1)));
end;

procedure TIntegerXTest.ModPow_on_zero_is_zero();
var
  z, m: TIntegerX;
begin
  z := TIntegerX.Create(0);
  m := TIntegerX.Create(1, [$1]);
  Assert.IsTrue(z.ModPow(12, m).IsZero);
end;

procedure TIntegerXTest.ModPow_on_small_exponent_works();
var
  i, m, e, p, a: TIntegerX;
begin
  i := TIntegerX.Create(3);
  m := TIntegerX.Create(100);
  e := TIntegerX.Create(6);
  p := i.ModPow(e, m);
  a := TIntegerX.Create(29);
  Assert.IsTrue(p = a);
end;

procedure TIntegerXTest.ModPow_on_completely_odd_exponent_works();
var
  i, m, e, p, a: TIntegerX;
begin
  i := TIntegerX.Create(1, [$2]);
  m := TIntegerX.Create(1, [$7]);
  e := TIntegerX.Create(255);
  p := i.ModPow(e, m);
  a := TIntegerX.Create(1, [$1]);
  Assert.IsTrue(p = a);
end;

procedure TIntegerXTest.ModPow_on_power_of_two_exponent_works();
var
  i, m, e, p, a: TIntegerX;
begin
  i := TIntegerX.Create(1, [$2]);
  m := TIntegerX.Create(1, [$7]);
  e := TIntegerX.Create(256);
  p := i.ModPow(e, m);
  a := TIntegerX.Create(1, [$2]);
  Assert.IsTrue(p = a);
end;

{$ENDREGION}
{$REGION 'misc tests'}

[Test]
procedure TIntegerXTest.IsOddWorks();
var
  x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13: TIntegerX;
begin
  x1 := TIntegerX.Create(0, TArray<UInt32>.Create($0));
  x2 := TIntegerX.Create(1, TArray<UInt32>.Create($1));
  x3 := TIntegerX.Create(-1, TArray<UInt32>.Create($1));
  x4 := TIntegerX.Create(1, TArray<UInt32>.Create($2));
  x5 := TIntegerX.Create(-1, TArray<UInt32>.Create($2));
  x6 := TIntegerX.Create(1, TArray<UInt32>.Create($FFFFFFF0));
  x7 := TIntegerX.Create(-1, TArray<UInt32>.Create($FFFFFFF0));
  x8 := TIntegerX.Create(1, TArray<UInt32>.Create($FFFFFFF1));
  x9 := TIntegerX.Create(-1, TArray<UInt32>.Create($FFFFFFF1));
  x10 := TIntegerX.Create(1, TArray<UInt32>.Create($1, $2));
  x11 := TIntegerX.Create(1, TArray<UInt32>.Create($2, $1));
  x12 := TIntegerX.Create(1, TArray<UInt32>.Create($2, $2));
  x13 := TIntegerX.Create(1, TArray<UInt32>.Create($1, $1));

  Assert.IsTrue(x1.IsOdd = False);
  Assert.IsTrue(x2.IsOdd);
  Assert.IsTrue(x3.IsOdd);
  Assert.IsTrue(x4.IsOdd = False);
  Assert.IsTrue(x5.IsOdd = False);
  Assert.IsTrue(x6.IsOdd = False);
  Assert.IsTrue(x7.IsOdd = False);
  Assert.IsTrue(x8.IsOdd);
  Assert.IsTrue(x9.IsOdd);
  Assert.IsTrue(x10.IsOdd = False);
  Assert.IsTrue(x11.IsOdd);
  Assert.IsTrue(x12.IsOdd = False);
  Assert.IsTrue(x13.IsOdd);
end;

{$ENDREGION}
{$REGION 'GCD tests'}

procedure TIntegerXTest.GCD_simple_case();
var
  primes, apowers, bpowers: TArray<Integer>;
begin
  primes := TArray<Integer>.Create(2, 3);
  apowers := TArray<Integer>.Create(2, 5);
  bpowers := TArray<Integer>.Create(4, 3);

  TestGCD(primes, true, apowers, true, bpowers);
end;

procedure TIntegerXTest.GCD_test_signs();
var
  primes, apowers, bpowers: TArray<Integer>;
begin
  primes := TArray<Integer>.Create(2, 3, 5, 17, 73);
  apowers := TArray<Integer>.Create(50, 10, 12, 4, 0);
  bpowers := TArray<Integer>.Create(40, 20, 6, 0, 5);
  TestGCD(primes, true, apowers, true, bpowers);
  TestGCD(primes, true, apowers, False, bpowers);
  TestGCD(primes, False, apowers, true, bpowers);
  TestGCD(primes, False, apowers, False, bpowers);
end;

procedure TIntegerXTest.GCD_test_disparity_in_size();
var
  primes, apowers, bpowers: TArray<Integer>;
begin
  primes := TArray<Integer>.Create(2, 3, 5, 17, 73);
  apowers := TArray<Integer>.Create(50, 100, 120, 4, 0);
  bpowers := TArray<Integer>.Create(5, 20, 6, 30, 5);
  TestGCD(primes, true, apowers, true, bpowers);
end;

procedure TIntegerXTest.GCD_test_many_powers_of_two();
var
  primes, apowers, bpowers: TArray<Integer>;
begin
  primes := TArray<Integer>.Create(2, 3, 5, 17, 73);
  apowers := TArray<Integer>.Create(500, 100, 120, 4, 0);
  bpowers := TArray<Integer>.Create(499, 20, 6, 30, 5);
  TestGCD(primes, true, apowers, true, bpowers);
end;

procedure TIntegerXTest.GCD_test_relatively_prime();
var
  primes, apowers, bpowers: TArray<Integer>;
begin
  primes := TArray<Integer>.Create(2, 3, 5, 17, 73);
  apowers := TArray<Integer>.Create(500, 0, 120, 0, 0);
  bpowers := TArray<Integer>.Create(0, 120, 0, 130, 5);
  TestGCD(primes, true, apowers, true, bpowers);
end;

procedure TIntegerXTest.GCD_test_multiple();
var
  primes, apowers, bpowers: TArray<Integer>;
begin
  primes := TArray<Integer>.Create(2, 3, 5, 17, 73);
  apowers := TArray<Integer>.Create(500, 50, 120, 10, 12);
  bpowers := TArray<Integer>.Create(0, 30, 20, 10, 10);
  TestGCD(primes, true, apowers, true, bpowers);
end;

procedure TIntegerXTest.TestGCD(primes: TArray<Integer>; apos: Boolean;
  apowers: TArray<Integer>; bpos: Boolean; bpowers: TArray<Integer>);
var
  a, b, c, g: TIntegerX;
begin
  a := CreateFromPrimePowers(primes, apowers);
  if (not apos) then
    a := a.Negate();

  b := CreateFromPrimePowers(primes, bpowers);
  if (not bpos) then
    b := b.Negate();

  c := CreateFromPrimePowers(primes, MinPowers(apowers, bpowers));
  g := a.Gcd(b);
  Assert.IsTrue(g = c);
end;

function TIntegerXTest.CreateFromPrimePowers(primes: TArray<Integer>;
  powers: TArray<Integer>): TIntegerX;
var
  a: TIntegerX;
  i: Integer;
begin
  a := TIntegerX.One;
  i := 0;
  while i < Length(primes) do
  begin
    if (powers[i] > 0) then
    begin
      a := a * TIntegerX.Create(primes[i]).Power(powers[i]);
    end;
    Inc(i);
  end;
  result := a;

end;

function TIntegerXTest.MinPowers(apowers: TArray<Integer>;
  bpowers: TArray<Integer>): TArray<Integer>;
var
  mins: TArray<Integer>;
  i: Integer;
begin
  SetLength(mins, Length(apowers));
  i := 0;
  while i < Length(apowers) do
  begin
    mins[i] := Math.Min(apowers[i], bpowers[i]);
    Inc(i);
  end;
  result := mins;
end;

{$ENDREGION}
{$REGION 'Bitwise operation tests -- Boolean ops'}

procedure TIntegerXTest.BitAnd_pos_pos();
var
  digit1, digit2, d0, d1, d2: UInt32;
  x, y, z, w: TIntegerX;
begin
  digit1 := $ACACACAC;
  digit2 := $CACACACA;

  x := TIntegerX.Create(1, TArray<UInt32>.Create(digit1, digit2,
    digit1, digit2));
  y := TIntegerX.Create(1, TArray<UInt32>.Create(digit1, digit2, 0));

  d0 := digit2 and digit1;
  d1 := digit1 and digit2;
  d2 := 0;

  z := TIntegerX.Create(1, TArray<UInt32>.Create(d0, d1, d2));
  // TIntegerX z = TIntegerX.Create(1, TArray<UInt32>.Create(digit2 & digit1, digit1 & digit2, 0 });
  w := x and y;

  Assert.IsTrue(w = z);
end;

procedure TIntegerXTest.BitAnd_pos_neg();
var
  digit1, digit2, d0, d1, d2, d3: UInt32;
  x, y, z, w: TIntegerX;
begin
  digit1 := $ACACACAC;
  digit2 := $CACACACA;

  x := TIntegerX.Create(1, TArray<UInt32>.Create(digit1, digit2,
    digit1, digit2));
  y := TIntegerX.Create(-1, TArray<UInt32>.Create(digit1, digit2, 0));

  d0 := digit1;
  d1 := digit2 and (not digit1);
  d2 := digit1 and (not(digit2) + 1);
  d3 := 0;

  z := TIntegerX.Create(1, TArray<UInt32>.Create(d0, d1, d2, d3));
  // TIntegerX z = TIntegerX.Create(1, TArray<UInt32>.Create(digit1, digit2 & ~digit1, digit1 & (~digit2 + 1), 0 });
  w := x and y;

  Assert.IsTrue(w = z);
end;

procedure TIntegerXTest.BitAnd_neg_pos();
var
  digit1, digit2, d0, d1, d2: UInt32;
  x, y, z, w: TIntegerX;
begin
  digit1 := $ACACACAC;
  digit2 := $CACACACA;

  x := TIntegerX.Create(-1, TArray<UInt32>.Create(digit1, digit2,
    digit1, digit2));
  y := TIntegerX.Create(1, TArray<UInt32>.Create(digit1, digit2, 0));

  d0 := (not digit2) and digit1;
  d1 := (not digit1) and digit2;
  d2 := 0;

  z := TIntegerX.Create(1, TArray<UInt32>.Create(d0, d1, d2));
  // TIntegerX z = TIntegerX.Create(1, TArray<UInt32>.Create(~digit2 & digit1, ~digit1 & digit2, 0 });
  w := x and y;

  Assert.IsTrue(w = z);
end;

procedure TIntegerXTest.BitAnd_neg_neg();
var
  digit1, digit2, d0, d1, d2, d3: UInt32;
  x, y, z, w: TIntegerX;
begin
  digit1 := $ACACACAC;
  digit2 := $CACACACA;

  x := TIntegerX.Create(-1, TArray<UInt32>.Create(digit1, digit2,
    digit1, digit2));
  y := TIntegerX.Create(-1, TArray<UInt32>.Create(digit1, digit2, 0));

  d0 := digit1;
  d1 := not((not digit2) and (not digit1));
  d2 := not((not digit1) and ((not digit2) + 1)) + 1;
  d3 := 0;

  z := TIntegerX.Create(-1, TArray<UInt32>.Create(d0, d1, d2, d3));
  w := x and y;

  Assert.IsTrue(w = z);
end;

procedure TIntegerXTest.BitOr_pos_pos();
var
  digit1, digit2, d0, d1, d2, d3: UInt32;
  x, y, z, w: TIntegerX;
begin
  digit1 := $ACACACAC;
  digit2 := $CACACACA;

  x := TIntegerX.Create(1, TArray<UInt32>.Create(digit1, digit2,
    digit1, digit2));
  y := TIntegerX.Create(1, TArray<UInt32>.Create(digit1, digit2, 0));

  d0 := digit1;
  d1 := digit2 or digit1;
  d2 := digit1 or digit2;
  d3 := digit2;

  z := TIntegerX.Create(1, TArray<UInt32>.Create(d0, d1, d2, d3));
  w := x or y;

  Assert.IsTrue(w = z);
end;

procedure TIntegerXTest.BitOr_pos_neg();
var
  digit1, digit2, d0, d1, d2: UInt32;
  x, y, z, w: TIntegerX;
begin
  digit1 := $ACACACAC;
  digit2 := $CACACACA;

  x := TIntegerX.Create(1, TArray<UInt32>.Create(digit1, digit2,
    digit1, digit2));
  y := TIntegerX.Create(-1, TArray<UInt32>.Create(digit1, digit2, 0));

  d0 := not(digit2 or (not digit1));
  d1 := not(digit1 or ((not digit2) + 1));
  d2 := (not digit2) + 1;

  z := TIntegerX.Create(-1, TArray<UInt32>.Create(d0, d1, d2));
  w := x or y;

  Assert.IsTrue(w = z);
end;

procedure TIntegerXTest.BitOr_neg_pos();
var
  digit1, digit2, d0, d1, d2, d3: UInt32;
  x, y, z, w: TIntegerX;
begin
  digit1 := $ACACACAC;
  digit2 := $CACACACA;

  x := TIntegerX.Create(-1, TArray<UInt32>.Create(digit1, digit2,
    digit1, digit2));
  y := TIntegerX.Create(1, TArray<UInt32>.Create(digit1, digit2, 0));

  d0 := digit1;
  d1 := not((not digit2) or digit1);
  d2 := not((not digit1) or digit2);
  d3 := not((not digit2) + 1) + 1;

  z := TIntegerX.Create(-1, TArray<UInt32>.Create(d0, d1, d2, d3));
  w := x or y;

  Assert.IsTrue(w = z);
end;

procedure TIntegerXTest.BitOr_neg_neg();
var
  digit1, digit2, d0, d1, d2: UInt32;
  x, y, z, w: TIntegerX;
begin
  digit1 := $ACACACAC;
  digit2 := $CACACACA;

  x := TIntegerX.Create(-1, TArray<UInt32>.Create(digit1, digit2,
    digit1, digit2));
  y := TIntegerX.Create(-1, TArray<UInt32>.Create(digit1, digit2, 0));

  d0 := not((not digit2) or (not digit1));
  d1 := not((not digit1) or (not digit2));
  d2 := not((not digit2) + 1) + 1;

  z := TIntegerX.Create(-1, TArray<UInt32>.Create(d0, d1, d2));
  w := x or y;

  Assert.IsTrue(w = z);
end;

procedure TIntegerXTest.BitXor_pos_pos();
var
  digit1, digit2, d0, d1, d2, d3: UInt32;
  x, y, z, w: TIntegerX;
begin
  digit1 := $ACACACAC;
  digit2 := $CACACACA;

  x := TIntegerX.Create(1, TArray<UInt32>.Create(digit1, digit2,
    digit1, digit2));
  y := TIntegerX.Create(1, TArray<UInt32>.Create(digit1, digit2, 0));

  d0 := not(digit1 xor $0);
  d1 := not(digit2 xor digit1);
  d2 := not(digit1 xor digit2);
  d3 := not(digit2 xor $0) + 1;

  z := TIntegerX.Create(-1, TArray<UInt32>.Create(d0, d1, d2, d3));
  w := x xor y;

  Assert.IsTrue(w = z);
end;

procedure TIntegerXTest.BitXor_pos_neg();
var
  digit1, digit2, d0, d1, d2, d3: UInt32;
  x, y, z, w: TIntegerX;
begin
  digit1 := $ACACACAC;
  digit2 := $CACACACA;

  x := TIntegerX.Create(1, TArray<UInt32>.Create(digit1, digit2,
    digit1, digit2));
  y := TIntegerX.Create(-1, TArray<UInt32>.Create(digit1, digit2, 0));

  d0 := digit1 xor (not UInt32($0));
  d1 := digit2 xor (not digit1);
  d2 := digit1 xor ((not digit2) + 1);
  d3 := digit2 xor $0;

  z := TIntegerX.Create(1, TArray<UInt32>.Create(d0, d1, d2, d3));
  w := x xor y;

  Assert.IsTrue(w = z);
end;

procedure TIntegerXTest.BitXor_neg_pos();
var
  digit1, digit2, d0, d1, d2, d3: UInt32;
  x, y, z, w: TIntegerX;
begin
  digit1 := $ACACACAC;
  digit2 := $CACACACA;

  x := TIntegerX.Create(-1, TArray<UInt32>.Create(digit1, digit2,
    digit1, digit2));
  y := TIntegerX.Create(1, TArray<UInt32>.Create(digit1, digit2, 0));

  d0 := (not digit1) xor $0;
  d1 := (not digit2) xor digit1;
  d2 := (not digit1) xor digit2;
  d3 := ((not digit2) + 1) xor UInt32($0);

  z := TIntegerX.Create(1, TArray<UInt32>.Create(d0, d1, d2, d3));
  w := x xor y;

  Assert.IsTrue(w = z);
end;

procedure TIntegerXTest.BitXor_neg_neg();
var
  digit1, digit2, d0, d1, d2, d3: UInt32;
  x, y, z, w: TIntegerX;
begin
  digit1 := $ACACACAC;
  digit2 := $CACACACA;

  x := TIntegerX.Create(-1, TArray<UInt32>.Create(digit1, digit2,
    digit1, digit2));
  y := TIntegerX.Create(-1, TArray<UInt32>.Create(digit1, digit2, 0));

  d0 := not((not digit1) xor (not UInt32($0)));
  d1 := not((not digit2) xor (not digit1));
  d2 := not((not digit1) xor ((not digit2) + 1));
  d3 := not(((not digit2) + 1) xor $0) + 1;

  z := TIntegerX.Create(-1, TArray<UInt32>.Create(d0, d1, d2, d3));
  w := x xor y;

  Assert.IsTrue(w = z);
end;

procedure TIntegerXTest.BitAndNot_pos_pos();
var
  digit1, digit2, d0, d1, d2, d3: UInt32;
  x, y, z, w: TIntegerX;
begin
  digit1 := $ACACACAC;
  digit2 := $CACACACA;

  x := TIntegerX.Create(1, TArray<UInt32>.Create(digit1, digit2,
    digit1, digit2));
  y := TIntegerX.Create(1, TArray<UInt32>.Create(digit1, digit2, 0));

  d0 := digit1;
  d1 := digit2 and (not digit1);
  d2 := digit1 and (not digit2);
  d3 := digit2;

  z := TIntegerX.Create(1, TArray<UInt32>.Create(d0, d1, d2, d3));
  w := x.BitwiseAndNot(y);

  Assert.IsTrue(w = z);
end;

procedure TIntegerXTest.BitAndNot_pos_neg();
var
  digit1, digit2, d0, d1, d2: UInt32;
  x, y, z, w: TIntegerX;
begin
  digit1 := $ACACACAC;
  digit2 := $CACACACA;

  x := TIntegerX.Create(1, TArray<UInt32>.Create(digit1, digit2,
    digit1, digit2));
  y := TIntegerX.Create(-1, TArray<UInt32>.Create(digit1, digit2, 0));

  d0 := digit2 and digit1;
  d1 := digit1 and (not((not digit2) + 1));
  d2 := digit2;

  z := TIntegerX.Create(1, TArray<UInt32>.Create(d0, d1, d2));
  w := x.BitwiseAndNot(y);

  Assert.IsTrue(w = z);
end;

procedure TIntegerXTest.BitAndNot_neg_pos();
var
  digit1, digit2, d0, d1, d2, d3: UInt32;
  x, y, z, w: TIntegerX;
begin
  digit1 := $ACACACAC;
  digit2 := $CACACACA;

  x := TIntegerX.Create(-1, TArray<UInt32>.Create(digit1, digit2,
    digit1, digit2));
  y := TIntegerX.Create(1, TArray<UInt32>.Create(digit1, digit2, 0));

  d0 := digit1;
  d1 := digit2 or digit1;
  d2 := digit1 or digit2;
  d3 := digit2;

  z := TIntegerX.Create(-1, TArray<UInt32>.Create(d0, d1, d2, d3));
  w := x.BitwiseAndNot(y);

  Assert.IsTrue(w = z);
end;

procedure TIntegerXTest.BitAndNot_neg_neg();
var
  digit1, digit2, d0, d1, d2: UInt32;
  x, y, z, w: TIntegerX;
begin
  digit1 := $ACACACAC;
  digit2 := $CACACACA;

  x := TIntegerX.Create(-1, TArray<UInt32>.Create(digit1, digit2,
    digit1, digit2));
  y := TIntegerX.Create(-1, TArray<UInt32>.Create(digit1, digit2, 0));

  d0 := (not digit2) and digit1;
  d1 := (not digit1) and (not((not digit2) + 1));
  d2 := (not digit2) + 1;

  z := TIntegerX.Create(1, TArray<UInt32>.Create(d0, d1, d2));
  w := x.BitwiseAndNot(y);

  Assert.IsTrue(w = z);
end;

procedure TIntegerXTest.BitNot_pos();
var
  digit1, digit2, d0, d1, d2: UInt32;
  x, z, w: TIntegerX;
begin
  digit1 := $ACACACAC;
  digit2 := $CACACACA;

  x := TIntegerX.Create(1, TArray<UInt32>.Create(digit1, digit2, 0));

  d0 := digit1;
  d1 := digit2;
  d2 := 1;

  z := TIntegerX.Create(-1, TArray<UInt32>.Create(d0, d1, d2));
  w := x.OnesComplement();

  Assert.IsTrue(w = z);
end;

procedure TIntegerXTest.BitNot_neg();
var
  digit1, digit2, d0, d1, d2: UInt32;
  x, z, w: TIntegerX;
begin
  digit1 := $ACACACAC;
  digit2 := $CACACACA;

  x := TIntegerX.Create(-1, TArray<UInt32>.Create(digit1, digit2, 0));

  d0 := digit1;
  d1 := not((not digit2) + 1);
  d2 := $FFFFFFFF;

  z := TIntegerX.Create(1, TArray<UInt32>.Create(d0, d1, d2));
  w := x.OnesComplement();

  Assert.IsTrue(w = z);
end;

{$ENDREGION}
{$REGION 'Bitwise operation tests -- single bit'}

procedure TIntegerXTest.TestBit_pos_inside();
var
  x: TIntegerX;
  i: Integer;
begin
  x := TIntegerX.Create(1, [$AAAAAAAA, $AAAAAAAA]);
  i := 0;
  while i < 64 do
  begin
    Assert.IsTrue(x.TestBit(i) = (i mod 2 <> 0));
    Inc(i);
  end;
end;

procedure TIntegerXTest.TestBit_neg_inside();
var
  x: TIntegerX;
  i: Integer;
begin
  x := TIntegerX.Create(-1, [$AAAAAAAA, $AAAAAAAA]);

  Assert.IsTrue(x.TestBit(0) = False);
  Assert.IsTrue(x.TestBit(1) = true);
  i := 2;
  while i < 64 do
  begin
    Assert.IsTrue(x.TestBit(i) = (i mod 2 = 0));
    Inc(i);
  end;
end;

procedure TIntegerXTest.TestBit_pos_outside();
var
  x: TIntegerX;
begin
  x := TIntegerX.Create(1, [$AAAAAAAA, $AAAAAAAA]);
  Assert.IsTrue(x.TestBit(1000) = False);
end;

procedure TIntegerXTest.TestBit_neg_outside();
var
  x: TIntegerX;
begin
  x := TIntegerX.Create(-1, [$AAAAAAAA, $AAAAAAAA]);
  Assert.IsTrue(x.TestBit(1000));
end;

procedure TIntegerXTest.SetBit_pos_inside_initial_set();
var
  x, y: TIntegerX;
begin
  x := TIntegerX.Create(1, [$FFFF0000, $FFFF0000]);
  y := x.SetBit(56);
  Assert.IsTrue(y = x);
end;

procedure TIntegerXTest.SetBit_pos_inside_initial_clear();
var
  x, w, y: TIntegerX;
begin
  x := TIntegerX.Create(1, [$FFFF0000, $FFFF0000]);
  w := TIntegerX.Create(1, [$FFFF0080, $FFFF0000]);
  y := x.SetBit(39);
  Assert.IsTrue(y = w);
end;

procedure TIntegerXTest.SetBit_pos_outside();
var
  x, y: TIntegerX;
begin
  x := TIntegerX.Create(1, [$FFFF0000, $FFFF0000]);
  y := x.SetBit(99);
  Assert.IsTrue(SameValue(y, 1, TArray<UInt32>.Create(8, 0, $FFFF0000,
    $FFFF0000)));
end;

procedure TIntegerXTest.SetBit_neg_inside_initial_set();
var
  x, y: TIntegerX;
begin
  x := TIntegerX.Create(-1, [$FFFF0000, $FFFF0000]);
  y := x.SetBit(39);
  Assert.IsTrue(y = x);
end;

procedure TIntegerXTest.SetBit_neg_inside_initial_clear();
var
  x, w, y: TIntegerX;
begin
  x := TIntegerX.Create(-1, [$FFFF0000, $FFFF0000]);
  w := TIntegerX.Create(-1, [$FEFF0000, $FFFF0000]);
  y := x.SetBit(56);
  Assert.IsTrue(y = w);
end;

procedure TIntegerXTest.SetBit_neg_outside();
var
  x, y: TIntegerX;
begin
  x := TIntegerX.Create(-1, [$FFFF0000, $FFFF0000]);
  y := x.SetBit(99);
  Assert.IsTrue(SameValue(y, -1, TArray<UInt32>.Create($FFFF0000, $FFFF0000)));
end;

procedure TIntegerXTest.ClearBit_pos_inside_initial_set();
var
  x, w, y: TIntegerX;
begin
  x := TIntegerX.Create(1, [$FFFF0000, $FFFF0000]);
  w := TIntegerX.Create(1, [$FEFF0000, $FFFF0000]);
  y := x.ClearBit(56);
  Assert.IsTrue(y = w);
end;

procedure TIntegerXTest.ClearBit_pos_inside_initial_clear();
var
  x, y: TIntegerX;
begin
  x := TIntegerX.Create(1, [$FFFF0000, $FFFF0000]);
  y := x.ClearBit(39);
  Assert.IsTrue(y = x);
end;

procedure TIntegerXTest.ClearBit_pos_outside();
var
  x, y: TIntegerX;
begin
  x := TIntegerX.Create(1, [$FFFF0000, $FFFF0000]);
  y := x.ClearBit(99);
  Assert.IsTrue(y = x);
end;

procedure TIntegerXTest.ClearBit_neg_inside_initial_set();
var
  x, y: TIntegerX;
begin
  x := TIntegerX.Create(-1, [$FFFF0000, $FFFF0000]);
  y := x.ClearBit(39);
  Assert.IsTrue(SameValue(y, -1, TArray<UInt32>.Create($FFFF0080, $FFFF0000)));
end;

procedure TIntegerXTest.ClearBit_neg_inside_initial_clear();
var
  x, y: TIntegerX;
begin
  x := TIntegerX.Create(-1, [$FFFF0000, $FFFF0000]);
  y := x.ClearBit(56);
  Assert.IsTrue(y = x);
end;

procedure TIntegerXTest.ClearBit_neg_outside();
var
  x, y: TIntegerX;
begin
  x := TIntegerX.Create(-1, [$FFFF0000, $FFFF0000]);
  y := x.ClearBit(99);
  Assert.IsTrue(SameValue(y, -1, TArray<UInt32>.Create(8, 0, $FFFF0000,
    $FFFF0000)));
end;

procedure TIntegerXTest.FlipBit_pos_inside_initial_set();
var
  x, w, y: TIntegerX;
begin
  x := TIntegerX.Create(1, [$FFFF0000, $FFFF0000]);
  w := TIntegerX.Create(1, [$FEFF0000, $FFFF0000]);
  y := x.FlipBit(56);
  Assert.IsTrue(y = w);
end;

procedure TIntegerXTest.FlipBit_pos_inside_initial_clear();
var
  x, w, y: TIntegerX;
begin
  x := TIntegerX.Create(1, [$FFFF0000, $FFFF0000]);
  w := TIntegerX.Create(1, [$FFFF0080, $FFFF0000]);
  y := x.FlipBit(39);
  Assert.IsTrue(y = w);
end;

procedure TIntegerXTest.FlipBit_pos_outside();
var
  x, y: TIntegerX;
begin
  x := TIntegerX.Create(1, [$FFFF0000, $FFFF0000]);
  y := x.FlipBit(99);
  Assert.IsTrue(SameValue(y, 1, TArray<UInt32>.Create(8, 0, $FFFF0000,
    $FFFF0000)));
end;

procedure TIntegerXTest.FlipBit_neg_inside_initial_set();
var
  x, w, y: TIntegerX;
begin
  x := TIntegerX.Create(-1, [$FFFF0000, $FFFF0000]);
  w := TIntegerX.Create(-1, [$FFFF0080, $FFFF0000]);
  y := x.FlipBit(39);
  Assert.IsTrue(y = w);
end;

procedure TIntegerXTest.FlipBit_neg_inside_initial_clear();
var
  x, w, y: TIntegerX;
begin
  x := TIntegerX.Create(-1, [$FFFF0000, $FFFF0000]);
  w := TIntegerX.Create(-1, [$FEFF0000, $FFFF0000]);
  y := x.FlipBit(56);
  Assert.IsTrue(y = w);
end;

procedure TIntegerXTest.FlipBit_neg_outside();
var
  x, y: TIntegerX;
begin
  x := TIntegerX.Create(-1, [$FFFF0000, $FFFF0000]);
  y := x.FlipBit(99);
  Assert.IsTrue(SameValue(y, -1, TArray<UInt32>.Create(8, 0, $FFFF0000,
    $FFFF0000)));
end;

{$ENDREGION}
{$REGION 'Bitwise operation tests -- shifts'}

procedure TIntegerXTest.LeftShift_zero_is_zero();
var
  x, y: TIntegerX;
begin
  x := TIntegerX.Create(0);
  y := x.LeftShift(1000);
  Assert.IsTrue(y.IsZero);
end;

procedure TIntegerXTest.LeftShift_neg_shift_same_as_right_shift();
var
  x, y, z: TIntegerX;
  digit1, digit2, digit3: UInt32;
begin
  digit1 := $C1F0F1CD;
  digit2 := $B38F4F83;
  digit3 := $1234678;
  x := TIntegerX.Create(1, [digit1, digit2, digit3]);
  y := x.LeftShift(-40);
  z := x.RightShift(40);
  Assert.IsTrue(y = z);
end;

procedure TIntegerXTest.LeftShift_zero_shift_is_this();
var
  x, y: TIntegerX;
  digit1, digit2, digit3: UInt32;
begin
  digit1 := $C1F0F1CD;
  digit2 := $B38F4F83;
  digit3 := $1234678;
  x := TIntegerX.Create(1, [digit1, digit2, digit3]);
  y := x.LeftShift(0);
  Assert.IsTrue(y = x);
end;

procedure TIntegerXTest.LeftShift_pos_whole_digit_shift_adds_zeros_at_end();
var
  x, y, w: TIntegerX;
  digit1, digit2, digit3: UInt32;
begin
  digit1 := $C1F0F1CD;
  digit2 := $B38F4F83;
  digit3 := $1234678;
  x := TIntegerX.Create(1, [digit1, digit2, digit3]);
  y := x.LeftShift(64);
  w := TIntegerX.Create(1, [digit1, digit2, digit3, 0, 0]);
  Assert.IsTrue(y = w);
end;

procedure TIntegerXTest.LeftShift_pos_small_shift();
var
  x, y, w: TIntegerX;
  digit1, digit2, digit3: UInt32;
begin
  digit1 := $C1F0F1CD;
  digit2 := $B38F4F83;
  digit3 := $1234678;
  x := TIntegerX.Create(1, [digit1, digit2, digit3]);
  y := x.LeftShift(7);
  w := TIntegerX.Create(1, [digit1 shr 25, ((digit1 shl 7) or (digit2 shr 25)),
    ((digit2 shl 7) or (digit3 shr 25)), (digit3 shl 7)]);
  Assert.IsTrue(y = w);
end;

procedure TIntegerXTest.LeftShift_neg_small_shift();
var
  x, y, w: TIntegerX;
  digit1, digit2, digit3: UInt32;
begin
  digit1 := $C1F0F1CD;
  digit2 := $B38F4F83;
  digit3 := $1234678;
  x := TIntegerX.Create(-1, [digit1, digit2, digit3]);
  y := x.LeftShift(7);
  w := TIntegerX.Create(-1, [digit1 shr 25, ((digit1 shl 7) or (digit2 shr 25)),
    ((digit2 shl 7) or (digit3 shr 25)), (digit3 shl 7)]);
  Assert.IsTrue(y = w);
end;

procedure TIntegerXTest.LeftShift_pos_big_shift();
var
  x, y, w: TIntegerX;
  digit1, digit2, digit3: UInt32;
begin
  digit1 := $C1F0F1CD;
  digit2 := $B38F4F83;
  digit3 := $1234678;
  x := TIntegerX.Create(1, [digit1, digit2, digit3]);
  y := x.LeftShift(7 + 64);
  w := TIntegerX.Create(1, [digit1 shr 25, ((digit1 shl 7) or (digit2 shr 25)),
    ((digit2 shl 7) or (digit3 shr 25)), (digit3 shl 7), 0, 0]);
  Assert.IsTrue(y = w);
end;

procedure TIntegerXTest.LeftShift_neg_big_shift();
var
  x, y, w: TIntegerX;
  digit1, digit2, digit3: UInt32;
begin
  digit1 := $C1F0F1CD;
  digit2 := $B38F4F83;
  digit3 := $1234678;
  x := TIntegerX.Create(-1, [digit1, digit2, digit3]);
  y := x.LeftShift(7 + 64);
  w := TIntegerX.Create(-1, [digit1 shr 25, ((digit1 shl 7) or (digit2 shr 25)),
    ((digit2 shl 7) or (digit3 shr 25)), (digit3 shl 7), 0, 0]);
  Assert.IsTrue(y = w);
end;

procedure TIntegerXTest.LeftShift_pos_big_shift_zero_high_bits();
var
  x, y, w: TIntegerX;
  digit1, digit2, digit3: UInt32;
begin
  digit1 := $0000F1CD;
  digit2 := $B38F4F83;
  digit3 := $1234678;
  x := TIntegerX.Create(1, [digit1, digit2, digit3]);
  y := x.LeftShift(7 + 64);
  w := TIntegerX.Create(1, [digit1 shr 25, ((digit1 shl 7) or (digit2 shr 25)),
    ((digit2 shl 7) or (digit3 shr 25)), (digit3 shl 7), 0, 0]);
  Assert.IsTrue(y = w);
end;

procedure TIntegerXTest.RightShift_zero_is_zero();
var
  x, y: TIntegerX;
begin
  x := TIntegerX.Create(0);
  y := x.RightShift(1000);
  Assert.IsTrue(y.IsZero);
end;

procedure TIntegerXTest.RightShift_neg_shift_same_as_left_shift();
var
  digit1, digit2, digit3: UInt32;
  x, y, z: TIntegerX;
begin
  digit1 := $C1F0F1CD;
  digit2 := $B38F4F83;
  digit3 := $1234678;
  x := TIntegerX.Create(1, [digit1, digit2, digit3]);
  y := x.RightShift(-40);
  z := x.LeftShift(40);
  Assert.IsTrue(y = z);
end;

procedure TIntegerXTest.RightShift_zero_shift_is_this();
var
  digit1, digit2, digit3: UInt32;
  x, y: TIntegerX;
begin
  digit1 := $C1F0F1CD;
  digit2 := $B38F4F83;
  digit3 := $1234678;
  x := TIntegerX.Create(1, [digit1, digit2, digit3]);
  y := x.RightShift(0);
  Assert.IsTrue(y = x);
end;

procedure TIntegerXTest.RightShift_pos_whole_digit_shift_loses_whole_digits();
var
  digit1, digit2, digit3: UInt32;
  x, y, w: TIntegerX;
begin
  digit1 := $C1F0F1CD;
  digit2 := $B38F4F83;
  digit3 := $1234678;
  x := TIntegerX.Create(1, [digit1, digit2, digit3]);
  y := x.RightShift(64);
  w := TIntegerX.Create(1, [digit1]);
  Assert.IsTrue(y = w);
end;

procedure TIntegerXTest.RightShift_neg_whole_digit_shift_loses_whole_digits();
var
  digit1, digit2, digit3: UInt32;
  x, y, w: TIntegerX;
begin
  digit1 := $C1F0F1CD;
  digit2 := $B38F4F83;
  digit3 := $1234678;
  x := TIntegerX.Create(-1, [digit1, digit2, digit3]);
  y := x.RightShift(64);
  w := TIntegerX.Create(-1, [digit1]);
  Assert.IsTrue(y = w);
end;

procedure TIntegerXTest.RightShift_pos_small_shift();
var
  x, y, w: TIntegerX;
  digit1, digit2, digit3: UInt32;
begin
  digit1 := $C1F0F1CD;
  digit2 := $B38F4F83;
  digit3 := $1234678;
  x := TIntegerX.Create(1, [digit1, digit2, digit3]);
  y := x.RightShift(7);
  w := TIntegerX.Create(1, [digit1 shr 7, ((digit1 shl 25) or (digit2 shr 7)),
    ((digit2 shl 25) or (digit3 shr 7))]);
  Assert.IsTrue(y = w);
end;

procedure TIntegerXTest.RightShift_neg_small_shift();
var
  x, y, w: TIntegerX;
  digit1, digit2, digit3: UInt32;
begin
  digit1 := $C1F0F1CD;
  digit2 := $B38F4F83;
  digit3 := $1234678;
  x := TIntegerX.Create(-1, [digit1, digit2, digit3]);
  y := x.RightShift(7);
  w := TIntegerX.Create(-1, [digit1 shr 7, ((digit1 shl 25) or (digit2 shr 7)),
    ((digit2 shl 25) or (digit3 shr 7))]);
  Assert.IsTrue(y = w);
end;

procedure TIntegerXTest.RightShift_pos_big_shift();
var
  x, y, w: TIntegerX;
  digit1, digit2, digit3: UInt32;
begin
  digit1 := $C1F0F1CD;
  digit2 := $B38F4F83;
  digit3 := $1234678;
  x := TIntegerX.Create(1, [digit1, digit2, digit3]);
  y := x.RightShift(7 + 32);
  w := TIntegerX.Create(1, [digit1 shr 7, (digit1 shl 25) or (digit2 shr 7)]);
  Assert.IsTrue(y = w);
end;

procedure TIntegerXTest.RightShift_neg_big_shift();
var
  x, y, w: TIntegerX;
  digit1, digit2, digit3: UInt32;
begin
  digit1 := $C1F0F1CD;
  digit2 := $B38F4F83;
  digit3 := $1234678;
  x := TIntegerX.Create(-1, [digit1, digit2, digit3]);
  y := x.RightShift(7 + 32);
  w := TIntegerX.Create(-1, [digit1 shr 7, (digit1 shl 25) or (digit2 shr 7)]);
  Assert.IsTrue(y = w);
end;

procedure TIntegerXTest.RightShift_pos_big_shift_zero_high_bits();
var
  x, y, w: TIntegerX;
  digit1, digit2, digit3: UInt32;
begin
  digit1 := $00001D;
  digit2 := $B38F4F83;
  digit3 := $1234678;
  x := TIntegerX.Create(1, [digit1, digit2, digit3]);
  y := x.RightShift(7 + 32);
  w := TIntegerX.Create(1, [digit1 shr 7, (digit1 shl 25) or (digit2 shr 7)]);
  Assert.IsTrue(y = w);
end;

{$ENDREGION}
{$REGION 'Attempted conversion methods'}

procedure TIntegerXTest.AsInt32Test(i: TIntegerX; expRet: Boolean;
  expInt: Integer);
var
  v: Integer;
  b: Boolean;
begin
  b := i.AsInt32(v);
  Assert.IsTrue(b = expRet);
  Assert.IsTrue(v = expInt);
end;

procedure TIntegerXTest.AsInt32_various();
begin
  AsInt32Test(TIntegerX.Create(0), true, 0);

  AsInt32Test(TIntegerX.Create(-1, TArray<UInt32>.Create($80000001)), False, 0);

  AsInt32Test(TIntegerX.Create(1, TArray<UInt32>.Create($80000000)), False, 0);

  AsInt32Test(TIntegerX.Create(-1, TArray<UInt32>.Create($80000000)), true,
    Int32.MinValue);

  AsInt32Test(TIntegerX.Create(100), true, 100);

  AsInt32Test(TIntegerX.Create(-100), true, -100);

  AsInt32Test(TIntegerX.Create(1, TArray<UInt32>.Create(1, 0)), False, 0);
end;

procedure TIntegerXTest.AsInt64Test(i: TIntegerX; expRet: Boolean;
  expInt: Int64);
var
  v: Int64;
  b: Boolean;
begin
  b := i.AsInt64(v);
  Assert.IsTrue(b = expRet);
  Assert.IsTrue(v = expInt);
end;

procedure TIntegerXTest.AsInt64_various();
begin
  AsInt64Test(TIntegerX.Create(0), true, 0);

  AsInt64Test(TIntegerX.Create(-1, TArray<UInt32>.Create($80000001)), true,
    Int64(Int32.MinValue) - 1);

  AsInt64Test(TIntegerX.Create(1, TArray<UInt32>.Create($80000000)), true,
    $80000000);

  AsInt64Test(TIntegerX.Create(-1, TArray<UInt32>.Create($80000000)), true,
    Int64(Int32.MinValue));

  AsInt64Test(TIntegerX.Create(-1, TArray<UInt32>.Create($80000000, $00000001)),
    False, 0);

  AsInt64Test(TIntegerX.Create(1, TArray<UInt32>.Create($80000000, $0)),
    False, 0);

  AsInt64Test(TIntegerX.Create(-1, TArray<UInt32>.Create($80000000, $0)), true,
    Int64.MinValue);

  AsInt64Test(TIntegerX.Create(100), true, 100);

  AsInt64Test(TIntegerX.Create(-100), true, -100);

  AsInt64Test(TIntegerX.Create(123456789123456), true, 123456789123456);

  AsInt64Test(TIntegerX.Create(-123456789123456), true, -123456789123456);

  AsInt64Test(TIntegerX.Create(1, TArray<UInt32>.Create(1, 0, 0)), False, 0);
end;

procedure TIntegerXTest.AsUInt32Test(i: TIntegerX; expRet: Boolean;
  expInt: UInt32);
var
  v: UInt32;
  b: Boolean;
begin
  b := i.AsUInt32(v);
  Assert.IsTrue(b = expRet);
  Assert.IsTrue(v = expInt);
end;

procedure TIntegerXTest.AsUInt32_various();
begin
  AsUInt32Test(TIntegerX.Create(-1), False, 0);

  AsUInt32Test(TIntegerX.Create(0), true, 0);

  AsUInt32Test(TIntegerX.Create(1, [$FFFFFFFF]), true, $FFFFFFFF);

  AsUInt32Test(TIntegerX.Create(1, [$1, $0]), False, 0);
end;

procedure TIntegerXTest.AsUInt64Test(i: TIntegerX; expRet: Boolean;
  expInt: UInt64);
var
  v: UInt64;
  b: Boolean;
begin
  b := i.AsUInt64(v);
  Assert.IsTrue(b = expRet);
  Assert.IsTrue(v = expInt);
end;

procedure TIntegerXTest.AsUInt64_various();
begin
  AsUInt64Test(TIntegerX.Create(-1), False, 0);

  AsUInt64Test(TIntegerX.Create(0), true, 0);

  AsUInt64Test(TIntegerX.Create(1, [$FFFFFFFF]), true, $FFFFFFFF);

  AsUInt64Test(TIntegerX.Create(1, [$FFFFFFFF, $FFFFFFFF]), true,
    $FFFFFFFFFFFFFFFF);

  AsUInt64Test(TIntegerX.Create(1, [$1, $0, $0]), False, 0);
end;

{$ENDREGION}
{$REGION 'IEquatable<TIntegerX>'}

procedure TIntegerXTest.Equals_TI_on_default_is_false();
var
  i: TIntegerX;
begin
  i := TIntegerX.Create(1, [$1, $2, $3]);
  Assert.IsTrue(i.Equals(Default (TIntegerX)) = False);
end;

procedure TIntegerXTest.Equals_TI_on_same_is_true();
var
  i, j: TIntegerX;
begin
  i := TIntegerX.Create(1, [$1, $2, $3]);
  j := TIntegerX.Create(1, [$1, $2, $3]);
  Assert.IsTrue(i.Equals(j));
end;

procedure TIntegerXTest.Equals_TI_on_different_is_false();
var
  i, j: TIntegerX;
begin
  i := TIntegerX.Create(1, [$1, $2, $3]);
  j := TIntegerX.Create(1, [$1, $2, $4]);
  Assert.IsTrue(i.Equals(j) = False);
end;

{$ENDREGION}
{$REGION 'Precision tests'}

procedure TIntegerXTest.PrecisionSingleDigitsIsOne();
var
  i: Integer;
  bi: TIntegerX;
begin
  i := -9;
  while i <= 9 do
  begin
    bi := TIntegerX.Create(i);
    Assert.IsTrue(bi.Precision = 1);
    Inc(i);
  end;
end;

procedure TIntegerXTest.PrecisionTwoDigitsIsTwo();
var
  values: TArray<Integer>;
  v: Integer;
  bi: TIntegerX;
begin
  values := TArray<Integer>.Create(-99, -50, -11, -10, 10, 11, 50, 99);

  for v in values do
  begin
    bi := TIntegerX.Create(v);
    Assert.IsTrue(bi.Precision = 2);
  end;

end;

procedure TIntegerXTest.PrecisionThreeDigitsIsThree();
var
  values: TArray<Integer>;
  v: Integer;
  bi: TIntegerX;
begin
  values := TArray<Integer>.Create(-999, -509, -101, -100, 100, 101, 500, 999);

  for v in values do
  begin
    bi := TIntegerX.Create(v);
    Assert.IsTrue(bi.Precision = 3);
  end;

end;

procedure TIntegerXTest.PrecisionBoundaryCases();
var
  nines, tenpow: String;
  i: Integer;
  bi9, bi0: TIntegerX;
begin
  nines := '';
  tenpow := '1';

  i := 1;
  while i < 30 do
  begin
    nines := nines + '9';
    tenpow := tenpow + '0';
    bi9 := TIntegerX.Parse(nines);
    bi0 := TIntegerX.Parse(tenpow);
    Assert.IsTrue(bi9.Precision = UInt32(i));
    Assert.IsTrue(bi0.Precision = (UInt32(i) + 1));
    Inc(i);
  end;
end;

procedure TIntegerXTest.PrecisionBoundaryCase2();
var
  x, y: TIntegerX;
begin
  x := TIntegerX.Create(1, TArray<UInt32>.Create($FFFFFFFF));
  y := TIntegerX.Create(1, TArray<UInt32>.Create($1, $0));
  Assert.IsTrue(x.Precision = 10);
  Assert.IsTrue(y.Precision = 10);
end;

{$ENDREGION}
{$REGION 'Some utilities'}

class function TIntegerXTest.SameValue(i: TIntegerX; sign: Integer;
  mag: TArray<UInt32>): Boolean;
begin
  result := (SameSign(i.Signum, sign) and SameMag(i.GetMagnitude(), mag));
end;

class function TIntegerXTest.SameSign(s1: Integer; s2: Integer): Boolean;
begin
  result := s1 = s2;
end;

class function TIntegerXTest.SameMag(xs: TArray<UInt32>;
  ys: TArray<UInt32>): Boolean;
var
  i: Integer;
begin
  if (Length(xs) <> Length(ys)) then
  begin
    result := False;
    Exit;
  end;
  i := 0;
  while i < Length(xs) do
  begin
    if (xs[i] <> ys[i]) then
    begin
      result := False;
      Exit;
    end;
    Inc(i);
  end;

  result := true;
end;

{$ENDREGION}

initialization

TDUnitX.RegisterTestFixture(TIntegerXTest);

end.
