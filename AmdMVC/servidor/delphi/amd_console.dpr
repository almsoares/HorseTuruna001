program amd_console;

uses
  System.Classes,
  System.SysUtils,
  Horse,
  unCommon.SmartPointerClass in '..\..\Common\unCommon.SmartPointerClass.pas',
  unDAO.Base in '..\..\DAO\unDAO.Base.pas',
  unModel.Base in '..\..\Model\unModel.Base.pas',
  unRoute.Base in '..\common\unRoute.Base.pas',
  unDAO.DBConexao.interfaces in '..\..\DAO\unDAO.DBConexao.interfaces.pas',
  unDAO.DBConexao.FireDAC in '..\..\DAO\unDAO.DBConexao.FireDAC.pas',
  unDAO.DBConexao.DBEnv in '..\..\DAO\unDAO.DBConexao.DBEnv.pas',
  Json.Result in '..\common\Json.Result.pas',
  unDAO.DBConexao.Services in '..\..\DAO\unDAO.DBConexao.Services.pas',
  unModel.Pais in '..\..\Model\unModel.Pais.pas',
  unModel.Pais.DBService in '..\..\Model\unModel.Pais.DBService.pas',
  unModel.Generics.DBService in '..\..\Model\unModel.Generics.DBService.pas',
  unClassRegister in '..\..\Common\unClassRegister.pas';

begin
  ReportMemoryLeaksOnShutdown := True;

  TBase.Route;

  THorse.Listen(9095,
    procedure(aHorse:THorse)
    begin
      Writeln(Format('Servidor Horse-Amadeus ativo na porta %d',[aHorse.Port]));
    end);
end.
