unit TipoEndereco.Service;

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
  DBConexao.Contrato, j4dl, dc4dl, Service.Contrato, Json.Result;

type
  TTipoEnderecoService = class(TInterfacedObject, ITipoEnderecoService)
  private
    FDBCon: IDBConexao;
    function IsExist(aID: string): Boolean;
    function Insert(aJson: TJsonObject): string;
    function Update(aJson: TJsonObject): string;
  public
    constructor Create;
    destructor Destroy; override;
    class Function New: ITipoEnderecoService;

    function Load(aID, aDescricao: string; aPage: Integer = 0; aLimit: Integer = 0): string;
    function Save(aID: string; aJson: string): string;
    function Delete(aID: string): string;
  end;

implementation

{ TTipoEnderecoService }

constructor TTipoEnderecoService.Create;
begin
  FDBCon := {$ifdef fpc}TDBConexaoZeos{$else}TDBConexaoFireDAC{$endif}.New;
end;

function TTipoEnderecoService.Delete(aID: string): string;
var
  lQry: {$ifdef fpc}TZQuery{$else}TFDQuery{$endif};
begin
  try
    if not IsExist(aID) then
    begin
      Result := TJsonResult.New(False)
                           .Statuscode(000)
                           .Message('Tipo de endereço not found!')
                           .ToString;
      Exit;
    end;

    lQry := {$ifdef fpc}TZQuery({$else}TFDQuery({$endif}FDBCon.GetQuery);
    try
      lQry.Close;
      lQry.SQL.Clear;
      lQry.SQL.Add('UPDATE tipo_endereco      ');
      lQry.SQL.Add('   SET deleted = :deleted ');
      lQry.SQL.Add(' WHERE id = :id           ');

      lQry.ParamByName('id').AsString       := aID;
      lQry.ParamByName('deleted').AsInteger := 1;

      lQry.ExecSQL;

      Result := TJsonResult.New()
                           .Message('Registro deletado com sucesso.')
                           .ToString;
    finally
      FreeAndNil(lQry);
    end;
  except
    on E: exception do
      Result := TJsonResult.New(False)
                           .Statuscode(500)
                           .Message(E.Message)
                           .ToString;
  end;
end;

destructor TTipoEnderecoService.Destroy;
begin

  inherited;
end;

function TTipoEnderecoService.Insert(aJson: TJsonObject): string;
var
  lQry: {$ifdef fpc}TZQuery{$else}TFDQuery{$endif};
  lID: string;
begin
  try
    lQry := {$ifdef fpc}TZQuery({$else}TFDQuery({$endif}FDBCon.GetQuery);
    try
      lQry.Close;
      lQry.SQL.Clear;
      lQry.SQL.Add('INSERT INTO tipo_endereco (id, descricao) ');
      lQry.SQL.Add('VALUES (:id, :descricao)                  ');

      lId := FDBCon.GenGUID;
      lQry.ParamByName('id').AsString := lID;
      lQry.ParamByName('descricao').AsString := Copy(aJson.Values['descricao'].AsString, 0, 35);

      lQry.ExecSQL;

      lQry.Close;
      lQry.SQL.Clear;
      lQry.SQL.Add('SELECT id, descricao ');
      lQry.SQL.Add('  FROM tipo_endereco ');
      lQry.SQL.Add(' WHERE id = :id      ');
      lQry.Params[0].AsString := lID;

      lQry.Open;

      Result := TJsonResult.New()
                           .Statuscode(201)
                           .Message('Registro incluido com sucesso.')
                           .Data( TConverter.New
                                            .LoadDataSet( lQry )
                                            .ToJSONObject )
                           .ToString;
    finally
      FreeAndNil(lQry);
    end;
  except
    on E: exception do
      Result := TJsonResult.New(False)
                           .Statuscode(500)
                           .Message(E.Message)
                           .ToString;
  end;
end;

function TTipoEnderecoService.IsExist(aID: string): Boolean;
var
  lQry: {$ifdef fpc}TZQuery{$else}TFDQuery{$endif};
begin
  try
    lQry := {$ifdef fpc}TZQuery({$else}TFDQuery({$endif}FDBCon.GetQuery);
    try
      lQry.Close;
      lQry.SQL.Clear;
      lQry.SQL.Add('SELECT id           ');
      lQry.SQL.Add('  FROM tipo_endereco');
      lQry.SQL.Add(' WHERE id = :id     ');
      lQry.Params[0].AsString := aID;
      lQry.Open;

      Result := not lQry.IsEmpty;
    finally
      lQry.Close;
      FreeAndNil(lQry);
    end;
  except
    on E: exception do
      raise Exception.Create(E.Message);
  end;
end;

function TTipoEnderecoService.Load(aID, aDescricao: string; aPage: Integer; aLimit: Integer): string;
var
  lQry: {$ifdef fpc}TZQuery{$else}TFDQuery{$endif};
begin
  try
    lQry := {$ifdef fpc}TZQuery({$else}TFDQuery({$endif}FDBCon.GetQuery);
    try
      lQry.Close;
      lQry.SQL.Clear;
      lQry.SQL.Add('SELECT id, descricao ');
      lQry.SQL.Add('  FROM tipo_endereco ');
      lQry.SQL.Add(' WHERE deleted = 0   ');

      if not aID.Trim.IsEmpty then
      begin
        lQry.SQL.Add('AND id = :id ');
        lQry.ParamByName('id').AsString := aID;
      end;

      if not aDescricao.Trim.IsEmpty then
      begin
        if aDescricao.Contains('*') then
          aDescricao := StringReplace(aDescricao, '*', '%', [rfReplaceAll]);

        lQry.SQL.Add('AND LOWER(descricao) like :descricao');
        lQry.ParamByName('descricao').AsString := aDescricao.ToLower;
      end;

      lQry.SQL.Add(FDBCOn.Paginate(aPage, aLimit));

      lQry.Open;
      if lQry.IsEmpty then
      begin
        Result := TJsonResult.New(False)
                             .Message('Nenhum registro localizado!')
                             .ToString;
      end
      else
      begin
        lQry.Last;
        lQry.First;

        Result := TJsonResult.New
                             .Data( TConverter.New
                                              .LoadDataSet(lQry)
                                              .ToJSONArray )
                             .ToString;
      end;
    finally
      lQry.Close;
      FreeAndNil(lQry);
    end;
  except
    on E: exception do
      raise Exception.Create(E.Message);
  end;
end;

class function TTipoEnderecoService.New: ITipoEnderecoService;
begin
  Result := Self.Create;
end;

function TTipoEnderecoService.Save(aID: string; aJson: string): string;
var
  lJson: TJsonObject;
begin
  lJson := TJsonObject.Create();
  try
    try
      if aJson.Trim.IsEmpty or not lJson.IsJsonObject(aJson) then
      begin
        Result := TJsonResult.New(False)
                             .Statuscode(000)
                             .Message('JSON Invalid!')
                             .ToString;
        Exit;
      end;

      lJson.Parse(aJson);

      if not aID.Trim.IsEmpty then
      begin
        if not IsExist(aID) then
        begin
          Result := TJsonResult.New(False)
                               .Statuscode(000)
                               .Message('Tipo de endereço not found!')
                               .ToString;
          Exit;
        end;

        if (lJson.Find('id') > -1) then
          lJson.Delete('id');

        lJson.Put('id', aID);
        Result := Update(lJson);
      end
      else
        Result := Insert(lJson);
    except
      on E: exception do
        Result := TJsonResult.New(False)
                             .Statuscode(500)
                             .Message(E.Message)
                             .ToString;
    end;
  finally
    FreeAndNil(lJson);
  end;
end;

function TTipoEnderecoService.Update(aJson: TJsonObject): string;
var
  lQry: {$ifdef fpc}TZQuery{$else}TFDQuery{$endif};
  lTeste: string;
begin
  try
    lQry := {$ifdef fpc}TZQuery({$else}TFDQuery({$endif}FDBCon.GetQuery);
    try
      lTeste := aJson.Values['descricao'].AsString;

      lQry.Close;
      lQry.SQL.Clear;
      lQry.SQL.Add('UPDATE tipo_endereco          ');
      lQry.SQL.Add('   SET descricao = :descricao ');
      lQry.SQL.Add(' WHERE id = :id               ');

      lQry.ParamByName('id').AsString        := aJson.Values['id'].AsString;
      lQry.ParamByName('descricao').AsString := Copy(aJson.Values['descricao'].AsString, 0, 35);

      lQry.ExecSQL;

      lQry.Close;
      lQry.SQL.Clear;
      lQry.SQL.Add('SELECT id, descricao ');
      lQry.SQL.Add('  FROM tipo_endereco ');
      lQry.SQL.Add(' WHERE id = :id      ');
      lQry.Params[0].AsString := aJson.Values['id'].AsString;

      lQry.Open;

      Result := TJsonResult.New()
                           .Statuscode(000)
                           .Message('Registro alterado com sucesso.')
                           .Data( TConverter.New
                                            .LoadDataSet(lQry)
                                            .ToJSONObject )
                           .ToString;
    finally
      FreeAndNil(lQry);
    end;
  except
    on E: exception do
      Result := TJsonResult.New(False)
                           .Statuscode(500)
                           .Message(E.Message)
                           .ToString;
  end;
end;

end.
