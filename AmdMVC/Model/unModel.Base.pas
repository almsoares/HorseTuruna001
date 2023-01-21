////////////////////////////////////////////////////////////////////////////////
// Classe de dados : MVC-Model.Base
// Templarium      : 2.0.0.00
// Data de Geração : 2023/01/16 - 12:00:01
////////////////////////////////////////////////////////////////////////////////

unit unModel.Base;

{$ifdef fpc}
  {$mode delphi}
{$endif}

interface

uses
  {$ifdef fpc}
  Classes, SysUtils,  Generics.Collections,
  {$else}
  System.Classes, System.SysUtils, Generics.Collections,
  {$endif}
  db, unCommon.SmartPointerClass;

type

  RAtributo = record
    Nome: string;       // Nome no Banco de Dados
    Descricao: string;  // Descrição para uso no MVC-VIEW (formulário/relatório)
    Tipo: TFieldType;
    Size: integer;
    Precision: integer;
    PK: Boolean;
    NNull: Boolean;
    SQLSelList: Boolean;
    SQLSel: Boolean;
    SQLIns: Boolean;
  end;

  TDicAtributo = TDictionary<string, RAtributo>;

  IEntidadeDB = interface
    ['{F9030148-6734-4B56-87DF-113F37E5552F}']

    Function GetRAtributo(sNome, sDescricao: string; sTipo: TFieldType;
      sSize, sPrecision: integer; sPk, sNNull, sSQLSelList, sSQLSel,
      sSQLIns: Boolean):RAtributo;

    function GetAtributoSmartP: TSmartPointer<TDicAtributo>;
    function GetTbSelect: string;
    function GetTbInsert: string;
    function PkAutoInc: Boolean;
    Function GetJsonPostPut(sPost:Boolean):string;
    Function GetClassName:string;
  end;

  TCustomClassEntidadeDB = class of TEntidadeDB;

  TEntidadeDB = class(TInterfacedObject, IEntidadeDB)
  //TEntidadeDB = class(TInterfacedPersistent, IEntidadeDB)
  private
    fNome       : string;  // Nome da entidade
    fNomeRecurso: string;  // Nome de chamada do Recurso/Endpoint
    fDescricao  : string;  // Descrição da entidade para uso no MVC-VIEW (formulário/relatório)
    fAutoInc    : boolean; // Pk é autoincremento

    fTbSelect   : string;  // SERVER SIDE - Nome da tabela/view/storeprocedure do SELECT no Banco de Dados
    fTbInsert   : string;  // SERVER SIDE - Nome da tabela do INSERT/UPDATE/DELETE no Banco de Dados

    fAtributoSmartP: TSmartPointer<TDicAtributo>; // Lista de objetos de identificação dos atributos

  public
    property Nome: string read fNome write fNome;
    property NomeRecurso: string read fNomeRecurso write fNomeRecurso;
    property Descricao: string read fDescricao write fDescricao;
    property AutoInc: boolean read fAutoInc write fAutoInc;

    property TbSelect: string read fTbSelect write fTbSelect; // SERVER SIDE
    property TbInsert: string read fTbInsert write fTbInsert; // SERVER SIDE

    property AtributoSmartP: TSmartPointer<TDicAtributo> read fAtributoSmartP write fAtributoSmartP;

    constructor Create; virtual;
    destructor Destroy; override;
    class function New: IEntidadeDB;

    Function GetRAtributo(sNome, sDescricao: string; sTipo: TFieldType;
      sSize, sPrecision: integer; sPk, sNNull, sSQLSelList, sSQLSel,
      sSQLIns: Boolean): RAtributo;

    function GetAtributoSmartP: TSmartPointer<TDicAtributo>;
    function GetTbSelect: string;  // SERVER SIDE
    function GetTbInsert: string;  // SERVER SIDE
    function PkAutoInc: Boolean;
    Function GetJsonPostPut(sPost:Boolean):string; virtual; // CLIENT SIDE
    Function GetClassName:string;

  end;

implementation

{ TEntidadeDB }
constructor TEntidadeDB.Create;
begin
  //
end;

destructor TEntidadeDB.Destroy;
begin
  //
  inherited;
end;

class function TEntidadeDB.New: IEntidadeDB;
begin
  Result := Self.Create;
end;

function TEntidadeDB.PkAutoInc: Boolean;
begin
  result:= AutoInc;
end;

function TEntidadeDB.GetAtributoSmartP: TSmartPointer<TDicAtributo>;
begin
  result:= AtributoSmartP;
end;

function TEntidadeDB.GetClassName: string;
begin
  result:= Self.ClassName;
end;

function TEntidadeDB.GetRAtributo(sNome, sDescricao: string; sTipo: TFieldType;
  sSize, sPrecision: integer; sPk, sNNull, sSQLSelList, sSQLSel,
  sSQLIns: Boolean): RAtributo;
var RecAtributo: RAtributo;
begin
  FillChar(RecAtributo,Sizeof(RecAtributo),0);
  with RecAtributo do
  begin
    Nome:= sNome;
    Descricao:= sDescricao;
    Tipo:= sTipo;
    Size:= sSize;
    Precision:= sPrecision;
    PK:= sPK;
    NNull:= sNNull;
    SQLSelList:= sSQLSelList;
    SQLSel:= sSQLSel;
    SQLIns:= sSQLIns;
  end;
  Result:= RecAtributo;
end;

function TEntidadeDB.GetTbInsert: string;
begin
  result:= TbInsert;
end;

function TEntidadeDB.GetTbSelect: string;
begin
  result:= TbSelect;
end;

function TEntidadeDB.GetJsonPostPut(sPost: Boolean): string;  // CLIENT SIDE
begin
  result:= '';
end;


end.
