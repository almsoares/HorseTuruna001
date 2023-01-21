unit Unit1;

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
  db, Winapi.Windows, Winapi.Messages, System.Variants, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons,

  unCommon.SmartPointerClass, unModel.Base, unDAO.Base,
  unModel.Pais, unModel.Estado, unClassRegister,
  Vcl.StdCtrls;

type

//  TCustomClassEntidadeDB = class of TEntidadeDB;

  TForm1 = class(TForm)
    spbDicionario: TSpeedButton;
    SQLRecEntidadeDB: TMemo;
    btnTesteRecord: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure spbDicionarioClick(Sender: TObject);
    procedure btnTesteRecordClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses unCommon.Tools;

{$R *.dfm}

procedure TForm1.btnTesteRecordClick(Sender: TObject);
begin
  (*
  with RecLocalEstado do
  begin
    EstadoID:= 1;
    Nome:= 'Minas Gerais';
    Sigla:= 'MG';
    PaisID:= 1;
    NomePais:= 'Brasil';
  end;
  RLocalEstadoOri:= RecLocalEstado;

  RLocalEstadoOri.PaisID:= 2;

  SQLRecEntidadeDB.Lines.Add(GetJsonPostPutLocalEstado(True, RecLocalEstado));

  if CompareMem(@RecLocalEstado, @RLocalEstadoOri, SizeOf(TRLocalEstado)) then
    TTools.MostraMensagem('Informação','Idêntico')
  else //TTools.MostraMensagem('Informação','Diferente');
     SQLRecEntidadeDB.Lines.Add(GetJsonPostPutLocalEstado(False, RecLocalEstado));
  *)
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //RLocalPais.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  //RegistraLocalPais;
//  RegistraLocalEstado;
  //TClassRegister.RegisterClass(TLocalPais);
end;

procedure TForm1.spbDicionarioClick(Sender: TObject);
var
  //aClassType: TInterfacedClass;
  ClassEntidadeDB: TCustomClassEntidadeDB;
  EntidadeDBClass: IEntidadeDB;

  countclass: integer;

begin
  SQLRecEntidadeDB.Lines.Clear;

  //aClassType := TClassRegister.GetClass('TLocalPais1');
  ClassEntidadeDB:= TCustomClassEntidadeDB(TClassRegister.GetClass('TLocalPais1'));
  if ClassEntidadeDB=nil then
    SQLRecEntidadeDB.Lines.Add('GetClass - not found');

  for countclass:= 0 to Pred(TClassRegister.Count) do
  begin
    ClassEntidadeDB:= TCustomClassEntidadeDB(TClassRegister.GetClass(countclass));
    if ClassEntidadeDB<>nil then
    begin
      EntidadeDBClass:= ClassEntidadeDB.Create;
      try
        SQLRecEntidadeDB.Lines.Add('GetClass -' + EntidadeDBClass.GetClassName + ' found');
        SQLRecEntidadeDB.Lines.Add('///////////////////////////////');
        SQLRecEntidadeDB.Lines.Add(GetSelect(EntidadeDBClass, True, false));
        SQLRecEntidadeDB.Lines.Add(GetSelect(EntidadeDBClass, False, false));
        SQLRecEntidadeDB.Lines.Add(GetSelect(EntidadeDBClass, True, True));
        SQLRecEntidadeDB.Lines.Add(GetSelect(EntidadeDBClass, false, True));
        SQLRecEntidadeDB.Lines.Add('---------------------');
        SQLRecEntidadeDB.Lines.Add(GetInsert(EntidadeDBClass));
        SQLRecEntidadeDB.Lines.Add('---------------------');
        SQLRecEntidadeDB.Lines.Add(GetUpdate(EntidadeDBClass));
        SQLRecEntidadeDB.Lines.Add('===============================================================');
        SQLRecEntidadeDB.Lines.Add('');
        (*
        // CLIENTE
        TLocalPais(EntidadeDBClass).SetValues(1,'TESTE NOME');
        SQLRecEntidadeDB.Lines.Add(EntidadeDBClass.GetJsonPostPut(True));
        TLocalPais(EntidadeDBClass).SetValues(1,'TESTE NOME 2');
        SQLRecEntidadeDB.Lines.Add(EntidadeDBClass.GetJsonPostPut(False));
        SQLRecEntidadeDB.Lines.Add('---------------------');

        // CLIENTE
        TLocalEstado(EntidadeDBClass).SetValues(1,'TESTE NOME', 'TN', 0, 'PAISTN');
        SQLRecEntidadeDB.Lines.Add(EntidadeDBClass.GetJsonPostPut(True));
        TLocalEstado(EntidadeDBClass).SetValues(1,'TESTE NOME 2', 'TN2', 1, 'PAISTN2');
        SQLRecEntidadeDB.Lines.Add(EntidadeDBClass.GetJsonPostPut(False));
        SQLRecEntidadeDB.Lines.Add('---------------------');
        *)
      finally //except
        //FreeAndNil(EntidadeDBClass);
        EntidadeDBClass:= Nil;
      end;
    end;
  end;
  (*
  ClassEntidadeDB:= TCustomClassEntidadeDB(TClassRegister.GetClass('TLocalEstado'));
  if ClassEntidadeDB<>nil then
  begin
    EntidadeDBClass:= ClassEntidadeDB.Create;
    try
      SQLRecEntidadeDB.Lines.Add('GetClass -' + EntidadeDBClass.GetClassName + ' found');
      SQLRecEntidadeDB.Lines.Add('=====================');

      //SERVIDOR
      SQLRecEntidadeDB.Lines.Add(GetSelect(EntidadeDBClass, True, false));
      SQLRecEntidadeDB.Lines.Add(GetSelect(EntidadeDBClass, False, false));
      SQLRecEntidadeDB.Lines.Add(GetSelect(EntidadeDBClass, True, True));
      SQLRecEntidadeDB.Lines.Add(GetSelect(EntidadeDBClass, false, True));
      SQLRecEntidadeDB.Lines.Add('---------------------');
      SQLRecEntidadeDB.Lines.Add(GetInsert(EntidadeDBClass));
      SQLRecEntidadeDB.Lines.Add('---------------------');
      SQLRecEntidadeDB.Lines.Add(GetUpdate(EntidadeDBClass));
      SQLRecEntidadeDB.Lines.Add('---------------------');

      // CLIENTE
      TLocalEstado(EntidadeDBClass).SetValues(1,'TESTE NOME', 'TN', 0, 'PAISTN');
      SQLRecEntidadeDB.Lines.Add(EntidadeDBClass.GetJsonPostPut(True));
      TLocalEstado(EntidadeDBClass).SetValues(1,'TESTE NOME 2', 'TN2', 1, 'PAISTN2');
      SQLRecEntidadeDB.Lines.Add(EntidadeDBClass.GetJsonPostPut(False));
      SQLRecEntidadeDB.Lines.Add('---------------------');

    finally //except
      //FreeAndNil(EntidadeDBClass);
      EntidadeDBClass:= Nil;
    end;
  end;
  *)
//  TTools.MostraMensagem('Informação','SQLs gerados')
end;

end.
