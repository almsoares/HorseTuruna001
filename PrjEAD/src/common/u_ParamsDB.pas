unit u_ParamsDB;

{$ifdef fpc}
  {$mode delphi}
{$endif}

interface

uses
  {$ifdef fpc}
  Classes, SysUtils, IniFiles;
  {$else}
  System.Classes, System.SysUtils, IniFiles;
  {$endif}

type
  TTipoSgdb = (tsFB, tsPG, tsMySQL, tsMSSQL, tsSQLite);

  IParamsDB = interface
    ['{86BED295-66A1-44BE-8845-F4F9295CD3A6}']
    function ReadIni: IParamsDB;
    function WriteIni: IParamsDB;
    ////
    function DriveID: string;
    function Protocol: string;
    function HostName: string; overload;
    function HostName(Value: string): IParamsDB; overload;
    function Port: integer; overload;
    function PortStr: string;
    function Port(Value: integer): IParamsDB; overload;
    function Database: string; overload;
    function Database(Value: string): IParamsDB; overload;
    function User: string; overload;
    function User(Value: string): IParamsDB; overload;
    function Password: string; overload;
    function Password(Value: string): IParamsDB; overload;
    function ClientCodepage: string; overload;
    function ClientCodepage(Value: string): IParamsDB; overload;
    function LibPath: string; overload;
    function LibPath(Value: string): IParamsDB; overload;
  end;

  TParamsDB = class(TInterfacedObject, IParamsDB)
  private
    FIniFile: string;
    FTipoSgdb: TTipoSgdb;
    FHostName: string;
    FPort: Integer;
    Fdatabase: string;
    FUserName: string;
    FPassword: string;
    FClientCodepage: string;
    FLibPath: string;
    function GetIniFile: string;
  public
    constructor Create(aTipoSgdb: TTipoSgdb);
    destructor Destroy; override;
    class function New(aTipoSgdb: TTipoSgdb): IParamsDB;

    function ReadIni: IParamsDB;
    function WriteIni: IParamsDB;

    function DriveID: string;
    function Protocol: string;
    function HostName: string; overload;
    function HostName(Value: string): IParamsDB; overload;
    function Port: integer; overload;
    function PortStr: string;
    function Port(Value: integer): IParamsDB; overload;
    function Database: string; overload;
    function Database(Value: string): IParamsDB; overload;
    function User: string; overload;
    function User(Value: string): IParamsDB; overload;
    function Password: string; overload;
    function Password(Value: string): IParamsDB; overload;
    function ClientCodepage: string; overload;
    function ClientCodepage(Value: string): IParamsDB; overload;
    function LibPath: string; overload;
    function LibPath(Value: string): IParamsDB; overload;
  end;

implementation

const
  _SECAO = 'secaodb';

{ TParamsDB }

function TParamsDB.ClientCodepage: string;
begin
  Result := FClientCodepage;
end;

function TParamsDB.ClientCodepage(Value: string): IParamsDB;
begin
  Result := Self;
  FClientCodepage := Value;
end;

constructor TParamsDB.Create(aTipoSgdb: TTipoSgdb);
begin
  FTipoSgdb := aTipoSgdb;
  FHostName := '127.0.0.1';
  FPort     := 3050;
  FUserName := 'SYSDBA';

  ReadIni();
end;

function TParamsDB.Database(Value: string): IParamsDB;
begin
  Result := Self;
  Fdatabase := Value;
end;

function TParamsDB.Database: string;
begin
  Result := Fdatabase;
end;

destructor TParamsDB.Destroy;
begin

  inherited;
end;

function TParamsDB.DriveID: string;
begin
  case FTipoSgdb of
    tsFB    : Result := 'FB';
    tsPG    : Result := 'PG';
    tsMySQL : Result := 'MySQL';
    tsMSSQL : Result := 'MSSQL';
    tsSQLite: Result := 'SQLite';
  end;
end;

function TParamsDB.GetIniFile: string;
begin
  if (FIniFile.Trim.IsEmpty) then
    FIniFile := ChangeFileExt(ExtractFileName(ParamStr(0)), '.ini');

  Result := ExtractFilePath(ParamStr(0)) + FIniFile;
end;

function TParamsDB.HostName(Value: string): IParamsDB;
begin
  Result := Self;
  FHostName := Value;
end;

function TParamsDB.HostName: string;
begin
  Result := FHostName;
end;

function TParamsDB.LibPath(Value: string): IParamsDB;
begin
  Result := Self;
  FLibPath := Value;
end;

function TParamsDB.LibPath: string;
begin
  Result := FLibPath;
end;

class function TParamsDB.New(aTipoSgdb: TTipoSgdb): IParamsDB;
begin
  Result := Self.Create(aTipoSgdb);
end;

function TParamsDB.Password: string;
begin
  Result := FPassword;
end;

function TParamsDB.Password(Value: string): IParamsDB;
begin
  Result := Self;
  FPassword := Value;
end;

function TParamsDB.Port: integer;
begin
  Result := FPort;
end;

function TParamsDB.Port(Value: integer): IParamsDB;
begin
  Result := Self;
  FPort := Value;
end;

function TParamsDB.PortStr: string;
begin
  Result := FPort.ToString;
end;

function TParamsDB.Protocol: string;
begin
  case FTipoSgdb of
    tsFB    : Result := 'firebird';
    tsPG    : Result := 'postgresql';
    tsMySQL : Result := 'mysql';
    tsMSSQL : Result := 'mssql';
    tsSQLite: Result := 'sqlite';
  end;
end;

function TParamsDB.ReadIni: IParamsDB;
var
  lIni: TIniFile;
begin
  Result := Self;

  if not FileExists( GetIniFile ) then
    WriteIni();

  lIni := TIniFile.Create( GetIniFile() );
  try
    FTipoSgdb       := TTipoSgdb(lIni.ReadInteger(_SECAO, 'sgdb', 0));
    FHostName       := lIni.ReadString(_SECAO, 'host', '');
    FPort           := lIni.ReadInteger(_SECAO, 'port', 0);
    Fdatabase       := lIni.ReadString(_SECAO, 'database', '');
    FUserName       := lIni.ReadString(_SECAO, 'user', '');
    FPassword       := lIni.ReadString(_SECAO, 'pass', '');
    FClientCodepage := lIni.ReadString(_SECAO, 'page', '');
    FLibPath        := lIni.ReadString(_SECAO, 'path', '');
  finally
    FreeAndNil(lIni);
  end;
end;

function TParamsDB.User(Value: string): IParamsDB;
begin
  Result := Self;
  FUserName := Value;
end;

function TParamsDB.User: string;
begin
  Result := FUserName;
end;

function TParamsDB.WriteIni: IParamsDB;
var
  lIni: TIniFile;
begin
  Result := Self;

  lIni := TIniFile.Create( GetIniFile() );
  try
    lIni.WriteInteger(_SECAO, 'sgdb',     Ord(FTipoSgdb));
    lIni.WriteString (_SECAO, 'host',     FHostName);
    lIni.WriteInteger(_SECAO, 'port',     FPort);
    lIni.WriteString (_SECAO, 'database', Fdatabase);
    lIni.WriteString (_SECAO, 'user',     FUserName);
    lIni.WriteString (_SECAO, 'pass',     FPassword);
    lIni.WriteString (_SECAO, 'page',     FClientCodepage);
    lIni.WriteString (_SECAO, 'path',     FLibPath);
  finally
    FreeAndNil(lIni);
  end;
end;

end.
