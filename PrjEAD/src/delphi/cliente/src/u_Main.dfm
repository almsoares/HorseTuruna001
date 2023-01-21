object F_Main: TF_Main
  Left = 0
  Top = 0
  Caption = 'CRUD'
  ClientHeight = 566
  ClientWidth = 871
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 13
  object dbg_Lista: TDBGrid
    Left = 0
    Top = 0
    Width = 871
    Height = 476
    Align = alClient
    BorderStyle = bsNone
    DataSource = ds_Lista
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    ParentFont = False
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object pnl_Base: TPanel
    Left = 0
    Top = 476
    Width = 871
    Height = 90
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 472
    ExplicitWidth = 869
    object pnl_Botao: TPanel
      Left = 0
      Top = 0
      Width = 871
      Height = 45
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitWidth = 869
      object btn_Anterior: TSpeedButton
        Left = 283
        Top = 10
        Width = 25
        Height = 24
        Action = ai_Anterior
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object btn_Proxima: TSpeedButton
        Left = 334
        Top = 10
        Width = 25
        Height = 24
        Action = ai_Proxima
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbl_Page: TLabel
        Left = 314
        Top = 15
        Width = 14
        Height = 16
        Caption = '01'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object btn_Pesquisar: TButton
        Left = 184
        Top = 10
        Width = 75
        Height = 24
        Action = ai_Pesquisar
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object edt_Pesquisa: TEdit
        Left = 25
        Top = 10
        Width = 153
        Height = 24
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
      object btn_New: TButton
        Left = 408
        Top = 10
        Width = 75
        Height = 24
        Action = ai_Novo
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
      end
      object btn_Alterar: TButton
        Left = 489
        Top = 10
        Width = 75
        Height = 24
        Action = ai_Alterar
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
      end
      object btn_Excluir: TButton
        Left = 651
        Top = 10
        Width = 75
        Height = 24
        Action = ai_Excluir
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
      end
      object btn_Sair: TButton
        Left = 775
        Top = 10
        Width = 75
        Height = 24
        Action = ai_Sair
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 6
      end
      object Button1: TButton
        Left = 570
        Top = 10
        Width = 75
        Height = 24
        Action = ai_Visualizar
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
      end
    end
    object pnl_Crud: TPanel
      Left = 0
      Top = 45
      Width = 871
      Height = 45
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitWidth = 869
      object edt_Descricao: TEdit
        Left = 334
        Top = 11
        Width = 334
        Height = 24
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        MaxLength = 35
        ParentFont = False
        TabOrder = 1
        TextHint = 'Descri'#231#227'o'
      end
      object btn_Salvar: TButton
        Left = 694
        Top = 11
        Width = 75
        Height = 24
        Action = ai_Salvar
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
      end
      object btn_Cancelar: TButton
        Left = 775
        Top = 11
        Width = 75
        Height = 24
        Action = ai_Cancelar
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
      end
      object edt_ID: TEdit
        Left = 25
        Top = 11
        Width = 293
        Height = 24
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        TextHint = 'ID'
      end
    end
  end
  object act_Base: TActionList
    Left = 56
    Top = 128
    object ai_Pesquisar: TAction
      Caption = 'Pesquisar'
      OnExecute = ai_PesquisarExecute
    end
    object ai_Anterior: TAction
      Caption = '<'
      OnExecute = ai_AnteriorExecute
    end
    object ai_Proxima: TAction
      Caption = '>'
      OnExecute = ai_ProximaExecute
    end
    object ai_Novo: TAction
      Caption = 'Novo'
      OnExecute = ai_NovoExecute
    end
    object ai_Alterar: TAction
      Caption = 'Alterar'
      OnExecute = ai_AlterarExecute
    end
    object ai_Visualizar: TAction
      Caption = 'Visualizar'
      OnExecute = ai_VisualizarExecute
    end
    object ai_Excluir: TAction
      Caption = 'Excluir'
      OnExecute = ai_ExcluirExecute
    end
    object ai_Salvar: TAction
      Caption = 'Salvar'
      OnExecute = ai_SalvarExecute
    end
    object ai_Cancelar: TAction
      Caption = 'Cancelar'
      OnExecute = ai_CancelarExecute
    end
    object ai_Sair: TAction
      Caption = 'Sair'
      OnExecute = ai_SairExecute
    end
  end
  object ds_Lista: TDataSource
    DataSet = ClientDataSet
    Left = 56
    Top = 184
  end
  object FDMemTable: TFDMemTable
    ActiveStoredUsage = []
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 56
    Top = 240
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 152
    Top = 240
  end
end
