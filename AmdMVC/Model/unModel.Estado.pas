////////////////////////////////////////////////////////////////////////////////
// Classe de dados : MVC-Model.Pais
// Templarium      : 2.0.0.00
// Data de Geração : 2023/01/16 - 12:00:01
////////////////////////////////////////////////////////////////////////////////

unit unModel.Estado;

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
  db, unCommon.SmartPointerClass, unModel.Base, unCommon.Tools, j4dl, unClassRegister;

type

  TLocalEstado = class(TEntidadeDB)
  private
    fEstadoID: integer;
    fNome: string;
    fSigla: string;
    fPaisID: integer;
    fNomePais: string;
  public
    property EstadoID: integer read fEstadoID write fEstadoID;
    property Nome: string read fNome write fNome;
    property Sigla: string read fSigla write fSigla;
    property PaisID: integer read fPaisID write fPaisID;
    property NomePais: string read fNomePais write fNomePais;
    constructor Create; override; //(sFullCreate: boolean = True);
    destructor Destroy; override;
    class function New: IEntidadeDB;
    Procedure SetValues(sEstadoID: integer; sNome: string; sSigla: string; sPaisID: integer; sNomePais: string);
    Function GetJsonPostPut(sPost:Boolean):string;  override; // CLIENT SIDE
   end;

implementation

{ TLocalEstado }

constructor TLocalEstado.Create; //(sFullCreate: boolean);
begin
  //if sFullCreate then
  begin
    Nome       := 'Estado';
    NomeRecurso:= 'Estado';
    Descricao  := 'Estado';
    TbSelect   := 'vLocalEstado';  // SERVER SIDE
    TbInsert   := 'LocalEstado';   // SERVER SIDE
    AutoInc    := True;
    AtributoSmartP.Value.Add('Código', GetRAtributo('EstadoID', 'Código', ftInteger, 9, 0, True, True, True, True, True));
    AtributoSmartP.Value.Add('Nome', GetRAtributo('Nome', 'Nome', ftString, 30, 0, False, True, True, True, True));
    AtributoSmartP.Value.Add('Sigla', GetRAtributo('Sigla', 'Sigla', ftString, 5, 0, False, False, True, True, True));
    AtributoSmartP.Value.Add('PaisID', GetRAtributo('PaisID', 'PaisID', ftInteger, 9, 0, False, False, False, True, True));
    AtributoSmartP.Value.Add('Pais', GetRAtributo('NomePais', 'Pais', ftString, 30, 0, False, False, False, True, False));
    AtributoSmartP.Value.TrimExcess;
  end;
  EstadoID:= 0;
  Nome:= '';
  Sigla:= '';
  PaisID:= 0;
  NomePais:= '';
end;

destructor TLocalEstado.Destroy;
begin
  inherited;
end;

class function TLocalEstado.New: IEntidadeDB;
begin
  Result := Self.Create();
end;

Function TLocalEstado.GetJsonPostPut(sPost:Boolean):string;  // CLIENT SIDE
var FJson: TJsonObject;
begin
  Result := '{}';
  FJson := TJsonObject.Create();
  try
  if sPost then
    FJson.Put('EstadoID', 0)
  else FJson.Put('EstadoID', EstadoID);
    FJson.Put('Nome', Nome);
  FJson.Put('Sigla', Sigla);
  FJson.Put('PaisID', PaisID);
  Result := FJson.Stringify;
  finally
    FJson.Free;
  end;
end;

Procedure TLocalEstado.SetValues(sEstadoID: integer; sNome: string; sSigla: string; sPaisID: integer; sNomePais: string);
begin
  EstadoID:= sEstadoID;
  Nome:= sNome;
  Sigla:= sSigla;
  PaisID:= sPaisID;
  NomePais:= sNomePais;
end;

initialization
  TClassRegister.RegisterClass(TLocalEstado);


end.
