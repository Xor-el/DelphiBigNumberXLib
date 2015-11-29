ArbitraryXLib
====

 **`ArbitraryXLib`** is a Delphi Big Number Library with support for Integer and Floating Point Computations.
 It consists of three custom types namely 

    
 
1.  **`TIntegerX`** 
   which provides support for Integer Computations and is based on [ClojureCLR BigInteger Class](https://github.com/clojure/clojure-clr/blob/master/Clojure/Clojure/Lib/BigInteger.cs)

2. **`TDecimalX`** which provides support for Floating Point Computations and is based on [ClojureCLR BigDecimal Class](https://github.com/clojure/clojure-clr/blob/master/Clojure/Clojure/Lib/BigDecimal.cs). 
3. **`TContext`** which defines the precision and rounding mode for Floating Point Computations.

    
**`Hints about the code:`**

    1.  Multi-condition "for" loops and loops where iterator gets changed inside 
      the loop were converted to while loops. 
        
    2.  This Library is written with (Delphi XE7 Update 1). 
        This Library have been tested to work properly with Delphi (XE7 Update 1). 
        This Library might work with other Unicode versions of Delphi (at least XE3 
        upwards) with little or no modifications but have not been tested by me. 
       
    3. Finally, Mobile Compilers are Supported.
  
   
**`Usage Hints`**

    1. This Library supports Operator Overloading as well as "Chaining Mode".
     
    2. When Performing Floating Point Arithmetics, especially Division, it 
      is advisable to use the "Chaining Mode" so we can specify the "TContext" 
      in order to avoid issues with "Non-terminating decimal expansion" like (1/3) 
      since this Library is an "Unlimited" Precision Library.
      When using the "Chaining Mode", do note that it uses Left to Right precedence 
      rather than "PEMDAS" or "BODMAS".
      In order to use "PEMDAS" or "BODMAS" precedence in Chaining Mode, you have
      to group the preferred operations in Parenthesis.

    3. Note that when using the Double Constructor of "TDecimalX", 
       TDecimalX.Create(0.1) <> TDecimalX.Create('0.1');
       This is as a result of Computers being unable to store floating point values 
       exactly Internally.

    4. Note that the "=" operator or ".Equals" of TDecimalX compares both precision, not
       just coefficients and exponents, so assertions 
       like 1.0 = 1.00 will return false.
       for such comparisons, use the "CompareTo" method.
       Examples
       var
       a, b: TDecimalX;
       result: Boolean;
       begin
         a:= TDecimalX.Create('1.0');
         b:= TDecimalX.Create('1.00');
         result := a = b;  // returns false
         result := a.CompareTo(b) = 0; // returns true
       end; 

Code Examples
------------

To Perform Operations with **`TIntegerX`** and **`TDecimalX`**:
Using Operator Overloading Method;
```pascal
uses
SysUtils, IntegerX, DecimalX;

procedure Calc();
var
  int1, int2, intans: TIntegerX;
  dec1, dec2, decans: TDecimalX;

begin
  int1 := TIntegerX.Create(4);
  int2 := TIntegerX.Create('8');
  intans := int1 * int2 + int1 - int2 div int1;
  ShowMessage(intans.ToString());

  dec1 := TDecimalX.Create(8.97);
  dec2 := TDecimalX.Create('6.2');
  decans := dec1 * dec2 + dec1 - dec2 / dec1;
  ShowMessage(decans.ToString());

end;

```
Using Chaining Method;

```pascal
uses
SysUtils, IntegerX, DecimalX;

procedure Calc();
var
  int1, int2, intans: TIntegerX;
  dec1, dec2, decans: TDecimalX;
  c: TContext;

begin
  int1 := TIntegerX.Create(4);
  int2 := TIntegerX.Create('8');
  // left to right
  intans := int1.Multiply(int2).Add(int1).Subtract(int2).Divide(int1);
  ShowMessage(intans.ToString());

  c:= TContext.Create(5, TRoundingMode.HalfUp);
  dec1 := TDecimalX.Create(8.97);
  dec2 := TDecimalX.Create('6.2');
  // left to right
  decans := dec1.Multiply(dec2, c).Add(dec1, c).Subtract(dec2, c).Divide(dec1, c);
  ShowMessage(decans.ToString());

end;

```

Unit Tests
--------------------------------------------------
      Unit Tests can be found in BigNumberXLib.Test Folder.
    The Unit tests makes use of DUnitX and TestInsight.

License
--------------------------------------------------

This Program is Licensed Under **`Mozilla Public License  v. 2.0`**

Conclusion
--------------------------------------------------

   Special Thanks to the makers of [ClojureCLR](https://github.com/clojure/clojure-clr/) .
