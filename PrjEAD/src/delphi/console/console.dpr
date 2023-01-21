program console;

uses
  System.Classes,
  System.SysUtils,
  Horse,
  Base.Route in '..\..\common\Base.Route.pas',
  Json.Result in '..\..\common\Json.Result.pas',
  DBConexao.FireDAC in '..\..\common\DBConexao.FireDAC.pas',
  DBConexao.Contrato in '..\..\common\DBConexao.Contrato.pas',
  DBEnv in '..\..\common\DBEnv.pas',
  TipoContato.Service in '..\..\common\TipoContato.Service.pas',
  Service.Contrato in '..\..\common\Service.Contrato.pas',
  TipoContato.Route in '..\..\common\TipoContato.Route.pas',
  u_BaseInterfacedObject in '..\..\common\u_BaseInterfacedObject.pas',
  TipoEndereco.Service in '..\..\common\TipoEndereco.Service.pas',
  TipoEndereco.Route in '..\..\common\TipoEndereco.Route.pas',
  Pessoa.Service in '..\..\common\Pessoa.Service.pas',
  Pessoa.Route in '..\..\common\Pessoa.Route.pas',
  u_ParamsDB in '..\..\common\u_ParamsDB.pas',
  Pessoa.Contato.Service in '..\..\common\Pessoa.Contato.Service.pas',
  Pessoa.Endereco.Service in '..\..\common\Pessoa.Endereco.Service.pas',
  Pessoa.Foto.Service in '..\..\common\Pessoa.Foto.Service.pas',
  u_Tools in '..\..\common\u_Tools.pas',
  Structure.Service in '..\..\common\Structure.Service.pas';

begin
  TBase.Route;
  TTipoContato.Route;
  TTipoEndereco.Route;
  TPessoa.Route;

  THorse.Listen(9095,
    procedure(aHorse: THorse)
    begin
      Writeln(Format('Servidor ativo na porta %d', [aHorse.Port]));
    end);
end.
