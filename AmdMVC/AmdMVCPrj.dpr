program AmdMVCPrj;

uses
  Vcl.Forms,
  Unit1 in 'src\Unit1.pas' {Form1},
  unCommon.SmartPointerClass in 'Common\unCommon.SmartPointerClass.pas',
  unDAO.Base in 'DAO\unDAO.Base.pas',
  unModel.Base in 'Model\unModel.Base.pas',
  unModel.Pais in 'Model\unModel.Pais.pas',
  unCommon.Tools in 'Common\unCommon.Tools.pas',
  unModel.Estado in 'Model\unModel.Estado.pas',
  unClassRegister in 'Common\unClassRegister.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
