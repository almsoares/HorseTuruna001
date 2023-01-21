////////////////////////////////////////////////////////////////////////////////
// Classe de dados : MVC-DAO.DBConexao.Services - SERVER SIDE
// Templarium      : 2.0.0.00
// Data de Geração : 2023/01/16 - 12:00:01
////////////////////////////////////////////////////////////////////////////////

unit unDAO.DBConexao.Services;

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
  unDAO.DBConexao.FireDAC, //FireDAC.Comp.Client, FireDAC.Stan.Param,
  {$endif}
  unDAO.DBConexao.interfaces,
  dc4dl, Json.Result;

type

  IStructureService = interface
    ['{2A136861-63FE-4510-829A-021DCAE270AD}']
    function CheckDB: string;
  end;

  TStructureService = class(TInterfacedObject, IStructureService)
  private
    FDBCon: IDBConexao;
  public
    constructor Create;
    destructor Destroy; override;
    class Function New: IStructureService;

    function CheckDB: string;
  end;

implementation

{ TStructureService }

function TStructureService.CheckDB: string;
begin
  result:= FDBCon.CheckDB;
end;

constructor TStructureService.Create;
begin
  FDBCon := {$ifdef fpc}TDBConexaoZeos{$else}TDBConexaoFireDAC{$endif}.New;
end;

destructor TStructureService.Destroy;
begin
  //
  inherited;
end;

class function TStructureService.New: IStructureService;
begin
  Result := Self.Create;
end;

end.
