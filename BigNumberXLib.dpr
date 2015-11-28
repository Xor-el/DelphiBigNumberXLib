program BigNumberXLib;

uses
  Vcl.Forms,
  DecimalX in 'BigNumberXLib\src\DecimalXLib\DecimalX.pas',
  IntegerX in 'BigNumberXLib\src\IntegerXLib\IntegerX.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Run;
end.
