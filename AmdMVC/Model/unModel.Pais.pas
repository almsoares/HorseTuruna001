////////////////////////////////////////////////////////////////////////////////
// Classe de dados : MVC-Model.Pais
// Templarium      : 2.0.0.00
// Data de Geração : 2023/01/16 - 12:00:01
////////////////////////////////////////////////////////////////////////////////

unit unModel.Pais;

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
  db, unCommon.SmartPointerClass, unModel.Base, j4dl, unClassRegister;

type
  TLocalPais = class(TEntidadeDB)
  private
  public
    PaisID: integer;
    Nome: string;
    constructor Create; override; //(sFullCreate: boolean = True);
    destructor Destroy; override;
    class function New: IEntidadeDB;
    Function GetJsonPostPut(sPost:Boolean):string; override;
    Procedure SetValues(sPaisID: integer; sNome: string);
  end;

implementation

{ TLocalPais }

constructor TLocalPais.Create;//(sFullCreate: boolean);
begin
  //inherited;
  //if sFullCreate then
  begin
    Nome       := 'Pais';
    NomeRecurso:= 'pais';
    Descricao  := 'País';
    TbSelect   := 'LocalPais';
    TbInsert   := 'LocalPais';
    AutoInc    := True;
    AtributoSmartP.Value.Add('Código', GetRAtributo('PaisID', 'Código', ftInteger, 9, 0, True, True, True, True, True));
    AtributoSmartP.Value.Add('Nome', GetRAtributo('Nome', 'Nome', ftString, 50, 0, False, True, True, True, True));
    //fAtributoSmartP.Value.Add('Status', GetRAtributo('Apagado', 'Apagado', ftInteger, 1, 0, False, False, False, False, False));
    AtributoSmartP.Value.TrimExcess;
  end;
  PaisID:= 0;
  Nome:= '';
end;

destructor TLocalPais.Destroy;
begin
  inherited;
end;

class function TLocalPais.New: IEntidadeDB;
begin
  //inherited;
  Result := Self.Create;
end;

Function TLocalPais.GetJsonPostPut(sPost:Boolean):string;
var FJson: TJsonObject;
begin
  Result := '{}';
  FJson := TJsonObject.Create();
  try
  if sPost then
    FJson.Put('PaisID', 0)
  else FJson.Put('PaisID', PaisID);
    FJson.Put('Nome', Nome);
  Result := FJson.Stringify;
  finally
    FJson.Free;
  end;
end;

Procedure TLocalPais.SetValues(sPaisID: integer; sNome: string);
begin
  PaisID:= sPaisID;
  Nome:= sNome;
end;

initialization
  TClassRegister.RegisterClass(TLocalPais);

end.
