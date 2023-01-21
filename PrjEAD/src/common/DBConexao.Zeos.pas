unit DBConexao.Zeos;

{$ifdef fpc}
  {$mode delphi}
{$endif}

interface

uses
  {$ifdef fpc}
  Classes, SysUtils,
  {$else}
  System.Classes, System.SysUtils,
  {$endif}
  DBConexao.Contrato, ZConnection, ZDataset, u_BaseInterfacedObject;

type
  TDBConexaoZeos = class(TBaseInterfacedObject, IDBConexao)
  private
    FConexao: TZConnection;
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
  end;

implementation

uses JSON.Result, DBEnv; //, u_ParamsDB;

{ TDBConexaoZeos }

function TDBConexaoZeos.CheckDB: string;
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

function TDBConexaoZeos.Commit: IDBConexao;
begin
  Result := Self;

  if FConexao.InTransaction then
    FConexao.Commit;
end;

function TDBConexaoZeos.Connected: Boolean;
begin
  Result := FConexao.Connected;
end;

function TDBConexaoZeos.Connected(Value: Boolean): IDBConexao;
begin
  Result := Self;

  FConexao.Connected := Value;
end;

constructor TDBConexaoZeos.Create;
begin
  inherited;
  FConexao := TZConnection.Create(nil);
  FConexao.BeforeConnect := OnBeforeConnect;
end;

destructor TDBConexaoZeos.Destroy;
begin
  FConexao.Connected := False;
  FreeAndNil(FConexao);

  inherited;
end;

function TDBConexaoZeos.GetQuery: TComponent;
begin
  Result := TZQuery.Create(nil);
  TZQuery(Result).Connection := FConexao;
end;

function TDBConexaoZeos.InTransaction: Boolean;
begin
  Result := FConexao.InTransaction;
end;

class function TDBConexaoZeos.New: IDBConexao;
begin
  Result := Self.Create;
end;

procedure TDBConexaoZeos.OnBeforeConnect(Sender: TObject);
//var
//  lParamsDB: IParamsDB;
begin
  FConexao.Protocol        := DB_PROTOCOL;
  FConexao.HostName        := DB_HOST;
  FConexao.Port            := DB_PORT;
  FConexao.Database        := DB_DATABASE;
  FConexao.User            := DB_USERNAME;
  FConexao.Password        := DB_PASSWORD;
  FConexao.LibraryLocation := DB_PATH_LIB;
  FConexao.ClientCodepage  := 'ISO8859_1';

//  TParamsDB.New(tsFB)
//           .HostName('localhost')
//           .Port(3050)
//           .Database('')
//           .User('')
//           .Password('')
//           .WriteIni;

//  lParamsDB := TParamsDB.New(tsFB);
//
//  FConexao.Protocol        := lParamsDB.Protocol;
//  FConexao.HostName        := lParamsDB.HostName;
//  FConexao.Port            := lParamsDB.Port;
//  FConexao.Database        := lParamsDB.Database;
//  FConexao.User            := lParamsDB.User;
//  FConexao.Password        := lParamsDB.Password;
//  FConexao.LibraryLocation := lParamsDB.LibPath;
//  FConexao.ClientCodepage  := lParamsDB.ClientCodepage;
end;

function TDBConexaoZeos.Rollback: IDBConexao;
begin
  Result := Self;

  if FConexao.InTransaction then
    FConexao.Rollback;
end;

function TDBConexaoZeos.StartTransaction: IDBConexao;
begin
  Result := Self;

  FConexao.Connected := False;
  FConexao.Connected := True;
  FConexao.StartTransaction;
end;

end.
