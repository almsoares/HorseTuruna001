////////////////////////////////////////////////////////////////////////////////
// Classe de dados : MVC-DAO.DBConexao.FireDAC - SERVER SIDE
// Templarium      : 2.0.0.00
// Data de Geração : 2023/01/16 - 12:00:01
////////////////////////////////////////////////////////////////////////////////

unit unDAO.DBConexao.FireDAC;

interface

uses SYstem.Classes, System.SysUtils, unDAO.DBConexao.interfaces, // u_BaseInterfacedObject,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FBDef, FireDAC.ConsoleUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Comp.UI,
  FireDAC.Phys.IBBase, FireDAC.Phys.FB,
  FireDAC.Phys.PG, FireDAC.Phys.PGDef,
  FireDAC.Stan.StorageBin;



  //FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  //FireDAC.Phys.SQLiteWrapper.Stat,

type
  TDBConexaoFireDAC = class(TInterfacedObject, IDBConexao)
  private
    FConexao: TFDConnection;
    FDPhysFBDriverLink: TFDPhysFBDriverLink;
    FDGUIxWaitCursor: TFDGUIxWaitCursor;
    procedure OnBeforeConnect(Sender: TObject);
  public
    constructor Create;
    destructor Destroy; override;
    class function New: IDBConexao;

    function Connected: Boolean; overload;
    function Connected(Value: Boolean): IDBConexao; overload;
    function InTransaction: Boolean;
    function StartTransaction: IDBConexao;
    function Commit: IDBConexao;
    function Rollback: IDBConexao;

    function GetQuery: TComponent;
    function CheckDB: string;
    function Paginate(aPage, aLimit: Integer): string;
  end;

implementation

uses JSON.Result, unDAO.DBConexao.DBEnv;  //, u_ParamsDB;

{ TDBConexaoFireDAC }

function TDBConexaoFireDAC.CheckDB: string;
begin
  try
    FConexao.Connected := False;
    FConexao.Connected := True;
    FConexao.Connected := False;

    Result := TJsonResult.New
                         .Message('Conexão coma a base de dados OK.')
                         .ToString;
  except
    on E: exception do
      Result := TJsonResult.New(False)
                           .Statuscode(500)
                           .Message(E.Message)
                           .ToString;
  end;
end;

function TDBConexaoFireDAC.Commit: IDBConexao;
begin
  Result := Self;

  if FConexao.InTransaction then
    FConexao.Commit;
end;

function TDBConexaoFireDAC.Connected: Boolean;
begin
  Result := FConexao.Connected;
end;

function TDBConexaoFireDAC.Connected(Value: Boolean): IDBConexao;
begin
  Result := Self;

  FConexao.Connected := Value;
end;

constructor TDBConexaoFireDAC.Create;
begin
  inherited;
  FConexao := TFDConnection.Create(nil);
  FConexao.BeforeConnect := OnBeforeConnect;

  FDPhysFBDriverLink := TFDPhysFBDriverLink.Create(nil);
  FDGUIxWaitCursor   := TFDGUIxWaitCursor.Create(nil);
end;

destructor TDBConexaoFireDAC.Destroy;
begin
  FConexao.Connected := False;
  FreeAndNil(FConexao);
  FreeAndNil(FDPhysFBDriverLink);
  FreeAndNil(FDGUIxWaitCursor);

  inherited;
end;

function TDBConexaoFireDAC.GetQuery: TComponent;
begin
  Result := TFDQuery.Create(nil);
  TFDQuery(Result).Connection := FConexao;
end;

function TDBConexaoFireDAC.InTransaction: Boolean;
begin
  Result := FConexao.InTransaction;
end;

class function TDBConexaoFireDAC.New: IDBConexao;
begin
  Result := Self.Create;
end;

procedure TDBConexaoFireDAC.OnBeforeConnect(Sender: TObject);
//var
//  lParamsDB: IParamsDB;
begin
  FConexao.Params.DriverID         := DB_DRIVER_ID;
  FConexao.Params.Values['Server'] := DB_HOST;
  FConexao.Params.Values['Pot']    := DB_PORT.ToString;
  FConexao.Params.Database         := DB_DATABASE;
  FConexao.Params.UserName         := DB_USERNAME;
  FConexao.Params.Password         := DB_PASSWORD;

  FDPhysFBDriverLink.VendorLib     := DB_PATH_LIB;

//  TParamsDB.New(tsFB)
//           .HostName('localhost')
//           .Port(3050)
//           .Database('')
//           .User('')
//           .Password('')
//           .WriteIni;

//  lParamsDB := TParamsDB.New(tsFB);
//
//  FConexao.Params.DriverID         := lParamsDB.DriveID;
//  FConexao.Params.Values['Server'] := lParamsDB.HostName;
//  FConexao.Params.Values['Pot']    := lParamsDB.PortStr;
//  FConexao.Params.Database         := lParamsDB.Database;
//  FConexao.Params.UserName         := lParamsDB.User;
//  FConexao.Params.Password         := lParamsDB.Password;
//  FDPhysFBDriverLink.VendorLib     := lParamsDB.LibPath;
end;

function TDBConexaoFireDAC.Rollback: IDBConexao;
begin
  Result := Self;

  if FConexao.InTransaction then
    FConexao.Rollback;
end;

function TDBConexaoFireDAC.StartTransaction: IDBConexao;
begin
  Result := Self;

  FConexao.Connected := False;
  FConexao.Connected := True;

  FConexao.StartTransaction;
end;

function TDBConexaoFireDAC.Paginate(aPage, aLimit: Integer): string;
var
  lRows,
  lTo: Integer;
begin
  Result := '';

  if (aPage > 0) then
  begin
    if (aLimit <= 0) then
      aLimit := 50;

    lRows := aPage;
    lTo := aLimit;

    if (aPage > 1) then
    begin
      lRows := (aLimit * (aPage - 1));
      lTo := (lRows + aLimit);
      Inc(lRows);
    end;

    Result := Format('ROWS %d TO %d', [lRows, lTo]);
    // mssql order by []  OFFSET 50 ROWS  FETCH NEXT 50 ROWS ONLY;
    // sqlite limit 3 offset 6
    // Postgres order by bloquetoid limit 10 offset 10;
  end;
end;

end.
