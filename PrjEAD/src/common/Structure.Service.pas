unit Structure.Service;

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
  DBConexao.Contrato, dc4dl, Service.Contrato, Json.Result;

type
  TStructureService = class(TInterfacedObject, IStructureService)
  private
    FDBCon: IDBConexao;
  public
    constructor Create;
    destructor Destroy; override;
    class Function New: IStructureService;

    function GetStructure(aTableName: string): string;
  end;

implementation

{ TStructureService }

constructor TStructureService.Create;
begin
  FDBCon := {$ifdef fpc}TDBConexaoZeos{$else}TDBConexaoFireDAC{$endif}.New;
end;

destructor TStructureService.Destroy;
begin

  inherited;
end;

function TStructureService.GetStructure(aTableName: string): string;
var
  lQry: {$ifdef fpc}TZQuery{$else}TFDQuery{$endif};
begin
  try
    if aTableName.Trim.IsEmpty then
      raise Exception.Create('TableName not found!');

    lQry := {$ifdef fpc}TZQuery({$else}TFDQuery({$endif}FDBCon.GetQuery);
    try
      lQry.Close;
      lQry.SQL.Clear;
      lQry.SQL.Add(Format('SELECT * FROM %s', [aTableName.ToLower]));
//      select * from information_schema.columns where table_name = 'client';
      lQry.SQL.Add('WHERE 1=2 ');
      lQry.Open;

      Result := TJsonResult.New
                           .Data( TConverter.New
                                            .LoadDataSet(lQry)
                                            .ToJSONStructure)
                           .ToString;
    finally
      lQry.Close;
      FreeAndNil(lQry);
    end;
  except
    on E: exception do
      Result := TJsonResult.New(False).Message(E.Message).ToString;
  end;
end;

class function TStructureService.New: IStructureService;
begin
  Result := Self.Create;
end;

end.
