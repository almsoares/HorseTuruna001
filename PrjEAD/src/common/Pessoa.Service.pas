unit Pessoa.Service;

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
  DBConexao.Contrato, j4dl, dc4dl, Service.Contrato, Json.Result;

type
  TPessoaService = class(TInterfacedObject, IPessoaService)
  private
    FDBCon: IDBConexao;
    function IsExist(aID, aCpfCnpj: string): Boolean;
    function Insert(aJson: TJsonObject): string;
    function Update(aJson: TJsonObject): string;
  public
    constructor Create;
    destructor Destroy; override;
    class Function New: IPessoaService;

    function Load(aID, aCpfCnpj, aNomeRazao, aApelidoFantasia: string; aPage: Integer = 0; aLimit: Integer = 0): string;
    function Save(aID: string; aJson: string): string;
    function Delete(aID: string): string;
  end;

implementation

{ TPessoaService }

uses u_Tools, Pessoa.Endereco.Service, Pessoa.Foto.Service,
  Pessoa.Contato.Service, FireDAC.Stan.Intf;

constructor TPessoaService.Create;
begin
  FDBCon := {$ifdef fpc}TDBConexaoZeos{$else}TDBConexaoFireDAC{$endif}.New;
end;

function TPessoaService.Delete(aID: string): string;
var
  lQry: {$ifdef fpc}TZQuery{$else}TFDQuery{$endif};
begin
  try
    if not IsExist(aID, '') then
    begin
      Result := TJsonResult.New(False)
                           .Statuscode(000)
                           .Message('Pessoa not found!')
                           .ToString;
      Exit;
    end;

    lQry := {$ifdef fpc}TZQuery({$else}TFDQuery({$endif}FDBCon.GetQuery);
    try
      lQry.Close;
      lQry.SQL.Clear;
      lQry.SQL.Add('UPDATE pessoa             ');
      lQry.SQL.Add('   SET deleted = :deleted ');
      lQry.SQL.Add(' WHERE id = :id           ');

      lQry.ParamByName('id').AsString       := aID;
      lQry.ParamByName('deleted').AsInteger := 1;

      lQry.ExecSQL;

      Result := TJsonResult.New()
                           .Message('Registro deletado com sucesso.')
                           .ToString;
    finally
      FreeAndNil(lQry);
    end;
  except
    on E: exception do
      Result := TJsonResult.New(False)
                           .Statuscode(500)
                           .Message(E.Message)
                           .ToString;
  end;
end;

destructor TPessoaService.Destroy;
begin

  inherited;
end;

function TPessoaService.Insert(aJson: TJsonObject): string;
var
  lQry: {$ifdef fpc}TZQuery{$else}TFDQuery{$endif};
  lID: string;
begin
  try
    lQry := {$ifdef fpc}TZQuery({$else}TFDQuery({$endif}FDBCon.GetQuery);
    try
      lQry.Close;
      lQry.SQL.Clear;
      lQry.SQL.Add('INSERT INTO pessoa                                            ');
      lQry.SQL.Add('(id, tipo_pessoa, cpf_cnpj, nome_razao, apelido_fantasia)     ');
      lQry.SQL.Add('VALUES                                                        ');
      lQry.SQL.Add('(:id, :tipo_pessoa, :cpf_cnpj, :nome_razao, :apelido_fantasia)');

      lId := FDBCon.GenGUID;
      lQry.ParamByName('id').AsString               := lID;
      lQry.ParamByName('tipo_pessoa').AsString      := TTools.SetTipoPessoa(aJson.Values['cpf_cnpj'].AsString);
      lQry.ParamByName('cpf_cnpj').AsString         := TTools.RemoveCaracterEspecial(aJson.Values['cpf_cnpj'].AsString);
      lQry.ParamByName('nome_razao').AsString       := aJson.Values['nome_razao'].AsString;
      lQry.ParamByName('apelido_fantasia').AsString := aJson.Values['apelido_fantasia'].AsString;

      //Abre uma Transação
      FDBCon.StartTransaction;

      //Processa Pessoa
      lQry.ExecSQL;

      //Processa Pessoa Foto
      TPessoaFotoService.New(FDBCon)
                        .Insert(lID, aJson.Values['foto'].AsObject);

      //Processar Pessoa Contatos
      TPessoaContatoService.New(FDBCon)
                           .Insert(lID, aJson.Values['contatos'].AsArray);

      //Processar Pessoa Endereços
      TPessoaEnderecoService.New(FDBCon)
                            .Insert(lID, aJson.Values['enderecos'].AsArray);

      //Comita a Transação
      FDBCon.Commit;

      Result := TJsonResult.New()
                           .Statuscode(201)
                           .Message('Registro incluido com sucesso.')
                           .Data( Load(lID, '', '', '') )
                           .ToString;

    finally
      FreeAndNil(lQry);
    end;
  except
    on E: exception do
    begin
      //Cancela Transação
      FDBCon.Rollback;
      Result := TJsonResult.New(False)
                           .Statuscode(500)
                           .Message(E.Message)
                           .ToString;
    end;
  end;
end;

function TPessoaService.IsExist(aID, aCpfCnpj: string): Boolean;
var
  lQry: {$ifdef fpc}TZQuery{$else}TFDQuery{$endif};
begin
  try
    lQry := {$ifdef fpc}TZQuery({$else}TFDQuery({$endif}FDBCon.GetQuery);
    try
      lQry.Close;
      lQry.SQL.Clear;
      lQry.SQL.Add('SELECT id     ');
      lQry.SQL.Add('  FROM pessoa ');
      lQry.SQL.Add(' WHERE 1=1    ');

      if not aID.Trim.IsEmpty then
      begin
        lQry.SQL.Add('AND deleted = 0 ');
        lQry.SQL.Add('AND id = :id ');
        lQry.ParamByName('id').AsString := aID;
      end
      else if not aCpfCnpj.Trim.IsEmpty then
      begin
        lQry.SQL.Add('AND cpf_cnpj = :cpf_cnpj ');
        lQry.ParamByName('cpf_cnpj').AsString := TTools.RemoveCaracterEspecial(aCpfCnpj);
      end
      else
        raise Exception.Create('Params not found!');

      lQry.Open;
      Result := not lQry.IsEmpty;
    finally
      lQry.Close;
      FreeAndNil(lQry);
    end;
  except
    on E: exception do
      raise Exception.Create(E.Message);
  end;
end;

function TPessoaService.Load(aID, aCpfCnpj, aNomeRazao, aApelidoFantasia: string; aPage: Integer = 0; aLimit: Integer = 0): string;
var
  lQry: {$ifdef fpc}TZQuery{$else}TFDQuery{$endif};
  lJsonObject: TJsonObject;
  lJsonArray: TJsonArray;
  I: Integer;
begin
  try
    lQry := {$ifdef fpc}TZQuery({$else}TFDQuery({$endif}FDBCon.GetQuery);
    try
      lQry.Close;
      lQry.SQL.Clear;
      lQry.SQL.Add('SELECT id               ');
      lQry.SQL.Add('      ,tipo_pessoa      ');
      lQry.SQL.Add('      ,cpf_cnpj         ');
      lQry.SQL.Add('      ,nome_razao       ');
      lQry.SQL.Add('      ,apelido_fantasia ');
      lQry.SQL.Add('      ,ativo            ');
      lQry.SQL.Add('  FROM pessoa           ');
      lQry.SQL.Add(' WHERE deleted = 0      ');

      if not aID.Trim.IsEmpty then
      begin
        lQry.SQL.Add('AND id = :id ');
        lQry.ParamByName('id').AsString := aID;
      end;

      if not aCpfCnpj.Trim.IsEmpty then
      begin
        lQry.SQL.Add('AND cpf_cnpj = :cpf_cnpj ');
        lQry.ParamByName('cpf_cnpj').AsString := TTools.RemoveCaracterEspecial(aCpfCnpj);
      end;

      if not aNomeRazao.Trim.IsEmpty then
      begin
        if aNomeRazao.Contains('*') then
          aNomeRazao := StringReplace(aNomeRazao, '*', '%', [rfReplaceAll]);

        lQry.SQL.Add('AND LOWER(nome_razao) like :nome_razao');
        lQry.ParamByName('nome_razao').AsString := aNomeRazao.ToLower;
      end;

      if not aApelidoFantasia.Trim.IsEmpty then
      begin
        if aApelidoFantasia.Contains('*') then
          aApelidoFantasia := StringReplace(aApelidoFantasia, '*', '%', [rfReplaceAll]);

        lQry.SQL.Add('AND LOWER(apelido_fantasia) like :apelido_fantasia');
        lQry.ParamByName('apelido_fantasia').AsString := aApelidoFantasia.ToLower;
      end;

      lQry.SQL.Add(FDBCOn.Paginate(aPage, aLimit));

      lQry.Open;

      if lQry.IsEmpty then
      begin
        Result := TJsonResult.New(False)
                             .Message('Nenhum registro localizado!')
                             .ToString;
      end
      else
      begin
        lQry.Last;
        lQry.First;

        lJsonObject := Nil;
        lJsonArray := Nil;

        lJsonObject := TJsonObject.Create();
        lJsonArray := TJsonArray.Create();
        try
          while not lQry.EOF do
          begin
            lJsonObject.Clear;

            //1 Forma
            //lJsonObject.Assign( TConverter.New.LoadDataSet(lqry).ToJSONObject );

            //2 Forma
            //lJsonObject.Put('id', lqry.FieldByName('id').AsString);
            //lJsonObject.Put('tipo_pessoa', TTools.GetTipoPessoa(lqry.FieldByName('cpf_cnpj').AsString));
            //lJsonObject.Put('cpf_cnpj', TTools.FormatCepCpfCnpj(lqry.FieldByName('cpf_cnpj').AsString));
            //lJsonObject.Put('nome_razao', lqry.FieldByName('nome_razao').AsString);
            //lJsonObject.Put('apelido_fantasia', lqry.FieldByName('apelido_fantasia').AsString);
            //lJsonObject.Put('ativo', (lqry.FieldByName('ativo').AsInteger = 1));

            //3 Forma
            for I := 0 to Pred(lQry.FieldCount) do
            begin
              if (LowerCase(lQry.Fields[I].FieldName) = 'tipo_pessoa') then
                lJsonObject.Put(LowerCase(lQry.Fields[I].FieldName), TTools.GetTipoPessoa(lqry.FieldByName('cpf_cnpj').AsString))
              else if (LowerCase(lQry.Fields[I].FieldName) = 'cpf_cnpj') then
                lJsonObject.Put(LowerCase(lQry.Fields[I].FieldName), TTools.FormatCepCpfCnpj(lqry.FieldByName('cpf_cnpj').AsString))
              else if (LowerCase(lQry.Fields[I].FieldName) = 'ativo') then
                lJsonObject.Put(LowerCase(lQry.Fields[I].FieldName), (lQry.Fields[I].AsInteger = 1))
              else
                lJsonObject.Put(LowerCase(lQry.Fields[I].FieldName), lQry.Fields[I].AsString);
            end;

            //Pessoa Foto
            TPessoaFotoService.New(FDBCon)
                              .Load(lQry.FieldByName('id').AsString, lJsonObject);

            //Pessoa Contato
            //TPessoaContatoService.New(FDBCon)
            //                     .Load(lQry.FieldByName('id').AsString, lJsonObject);

            //Pessoa Endereco
            //TPessoaEnderecoService.New(FDBCon)
            //                      .Load(lQry.FieldByName('id').AsString, lJsonObject);

            ////////
            lJsonArray.Put(lJsonObject);
            lQry.Next;
          end;

          Result := TJsonResult.New
                               .Data( lJsonArray )
                               .ToString;
        finally
          if Assigned(lJsonObject) then
            FreeAndNil(lJsonObject);
          if Assigned(lJsonArray) then
            FreeAndNil(lJsonArray);
        end;
      end;
    finally
      lQry.Close;
      FreeAndNil(lQry);
    end;
  except
    on E: exception do
      raise Exception.Create(E.Message);
  end;
end;

class function TPessoaService.New: IPessoaService;
begin
  Result := Self.Create;
end;

function TPessoaService.Save(aID: string; aJson: string): string;
var
  lJson: TJsonObject;
begin
  lJson := TJsonObject.Create();
  try
    try
      if aJson.Trim.IsEmpty or not lJson.IsJsonObject(aJson) then
      begin
        Result := TJsonResult.New(False)
                             .Statuscode(000)
                             .Message('JSON Invalid!')
                             .ToString;
        Exit;
      end;

      lJson.Parse(aJson);

      if not aID.Trim.IsEmpty then
      begin
        if not IsExist(aID, '') then
        begin
          Result := TJsonResult.New(False)
                               .Statuscode(000)
                               .Message('Pessoa not found!')
                               .ToString;
          Exit;
        end;

        if (lJson.Find('id') > -1) then
          lJson.Delete('id');

        lJson.Put('id', aID);
        Result := Update(lJson);
      end
      else
      begin
        if IsExist('', lJson.Values['cpf_cnpj'].AsString) then
        begin
          Result := TJsonResult.New(False)
                               .Statuscode(000)
                               .Message('CPF/CNPJ já cadastrado!')
                               .ToString;
          Exit;
        end;

        Result := Insert(lJson);
      end;
    except
      on E: exception do
        Result := TJsonResult.New(False)
                             .Statuscode(500)
                             .Message(E.Message)
                             .ToString;
    end;
  finally
    FreeAndNil(lJson);
  end;
end;

function TPessoaService.Update(aJson: TJsonObject): string;
var
  lQry: {$ifdef fpc}TZQuery{$else}TFDQuery{$endif};
  lID: string;
begin
  try
    lQry := {$ifdef fpc}TZQuery({$else}TFDQuery({$endif}FDBCon.GetQuery);
    try
      lQry.Close;
      lQry.SQL.Clear;
      lQry.SQL.Add('UPDATE pessoa                               ');
      lQry.SQL.Add('   SET tipo_pessoa = :tipo_pessoa           ');
      //lQry.SQL.Add('      ,cpf_cnpj = :cpf_cnpj                 ');
      lQry.SQL.Add('      ,nome_razao = :nome_razao             ');
      lQry.SQL.Add('      ,apelido_fantasia = :apelido_fantasia ');
      lQry.SQL.Add('      ,ativo = :ativo                       ');
      lQry.SQL.Add(' WHERE id = :id                             ');

      lID := aJson.Values['id'].AsString;
      lQry.ParamByName('id').AsString               := lID;
      lQry.ParamByName('tipo_pessoa').AsString      := TTools.SetTipoPessoa(aJson.Values['cpf_cnpj'].AsString);
      //lQry.ParamByName('cpf_cnpj').AsString         := TTools.RemoveCaracterEspecial(aJson.Values['cpf_cnpj'].AsString);
      lQry.ParamByName('nome_razao').AsString       := aJson.Values['nome_razao'].AsString;
      lQry.ParamByName('apelido_fantasia').AsString := aJson.Values['apelido_fantasia'].AsString;
      lQry.ParamByName('ativo').AsInteger           := aJson.Values['ativo'].AsInteger;

      //Processa Pessoa
      lQry.ExecSQL;

      //Processa Pessoa Foto
      TPessoaFotoService.New(FDBCon)
                        .Delete(lID)
                        .Insert(lID, aJson.Values['foto'].AsObject);

      //Processar Pessoa Contatos
      TPessoaContatoService.New(FDBCon)
                           .Delete(lID)
                           .Insert(lID, aJson.Values['contatos'].AsArray);

      //Processar Pessoa Endereços
      TPessoaEnderecoService.New(FDBCon)
                            .Delete(lID)
                            .Insert(lID, aJson.Values['enderecos'].AsArray);

      //Comita a Transação
      FDBCon.Commit;

      Result := TJsonResult.New()
                           .Statuscode(000)
                           .Message('Registro alterado com sucesso.')
                           .Data( Load(lID, '', '', '') )
                           .ToString;
    finally
      FreeAndNil(lQry);
    end;
  except
    on E: exception do
    begin
      //Cancela Transação
      FDBCon.Rollback;
      Result := TJsonResult.New(False)
                           .Statuscode(500)
                           .Message(E.Message)
                           .ToString;
    end;
  end;
end;

end.
