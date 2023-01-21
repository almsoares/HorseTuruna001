program AppCrud;

uses
  Vcl.Forms,
  u_Main in 'u_Main.pas' {F_Main},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Aqua Light Slate');
  Application.CreateForm(TF_Main, F_Main);
  Application.Run;
end.
