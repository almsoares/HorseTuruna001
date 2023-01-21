////////////////////////////////////////////////////////////////////////////////
// Classe de dados : MVC-Model.Pais
// Templarium      : 2.0.0.00
// Data de Geração : 2023/01/16 - 12:00:01
////////////////////////////////////////////////////////////////////////////////

unit unModel.Generics.DBService;

{$ifdef fpc}
  {$mode delphi}
{$endif}

interface

uses
  {$ifdef fpc}
  Classes, SysUtils,
  {$else}
  System.Classes, System.SysUtils,
  unDAO.DBConexao.FireDAC, FireDAC.Comp.Client, FireDAC.Stan.Param,
  {$endif}
  db, unDAO.DBConexao.interfaces, unDAO.Base,
  unModel.Pais,
  j4dl, dc4dl, Json.Result; //, unCommon.SmartPointerClass, unModel.Base;

type

  IGenericsDBService = interface
   ['{0346ABD8-8D12-4C70-8C18-58FF9A68F75D}']
    function Load(aID: string; aPage: Integer = 0; aLimit: Integer = 0): string;
    function Save(aID: string; aJson: string): string;
    function Delete(aID: string): string;
  end;

  TGenericsDBService = class(TInterfacedObject, IGenericsDBService)
  private
    FDBCon: IDBConexao;
    function IsExist(aID: string): Boolean;
    function Insert(aJson: TJsonObject): string;
    function Update(aJson: TJsonObject): string;
  public
    constructor Create;
    destructor Destroy; override;
    class Function New: IGenericsDBService;

    function Load(aID: string; aPage: Integer = 0; aLimit: Integer = 0): string;
    function Save(aID: string; aJson: string): string;
    function Delete(aID: string): string;
  end;

implementation


{ TGenericsDBService }

constructor TGenericsDBService.Create;
begin
  FDBCon := {$ifdef fpc}TDBConexaoZeos{$else}TDBConexaoFireDAC{$endif}.New;
end;

function TGenericsDBService.Delete(aID: string): string;
var
  lQry: {$ifdef fpc}TZQuery{$else}TFDQuery{$endif};
begin

  try
    if not IsExist(aID) then
    begin
      Result := TJsonResult.New(False)
                           .Statuscode(000)
                           .Message('Pais não encontrado!')
                           .ToString;
      Exit;
    end;

    lQry := {$ifdef fpc}TZQuery({$else}TFDQuery({$endif}FDBCon.GetQuery);
    try
      lQry.Close;
      lQry.SQL.Clear;
      lQry.SQL.Add(GetDelete(TLocalPais.New));
      lQry.ParamByName(GetPkName(TLocalPais.New)).AsString:= aID;

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

destructor TGenericsDBService.Destroy;
begin
//
  inherited;
end;

function TGenericsDBService.Insert(aJson: TJsonObject): string;
begin
//
end;

function TGenericsDBService.IsExist(aID: string): Boolean;
var
  lQry: {$ifdef fpc}TZQuery{$else}TFDQuery{$endif};
begin
  try
    lQry := {$ifdef fpc}TZQuery({$else}TFDQuery({$endif}FDBCon.GetQuery);
    try
      lQry.Close;
      lQry.SQL.Clear;
      lQry.SQL.Add(GetSelect(TLocalPais.New, false, True));

      if not aID.Trim.IsEmpty then
      begin
        lQry.SQL.Add('AND ' + GetPkName(TLocalPais.New) + ' = :'+ GetPkName(TLocalPais.New) );
        lQry.ParamByName(GetPkName(TLocalPais.New) ).AsString := aID;
      end else
        raise Exception.Create('Params not found!');

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

function TGenericsDBService.Load(aID: string; aPage, aLimit: Integer): string;
var
  lQry: {$ifdef fpc}TZQuery{$else}TFDQuery{$endif};
  lJsonObject: TJsonObject;
  lJsonArray: TJsonArray;
  I: Integer;
begin
  try
    try
      lQry := {$ifdef fpc}TZQuery({$else}TFDQuery({$endif}FDBCon.GetQuery);
      lQry.Close;
      lQry.SQL.Clear;
      lQry.SQL.Add(GetSelect(TLocalPais.New, false, True));
    finally
      lQry.Close;
      FreeAndNil(lQry);
    end;

    if not aID.Trim.IsEmpty then
    begin
      lQry.SQL.Add('AND ' + GetPkName(TLocalPais.New) + ' = :'+ GetPkName(TLocalPais.New) );
      lQry.ParamByName(GetPkName(TLocalPais.New) ).AsString := aID;
    end;

//    lQry.SQL.Add(FDBCOn.Paginate(aPage, aLimit));

    lQry.Open;

    if lQry.IsEmpty then
    begin
      Result := TJsonResult.New(False)
                           .Message('Nenhum registro localizado!')
                           .ToString;
    end else
    begin
      lQry.Last;
      lQry.First;

      lJsonObject := Nil;
      lJsonArray := Nil;

      lJsonObject := TJsonObject.Create();
      lJsonArray := TJsonArray.Create();
      try
        while not lQry.EOF do
        begin
          lJsonObject.Clear;
          lJsonObject.Assign( TConverter.New.LoadDataSet(lqry).ToJSONObject );
          lJsonArray.Put(lJsonObject);
          lQry.Next;
        end;

        Result := TJsonResult.New
                             .Data( lJsonArray )
                             .ToString;
      finally
        if Assigned(lJsonObject) then
          FreeAndNil(lJsonObject);
        if Assigned(lJsonArray) then
          FreeAndNil(lJsonArray);
      end;
    end;
  except
    on E: exception do
      raise Exception.Create(E.Message);
  end;
end;

class function TGenericsDBService.New: IGenericsDBService;
begin
  Result := Self.Create;
end;

function TGenericsDBService.Save(aID, aJson: string): string;
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
                               .Message('Pessoa not found!')
                               .ToString;
          Exit;
        end;

        if (lJson.Find('id') > -1) then
          lJson.Delete('id');

        lJson.Put('id', aID);
        Result := Update(lJson);
      end else
      begin
        Result := Insert(lJson);
      end;
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

function TGenericsDBService.Update(aJson: TJsonObject): string;
begin

end;

end.
