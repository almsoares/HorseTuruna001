unit TipoContato.Service;

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
  DBConexao.FireDAC, FireDAC.Comp.Client, FireDAC.Stan.Param, System.Math,
  {$endif}
  DBConexao.Contrato, j4dl, dc4dl, Service.Contrato, Json.Result;

type
  TTipoContatoService = class(TInterfacedObject, ITipoContatoService)
  private
    FDBCon: IDBConexao;
    function IsExist(aID: string): Boolean;
    function Insert(aJson: TJsonObject): string;
    function Update(aJson: TJsonObject): string;
  public
    constructor Create;
    destructor Destroy; override;
    class Function New: ITipoContatoService;

    //function Load(aID, aDescricao: string; aPage: Integer = 0; aLimit: Integer = 0; var aStatusCode): string;
    function Load(aID, aDescricao: string; aPage: Integer = 0; aLimit: Integer = 0): string;
    function Save(aID: string; aJson: string): string;
    function Delete(aID: string): string;
  end;

implementation

{ TTipoContatoService }

constructor TTipoContatoService.Create;
begin
  FDBCon := {$ifdef fpc}TDBConexaoZeos{$else}TDBConexaoFireDAC{$endif}.New;
end;

function TTipoContatoService.Delete(aID: string): string;
var
  lQry: {$ifdef fpc}TZQuery{$else}TFDQuery{$endif};
begin
  try
    if not IsExist(aID) then
    begin
      Result := TJsonResult.New(False)
                           .Statuscode(000)
                           .Message('Tipo de contato not found!')
                           .ToString;
      Exit;
    end;

    lQry := {$ifdef fpc}TZQuery({$else}TFDQuery({$endif}FDBCon.GetQuery);
    try
      lQry.Close;
      lQry.SQL.Clear;
      lQry.SQL.Add('UPDATE tipo_contato       ');
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

destructor TTipoContatoService.Destroy;
begin

  inherited;
end;

function TTipoContatoService.Insert(aJson: TJsonObject): string;
var
  lQry: {$ifdef fpc}TZQuery{$else}TFDQuery{$endif};
  lID: string;
begin
  try
    lQry := {$ifdef fpc}TZQuery({$else}TFDQuery({$endif}FDBCon.GetQuery);
    try
      lQry.Close;
      lQry.SQL.Clear;
      lQry.SQL.Add('INSERT INTO tipo_contato (id, descricao) ');
      lQry.SQL.Add('VALUES (:id, :descricao)                 ');

      lId := FDBCon.GenGUID;
      lQry.ParamByName('id').AsString := lID;
      lQry.ParamByName('descricao').AsString := Copy(aJson.Values['descricao'].AsString, 0, 35);

      lQry.ExecSQL;

      lQry.Close;
      lQry.SQL.Clear;
      lQry.SQL.Add('SELECT id, descricao ');
      lQry.SQL.Add('  FROM tipo_contato  ');
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

function TTipoContatoService.IsExist(aID: string): Boolean;
var
  lQry: {$ifdef fpc}TZQuery{$else}TFDQuery{$endif};
begin
  try
    lQry := {$ifdef fpc}TZQuery({$else}TFDQuery({$endif}FDBCon.GetQuery);
    try
      lQry.Close;
      lQry.SQL.Clear;
      lQry.SQL.Add('SELECT id          ');
      lQry.SQL.Add('  FROM tipo_contato');
      lQry.SQL.Add(' WHERE id = :id    ');
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

//function TTipoContatoService.Load(aID, aDescricao: string; aPage: Integer; aLimit: Integer; var aStatusCode): string;
function TTipoContatoService.Load(aID, aDescricao: string; aPage: Integer; aLimit: Integer): string;
var
  lQry: {$ifdef fpc}TZQuery{$else}TFDQuery{$endif};
  lQryCount: {$ifdef fpc}TZQuery{$else}TFDQuery{$endif};
  atotal: Integer;
begin
  try
    lQry := {$ifdef fpc}TZQuery({$else}TFDQuery({$endif}FDBCon.GetQuery);
    try
      lQry.Close;
      lQry.SQL.Clear;
      lQry.SQL.Add('SELECT id, descricao ');
      lQry.SQL.Add('  FROM tipo_contato  ');
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
        //aStatusCode := 200;
        if aPage>0 then
        begin
          lQryCount := {$ifdef fpc}TZQuery({$else}TFDQuery({$endif}FDBCon.GetQuery);
          try
            lQryCount.Close;
            lQryCount.SQL.Clear;
            lQryCount.SQL.Add('SELECT count(*) as total ');
            lQryCount.SQL.Add('  FROM tipo_contato  ');
            lQryCount.Open;
            atotal:= lQryCount.FieldByName('total').AsInteger;
          finally
            lQryCount.Close;
            FreeAndNil(lQryCount);
          end;
          // if Ceil(aTotal/aLimit)=aPage then aLimit:= lQry.RecordCount;
          Result := TJsonResult.New
                             //.Statuscode(aStatusCode)
                             .Data( TConverter.New
                                              .LoadDataSet(lQry)
                                              .ToJSONArray )
                             .Paginate(aTotal, aPage, aLimit)
                             .ToString;
        end else
          Result := TJsonResult.New
                             //.Statuscode(aStatusCode)
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

class function TTipoContatoService.New: ITipoContatoService;
begin
  Result := Self.Create;
end;

function TTipoContatoService.Save(aID: string; aJson: string): string;
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
                               .Message('Tipo de contato not found!')
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

function TTipoContatoService.Update(aJson: TJsonObject): string;
var
  lQry: {$ifdef fpc}TZQuery{$else}TFDQuery{$endif};
begin
  try
    lQry := {$ifdef fpc}TZQuery({$else}TFDQuery({$endif}FDBCon.GetQuery);
    try
      lQry.Close;
      lQry.SQL.Clear;
      lQry.SQL.Add('UPDATE tipo_contato           ');
      lQry.SQL.Add('   SET descricao = :descricao ');
      lQry.SQL.Add(' WHERE id = :id               ');

      lQry.ParamByName('id').AsString        := aJson.Values['id'].AsString;
      lQry.ParamByName('descricao').AsString := Copy(aJson.Values['descricao'].AsString, 0, 35);

      lQry.ExecSQL;

      lQry.Close;
      lQry.SQL.Clear;
      lQry.SQL.Add('SELECT id, descricao ');
      lQry.SQL.Add('  FROM tipo_contato  ');
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
