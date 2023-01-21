unit Pessoa.Endereco.Service;

{$ifdef fpc}
  {$mode delphi}
{$endif}

interface

uses
  {$ifdef fpc}
  Classes, SysUtils, DB,
  ZConnection, ZDataset, DBConexao.Zeos,
  {$else}
  System.Classes, System.SysUtils, Data.DB,
  DBConexao.FireDAC, FireDAC.Comp.Client, FireDAC.Stan.Param,
  {$endif}
  DBConexao.Contrato, j4dl, dc4dl, Service.Contrato;

type
  TPessoaEnderecoService = class(TInterfacedObject, IPessoaEnderecoService)
  private
    FDBCon: IDBConexao;
  public
    constructor Create(aDBCon: IDBConexao);
    destructor Destroy; override;
    class Function New(aDBCon: IDBConexao): IPessoaEnderecoService;

    function Load(aIDPessoa: string; aJson: TJsonObject = nil): IPessoaEnderecoService;
    function Insert(aIDPessoa: string; aJson: TJsonArray): IPessoaEnderecoService;
    function Delete(aIDPessoa: string): IPessoaEnderecoService;
  end;

implementation

{ TPessoaEnderecoService }

uses u_Tools;

constructor TPessoaEnderecoService.Create(aDBCon: IDBConexao);
begin
  FDBCon := aDBCon;
end;

function TPessoaEnderecoService.Delete(aIDPessoa: string): IPessoaEnderecoService;
var
  lQry: {$ifdef fpc}TZQuery{$else}TFDQuery{$endif};
begin
  Result := Self;

  try
    try
      lQry := {$ifdef fpc}TZQuery({$else}TFDQuery({$endif}FDBCon.GetQuery);
      lQry.Close;
      lQry.SQL.Clear;
      lQry.SQL.Add('DELETE FROM pessoa_endereco  ');
      lQry.SQL.Add(' WHERE id_pessoa = :id_pessoa');

      lQry.ParamByName('id_pessoa').AsString := aIDPessoa;

      lQry.ExecSQL;
    except
      on E: exception do
        raise Exception.Create(E.Message);
    end;
  finally
    FreeAndNil(lQry);
  end;
end;

destructor TPessoaEnderecoService.Destroy;
begin

  inherited;
end;

function TPessoaEnderecoService.Insert(aIDPessoa: string; aJson: TJsonArray): IPessoaEnderecoService;
var
  lQry: {$ifdef fpc}TZQuery{$else}TFDQuery{$endif};
  lID: string;
  I: Integer;
begin
  Result := Self;

  try
    try
      if (aJson.Count > 0) then
      begin
        lQry := {$ifdef fpc}TZQuery({$else}TFDQuery({$endif}FDBCon.GetQuery);
        lQry.Close;
        lQry.SQL.Clear;
        lQry.SQL.Add('INSERT INTO pessoa_endereco (                   ');
        lQry.SQL.Add('id, id_pessoa, id_tipo, logradouro, numero,     ');
        lQry.SQL.Add('complemento, bairro, cep, municipio, uf)        ');
        lQry.SQL.Add('VALUES (                                        ');
        lQry.SQL.Add(':id, :id_pessoa, :id_tipo, :logradouro, :numero,');
        lQry.SQL.Add(':complemento, :bairro, :cep, :municipio, :uf)   ');

        for I := 0 to Pred(aJson.Count) do
        begin
          lId := FDBCon.GenGUID;
          lQry.ParamByName('id').AsString          := lID;
          lQry.ParamByName('id_pessoa').AsString   := aIDPessoa;
          lQry.ParamByName('id_tipo').AsString     := aJson[I].AsObject.Values['id_tipo'].AsString;
          lQry.ParamByName('logradouro').AsString  := aJson[I].AsObject.Values['logradouro'].AsString;
          lQry.ParamByName('numero').AsString      := aJson[I].AsObject.Values['numero'].AsString;
          lQry.ParamByName('complemento').AsString := aJson[I].AsObject.Values['complemento'].AsString;
          lQry.ParamByName('bairro').AsString      := aJson[I].AsObject.Values['bairro'].AsString;
          lQry.ParamByName('cep').AsString         := TTools.RemoveCaracterEspecial(aJson[I].AsObject.Values['cep'].AsString);
          lQry.ParamByName('municipio').AsString   := aJson[I].AsObject.Values['municipio'].AsString;
          lQry.ParamByName('uf').AsString          := UpperCase(aJson[I].AsObject.Values['uf'].AsString);

          lQry.ExecSQL;
        end;
      end;
    except
      on E: exception do
        raise Exception.Create(E.Message);
    end;
  finally
    FreeAndNil(lQry);
  end;
end;

function TPessoaEnderecoService.Load(aIDPessoa: string; aJson: TJsonObject): IPessoaEnderecoService;
var
  lQry: {$ifdef fpc}TZQuery{$else}TFDQuery{$endif};
  I: Integer;
begin
  Result := Self;

  try
    try
      lQry := {$ifdef fpc}TZQuery({$else}TFDQuery({$endif}FDBCon.GetQuery);
      lQry.Close;
      lQry.SQL.Clear;
      lQry.SQL.Add('SELECT pe.id                                        ');
    //lQry.SQL.Add('      ,pe.id_pessoa                                 ');
      lQry.SQL.Add('      ,pe.id_tipo                                   ');
      lQry.SQL.Add('      ,te.descricao as tipo                         ');
      lQry.SQL.Add('      ,pe.logradouro                                ');
      lQry.SQL.Add('      ,pe.numero                                    ');
      lQry.SQL.Add('      ,pe.complemento                               ');
      lQry.SQL.Add('      ,pe.bairro                                    ');
      lQry.SQL.Add('      ,pe.cep                                       ');
      lQry.SQL.Add('      ,pe.municipio                                 ');
      lQry.SQL.Add('      ,pe.uf                                        ');
      lQry.SQL.Add('  FROM pessoa_endereco pe                           ');
      lQry.SQL.Add(' INNER JOIN tipo_endereco te ON (pe.id_tipo = te.id)');
      lQry.SQL.Add(' WHERE pe.id_pessoa = :id_pessoa');
      lQry.ParamByName('id_pessoa').AsString := aIDPessoa;

      lQry.Open;
      lQry.Last;
      lQry.First;

      if (aJson <> nil) then
      begin
        aJson.Put('enderecos', TConverter.New.LoadDataset(lQry).ToJSONArray );

        if (aJson.Values['enderecos'].AsArray.Count > 0) then
        begin
          for I := 0 to aJson.Values['enderecos'].AsArray.Count - 1 do
            aJson.Values['enderecos'].AsArray[I].AsObject.Values['cep'].AsString :=
            TTools.FormatCepCpfCnpj(
                   aJson.Values['enderecos'].AsArray[I].AsObject.Values['cep'].AsString
                                   );
        end;
      end;
    except
      on E: exception do
        raise Exception.Create(E.Message);
    end;
  finally
    FreeAndNil(lQry);
  end;
end;

class Function TPessoaEnderecoService.New(aDBCon: IDBConexao): IPessoaEnderecoService;
begin
  Result := Self.Create(aDBCon);
end;

end.
