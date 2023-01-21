unit Pessoa.Foto.Service;

{$ifdef fpc}
  {$mode delphi}
{$endif}

interface

uses
  {$ifdef fpc}
  Classes, SysUtils, DB, base64,
  ZConnection, ZDataset, DBConexao.Zeos,
  {$else}
  System.Classes, System.SysUtils, Data.DB, Soap.EncdDecd, System.NetEncoding,
  DBConexao.FireDAC, FireDAC.Comp.Client, FireDAC.Stan.Param,
  {$endif}
  DBConexao.Contrato, j4dl, dc4dl, Service.Contrato, u_Tools;

type
  TPessoaFotoService = class(TInterfacedObject, IPessoaFotoService)
  private
    FDBCon: IDBConexao;
  public
    constructor Create(aDBCon: IDBConexao);
    destructor Destroy; override;
    class Function New(aDBCon: IDBConexao): IPessoaFotoService;

    function Load(aIDPessoa: string; aJson: TJsonObject = nil): IPessoaFotoService;
    function Insert(aIDPessoa: string; aJson: TJsonObject): IPessoaFotoService;
    function Delete(aIDPessoa: string): IPessoaFotoService;
  end;

implementation

{ TPessoaFotoService }

//procedure SetWeak(aInterfaceField: PInterface; const aValue: IInterface);
//begin
//  PPointer(aInterfaceField)^ := Pointer(aValue);
//end;

constructor TPessoaFotoService.Create(aDBCon: IDBConexao);
begin
//  SetWeak(@FDBCon, aDBCon);

  FDBCon := aDBCon;
end;

function TPessoaFotoService.Delete(aIDPessoa: string): IPessoaFotoService;
var
  lQry: {$ifdef fpc}TZQuery{$else}TFDQuery{$endif};
begin
  Result := Self;

  try
    try
      lQry := {$ifdef fpc}TZQuery({$else}TFDQuery({$endif}FDBCon.GetQuery);
      lQry.Close;
      lQry.SQL.Clear;
      lQry.SQL.Add('DELETE FROM pessoa_foto      ');
      lQry.SQL.Add(' WHERE id_pessoa = :id_pessoa');

      lQry.ParamByName('id_pessoa').AsString := aIDPessoa;

      lQry.ExecSQL;
    except
      on E: exception do
        raise Exception.Create(E.Message);
    end;
  finally
    FreeAndNil(lQry);
  end;
end;

destructor TPessoaFotoService.Destroy;
begin

  inherited;
end;

function TPessoaFotoService.Insert(aIDPessoa: string; aJson: TJsonObject): IPessoaFotoService;
var
  lQry: {$ifdef fpc}TZQuery{$else}TFDQuery{$endif};
  lStringStream: TStringStream;
  lMemoryStream: TMemoryStream;
begin
  Result := Self;

  try
    try
      if (aJson.Count > 0) then
      begin
        lQry := {$ifdef fpc}TZQuery({$else}TFDQuery({$endif}FDBCon.GetQuery);
        lQry.Close;
        lQry.SQL.Clear;
        lQry.SQL.Add('INSERT INTO pessoa_foto (id_pessoa, url_foto, blob_foto) ');
        lQry.SQL.Add('VALUES (:id_pessoa, :url_foto, :blob_foto)               ');

        lQry.ParamByName('id_pessoa').AsString := aIDPessoa;
        lQry.ParamByName('url_foto').AsString  := aJson.Values['url_foto'].AsString;

        if (aJson.Values['blob_foto'].AsString <> '') then
        begin
          lStringStream := TStringStream.Create(aJson.Values['blob_foto'].AsString);
          try
            lStringStream.Position := 0;
            {$IFDEF FPC}
            lQry.ParamByName('blob_foto').AsString := DecodeStringBase64(lStringStream.DataString);
            {$ELSE}
            lMemoryStream := TMemoryStream.Create;
            try
              DecodeStream(lStringStream, lMemoryStream);
              lMemoryStream.Position := 0;

              lQry.ParamByName('blob_foto').LoadFromStream(lMemoryStream, ftBlob);
            finally
              lMemoryStream.Free;
            end;
            {$ENDIF}
          finally
            lStringStream.Free;
          end;
        end
        else
          lQry.ParamByName('blob_foto').Clear;

        lQry.ExecSQL;
      end;
    except
      on E: exception do
        raise Exception.Create(E.Message);
    end;
  finally
    FreeAndNil(lQry);
  end;
end;

function TPessoaFotoService.Load(aIDPessoa: string; aJson: TJsonObject): IPessoaFotoService;
var
  lQry: {$ifdef fpc}TZQuery{$else}TFDQuery{$endif};
begin
  Result := Self;
  try
    try
      lQry := {$ifdef fpc}TZQuery({$else}TFDQuery({$endif}FDBCon.GetQuery);

      lQry.Close;
      lQry.SQL.Clear;
      lQry.SQL.Add('SELECT url_foto              ');
      lQry.SQL.Add('      ,blob_foto             ');
      lQry.SQL.Add('  FROM pessoa_foto           ');
      lQry.SQL.Add(' WHERE id_pessoa = :id_pessoa');
      lQry.ParamByName('id_pessoa').AsString := aIDPessoa;

      lQry.Open;
      lQry.Last;
      lQry.First;

      if (aJson <> nil) then
        aJson.Put('foto', TConverter.New.LoadDataset(lQry).ToJsonObject );
    except
      on E: exception do
        raise Exception.Create(E.Message);
    end;
  finally
    FreeAndNil(lQry);
  end;
end;

class Function TPessoaFotoService.New(aDBCon: IDBConexao): IPessoaFotoService;
begin
  Result := Self.Create(aDBCon);
end;

end.
