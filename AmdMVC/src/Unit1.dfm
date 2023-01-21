object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 440
  ClientWidth = 620
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnClose = FormClose
  OnCreate = FormCreate
  TextHeight = 15
  object spbDicionario: TSpeedButton
    Left = 523
    Top = 409
    Width = 81
    Height = 25
    Caption = 'Dicionario'
    OnClick = spbDicionarioClick
  end
  object SQLRecEntidadeDB: TMemo
    Left = 8
    Top = 8
    Width = 612
    Height = 395
    Lines.Strings = (
      'SQLRecEntidadeDB')
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object btnTesteRecord: TBitBtn
    Left = 432
    Top = 409
    Width = 75
    Height = 25
    Caption = 'TesteRecord'
    TabOrder = 1
    OnClick = btnTesteRecordClick
  end
end
