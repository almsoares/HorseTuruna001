unit Pessoa.Contato.Service;

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
  TPessoaContatoService = class(TInterfacedObject, IPessoaContatoService)
  private
    FDBCon: IDBConexao;
  public
    constructor Create(aDBCon: IDBConexao);
    destructor Destroy; override;
    class Function New(aDBCon: IDBConexao): IPessoaContatoService;

    function Load(aIDPessoa: string; aJson: TJsonObject = nil): IPessoaContatoService;
    function Insert(aIDPessoa: string; aJson: TJsonArray): IPessoaContatoService;
    function Delete(aIDPessoa: string): IPessoaContatoService;
  end;

implementation

{ TPessoaContatoService }

constructor TPessoaContatoService.Create(aDBCon: IDBConexao);
begin
  FDBCon := aDBCon;
end;

function TPessoaContatoService.Delete(aIDPessoa: string): IPessoaContatoService;
var
  lQry: {$ifdef fpc}TZQuery{$else}TFDQuery{$endif};
begin
  Result := Self;

  try
    try
      lQry := {$ifdef fpc}TZQuery({$else}TFDQuery({$endif}FDBCon.GetQuery);
      lQry.Close;
      lQry.SQL.Clear;
      lQry.SQL.Add('DELETE FROM pessoa_contato   ');
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

destructor TPessoaContatoService.Destroy;
begin

  inherited;
end;

function TPessoaContatoService.Insert(aIDPessoa: string; aJson: TJsonArray): IPessoaContatoService;
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
        lQry.SQL.Add('INSERT INTO pessoa_contato (id, id_pessoa, id_tipo, contato) ');
        lQry.SQL.Add('VALUES (:id, :id_pessoa, :id_tipo, :contato)                 ');

        for I := 0 to Pred(aJson.Count) do
        begin
          lId := FDBCon.GenGUID;
          lQry.ParamByName('id').AsString        := lID;
          lQry.ParamByName('id_pessoa').AsString := aIDPessoa;
          lQry.ParamByName('id_tipo').AsString   := aJson[I].AsObject.Values['id_tipo'].AsString;
          lQry.ParamByName('contato').AsString   := aJson[I].AsObject.Values['contato'].AsString;

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

function TPessoaContatoService.Load(aIDPessoa: string; aJson: TJsonObject): IPessoaContatoService;
var
  lQry: {$ifdef fpc}TZQuery{$else}TFDQuery{$endif};
begin
  Result := Self;
  try
    try
      lQry := {$ifdef fpc}TZQuery({$else}TFDQuery({$endif}FDBCon.GetQuery);

      lQry.Close;
      lQry.SQL.Clear;
      lQry.SQL.Add('SELECT pc.id                                        ');
      //lQry.SQL.Add('      ,pc.id_pessoa                                 ');
      lQry.SQL.Add('      ,pc.id_tipo                                   ');
      lQry.SQL.Add('      ,tc.descricao as tipo                         ');
      lQry.SQL.Add('      ,pc.contato                                   ');
      lQry.SQL.Add('  FROM pessoa_contato pc                            ');
      lQry.SQL.Add(' INNER join tipo_contato tc ON (pc.id_tipo = tc.id) ');
      lQry.SQL.Add(' WHERE pc.id_pessoa = :id_pessoa                    ');
      lQry.ParamByName('id_pessoa').AsString := aIDPessoa;

      lQry.Open;
      lQry.Last;
      lQry.First;

      if (aJson <> nil) then
        aJson.Put('contatos', TConverter.New.LoadDataset(lQry).ToJSONArray );
    except
      on E: exception do
        raise Exception.Create(E.Message);
    end;
  finally
    FreeAndNil(lQry);
  end;
end;

class Function TPessoaContatoService.New(aDBCon: IDBConexao): IPessoaContatoService;
begin
  Result := Self.Create(aDBCon);
end;

end.
