program BigNumberXLib;

uses
  Vcl.Forms,
  DecimalX in 'BigNumberXLib\src\DecimalXLib\DecimalX.pas',
  IntegerX in 'BigNumberXLib\src\IntegerXLib\IntegerX.pas',
  DecimalXHelper in 'BigNumberXLib\src\Helpers\DecimalXHelper.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Run;
end.
