unit u_Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Data.DB, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids,
  System.Actions, Vcl.ActnList, System.UITypes, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Datasnap.DBClient;

type
  TTipoOperacao = (toNone, toInsert, toUpdate, toView);
  TTipoMessage = (tpSuccess, tpError);

  TF_Main = class(TForm)
    dbg_Lista: TDBGrid;
    pnl_Base: TPanel;
    pnl_Botao: TPanel;
    btn_Pesquisar: TButton;
    edt_Pesquisa: TEdit;
    btn_Anterior: TSpeedButton;
    btn_Proxima: TSpeedButton;
    lbl_Page: TLabel;
    btn_New: TButton;
    btn_Alterar: TButton;
    btn_Excluir: TButton;
    pnl_Crud: TPanel;
    edt_Descricao: TEdit;
    btn_Salvar: TButton;
    btn_Cancelar: TButton;
    act_Base: TActionList;
    ai_Pesquisar: TAction;
    ai_Anterior: TAction;
    ai_Proxima: TAction;
    ai_Novo: TAction;
    ai_Alterar: TAction;
    ai_Excluir: TAction;
    ai_Salvar: TAction;
    ai_Cancelar: TAction;
    ai_Sair: TAction;
    btn_Sair: TButton;
    Button1: TButton;
    ai_Visualizar: TAction;
    ds_Lista: TDataSource;
    FDMemTable: TFDMemTable;
    edt_ID: TEdit;
    ClientDataSet: TClientDataSet;
    procedure FormCreate(Sender: TObject);
    procedure ai_SairExecute(Sender: TObject);
    procedure ai_PesquisarExecute(Sender: TObject);
    procedure ai_AnteriorExecute(Sender: TObject);
    procedure ai_ProximaExecute(Sender: TObject);
    procedure ai_NovoExecute(Sender: TObject);
    procedure ai_AlterarExecute(Sender: TObject);
    procedure ai_VisualizarExecute(Sender: TObject);
    procedure ai_ExcluirExecute(Sender: TObject);
    procedure ai_SalvarExecute(Sender: TObject);
    procedure ai_CancelarExecute(Sender: TObject);
  private
    FOperacao: TTipoOperacao;
    FPage: Integer;
    procedure Status;
    procedure ExibirMessage(aMessage: string; aTipo: TTipoMessage = tpSuccess);
    procedure GetData;
    procedure ClearEdits;

    procedure OnPesquisar;
    procedure OnDelete;
    function OnSalvar: Boolean;

    procedure CreateFields;
  public
    { Public declarations }
  end;

var
  F_Main: TF_Main;

implementation

uses j4dl, dc4dl, rr4dl;

const
  _LIMIT = 30;
  _URL   = 'http://localhost:9095';

{$R *.dfm}

procedure TF_Main.ai_AlterarExecute(Sender: TObject);
begin
  if ds_Lista.DataSet.Active and not ds_Lista.DataSet.IsEmpty then
  begin
    FOperacao := toUpdate;
    pnl_Botao.Visible := False;
    pnl_Crud.Visible := True;
    GetData;
    if edt_Descricao.CanFocus then
      edt_Descricao.SetFocus;

    Status();
  end;
end;

procedure TF_Main.ai_AnteriorExecute(Sender: TObject);
begin
  Dec(FPage);
  if (FPage < 1) then
    FPage := 1;

  OnPesquisar();
  Status();
end;

procedure TF_Main.ai_CancelarExecute(Sender: TObject);
begin
  FOperacao := toNone;
  pnl_Crud.Visible := False;
  pnl_Botao.Visible := True;
  Status();
  ClearEdits;
end;

procedure TF_Main.ai_ExcluirExecute(Sender: TObject);
begin
  if ds_Lista.DataSet.Active and not ds_Lista.DataSet.IsEmpty then
    if MessageDlg('Tem certeza que desaja excluir o registro selecionado?',
       mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrYes then
      OnDelete();
end;

procedure TF_Main.ai_NovoExecute(Sender: TObject);
begin
  FOperacao := toInsert;
  pnl_Botao.Visible := False;
  pnl_Crud.Visible := True;
  if edt_Descricao.CanFocus then
    edt_Descricao.SetFocus;

  Status();
end;

procedure TF_Main.ai_PesquisarExecute(Sender: TObject);
begin
  OnPesquisar;
end;

procedure TF_Main.ai_ProximaExecute(Sender: TObject);
begin
  Inc(FPage);
  OnPesquisar();
  Status();
end;

procedure TF_Main.ai_SairExecute(Sender: TObject);
begin
  Close;
end;

procedure TF_Main.ai_SalvarExecute(Sender: TObject);
begin
  if OnSalvar then
  begin
    FOperacao := toNone;
    pnl_Crud.Visible := False;
    pnl_Botao.Visible := True;
    Status();
    ClearEdits;
  end;
end;

procedure TF_Main.ai_VisualizarExecute(Sender: TObject);
begin
  if ds_Lista.DataSet.Active and not ds_Lista.DataSet.IsEmpty then
  begin
    FOperacao := toView;
    pnl_Botao.Visible := False;
    pnl_Crud.Visible := True;
    GetData();
    if edt_Descricao.CanFocus then
      edt_Descricao.SetFocus;

    Status();
  end;
end;

procedure TF_Main.ClearEdits;
begin
  edt_ID.Clear;
  edt_Descricao.Clear;
end;

procedure TF_Main.CreateFields;
var
  lID,
  lDescricao: TStringField;
begin
  if (ClientDataSet.Fields.Count = 0) then
  begin
    lID := TStringField.Create(Self);
    lID.FieldName := 'id';
    lID.DisplayLabel := 'ID';
    lID.Size := 45;
    lID.DataSet := ClientDataSet;

    lDescricao := TStringField.Create(Self);
    lDescricao.FieldName := 'descricao';
    lDescricao.DisplayLabel := 'Descrição';
    lDescricao.Size := 50;
    lDescricao.DataSet := ClientDataSet;

    ClientDataSet.CreateDataSet;
  end;

  if (FDMemTable.Fields.Count = 0) then
  begin
    lID := TStringField.Create(Self);
    lID.FieldName := 'id';
    lID.DisplayLabel := 'ID';
    lID.Size := 45;
    lID.DataSet := FDMemTable;

    lDescricao := TStringField.Create(Self);
    lDescricao.FieldName := 'descricao';
    lDescricao.DisplayLabel := 'Descrição';
    lDescricao.Size := 50;
    lDescricao.DataSet := FDMemTable;
  end;

//  if (FDMemTable.FieldDefs.Count = 0) then
//  begin
//    with FDMemTable.FieldDefs do
//    begin
//      with AddFieldDef do
//      begin
//        Name := 'id';
//        DataType := ftString;
//        Size := 45;
//      end;
//
//      with AddFieldDef do
//      begin
//        Name := 'descricao';
//        DataType := ftString;
//        Size := 50;
//      end;
//    end;
//  end;
end;

procedure TF_Main.ExibirMessage(aMessage: string; aTipo: TTipoMessage);
begin
  ShowMessage(aMessage);
  //Self.Caption := aMessage;
end;

procedure TF_Main.FormCreate(Sender: TObject);
begin
  FOperacao := toNone;
  FPage := 1;

  pnl_Crud.Visible := False;
  pnl_Botao.Visible := True;
  pnl_Base.Height := 45;

  CreateFields;
  Status();
end;

procedure TF_Main.GetData;
begin
  edt_ID.Text        := ds_Lista.DataSet.FieldByName('id').AsString;
  edt_Descricao.Text := ds_Lista.DataSet.FieldByName('descricao').AsString;
end;

procedure TF_Main.OnDelete;
var
  lRes: IResponse;
  lEndPoint: string;
  lJson: TJsonObject;
begin
  lEndPoint := Format('%s/tipoendereco/%s',
                      [_URL, ds_Lista.DataSet.FieldByName('id').AsString]);

  lRes := TRequest.New
                  .BaseURL(lEndPoint)
                  .Delete;

  if (lRes.StatusCode = 200) then
  begin
    lJson := TJsonObject.Create();
    try
      if lJson.IsJsonObject(lRes.Content) then
      begin
        lJson.Parse(lRes.Content);
        if lJson.Values['success'].AsBoolean then
        begin
          OnPesquisar();
          ExibirMessage(lJson.Values['message'].AsString, tpSuccess);
        end
        else
          ExibirMessage(lJson.Values['message'].AsString, tpError);
      end
      else
        ExibirMessage('JSON Invalid!', tpError);
    finally
      FreeAndNil(lJson);
    end;
  end
  else
    ExibirMessage(Format('Error: Statuscode => %d', [lRes.StatusCode]), tpError);
end;

procedure TF_Main.OnPesquisar;
var
  lRes: IResponse;
  lJson: TJsonObject;
  lEndPoint: string;
begin
  if (Trim(edt_Pesquisa.Text) <> '') then
    lEndPoint := Format('%s/tipoendereco/descricao/%s/page/%d/limit/%d',
                   [_URL, edt_Pesquisa.Text, FPage, _LIMIT])
  else
    lEndPoint := Format('%s/tipoendereco/page/%d/limit/%d', [_URL, FPage, _LIMIT]);

  lRes := TRequest.New
                  .BaseURL(lEndPoint)
                  .ContentType('application/json')
                  .Get;

  if (lRes.StatusCode = 200) then
  begin
    lJson := TJsonObject.Create();
    try
      if ljson.IsJsonObject(lRes.Content) then
      begin
        lJson.Parse( lRes.Content );

        if lJson.Values['success'].AsBoolean then
        begin
          ds_Lista.DataSet.Close;

          if (ds_Lista.DataSet is TClientDataSet) then
          begin
            ds_Lista.DataSet.Open;
            TClientDataSet(ds_Lista.DataSet).EmptyDataSet;
          end;

          TConverter.New
                    .LoadJson( lJson.Values['data'].AsArray )
                    .ToDataSet( ds_Lista.DataSet );
          ds_Lista.DataSet.Open;
        end
        else
          ExibirMessage(lJson.Values['message'].AsString, tpError);
      end
      else
        ExibirMessage('JSON Invalid!', tpError);
    finally
      FreeAndNil(lJson);
    end;
  end
  else
    ExibirMessage(Format('Error: Statuscode => %d', [lRes.StatusCode]), tpError);
end;

function TF_Main.OnSalvar: Boolean;
var
  lReq: IRequest;
  lRes: IResponse;
  lJson: TJsonObject;
  lEndPoint: string;
begin
  Result := False;

  lJson := TJsonObject.Create();
  try
    lJson.Put('id', edt_ID.Text);
    lJson.Put('descricao', edt_Descricao.Text);

    case FOperacao of
      toInsert: lEndPoint := Format('%s/tipoendereco', [_URL]);
      toUpdate:
        begin
          if (Trim(edt_ID.Text) = '') then
          begin
            ExibirMessage('ID não informado!', tpError);
            Exit(False);
          end;

          lEndPoint := Format('%s/tipoendereco/%s', [_URL, edt_ID.Text]);
        end;
    end;

    lReq := TRequest.New
                    .BaseURL(lEndPoint)
                    .ContentType('application/json')
                    .AddBody(lJson.Stringify);

    case FOperacao of
      toInsert: lRes := lReq.Post;
      toUpdate: lRes := lReq.Put;
    end;

    if (lRes.StatusCode = 200) then
    begin
      lJson.Clear;

      if lJson.IsJsonObject(lRes.Content) then
      begin
        lJson.Parse(lRes.Content);
        Result := lJson.Values['success'].AsBoolean;
        if Result then
        begin
          OnPesquisar();
          ExibirMessage(lJson.Values['message'].AsString, tpSuccess);
        end
        else
          ExibirMessage(lJson.Values['message'].AsString, tpError);
      end
      else
        ExibirMessage('JSON Invalid!', tpError);
    end
    else
      ExibirMessage(Format('Error: Statuscode => %d', [lRes.StatusCode]), tpError);
  finally
    FreeAndNil(lJson);
  end;
end;

procedure TF_Main.Status;
begin
  ai_Pesquisar.Enabled  := (FOperacao = toNone);
  ai_Anterior.Enabled   := (FOperacao = toNone) and (FPage > 1);
  ai_Proxima.Enabled    := (FOperacao = toNone);
  ai_Novo.Enabled       := (FOperacao = toNone);
  ai_Alterar.Enabled    := (FOperacao = toNone);
  ai_Visualizar.Enabled := (FOperacao = toNone);
  ai_Excluir.Enabled    := (FOperacao = toNone);
  ai_Salvar.Enabled     := (FOperacao in [toInsert, toUpdate]);
  ai_Cancelar.Enabled   := (FOperacao in [toInsert, toUpdate, toView]);
  ai_Sair.Enabled       := (FOperacao = toNone);

  lbl_Page.Caption := FormatFloat(',#00', FPage);

  edt_ID.Enabled := not (FOperacao in [toInsert, toUpdate]);
end;

initialization
  ReportMemoryLeaksOnShutdown := True;

end.
