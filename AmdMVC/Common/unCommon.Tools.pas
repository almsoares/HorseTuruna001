////////////////////////////////////////////////////////////////////////////////
// Classe de dados : Tools - Funções e Procedimentos Auxiliares Diversos
// Templarium      : 2.0.0.00
// Data de Geração : 2023/01/16 - 12:00:01
////////////////////////////////////////////////////////////////////////////////

unit unCommon.Tools;

{$ifdef fpc}
  {$mode delphi}
{$endif}

interface

uses
  {$ifdef fpc}
  Classes, SysUtils, Controls, Forms, Dialogs, Generics.Collections, StrUtils,
  StdCtrls;
  {$else}
  System.Classes, System.SysUtils, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Generics.Collections, Vcl.StdCtrls, System.StrUtils;
  {$endif}

Type
  TTools = class
  public
    //class function RemoveCaracterEspecial(aValue: string): string;
    class procedure MostraMensagem(Titulo, Msg: String);
    class function Confirma(Msg: String): Boolean;
    class procedure LimpaRecord(var Buffer);
  end;

implementation

//------------------------------------------------------------------------------
//Substitui o ShowMessage
class procedure TTools.MostraMensagem(Titulo, Msg: String);
begin
  with CreateMessageDialog(Msg, mtInformation, [mbOk]) do
  try
    Caption := Titulo; //'Importante - Informação';
    ShowModal;
  finally
    Free
  end;
end;

//------------------------------------------------------------------------------
// exibe uma caixa de dialogo pedindo a confirmação (SIM - NÃO)
class function TTools.Confirma(Msg: String): Boolean;
var i : Integer;
    f : TForm;
begin
    f:= CreateMessageDialog(Msg,MtConfirmation,[mbYes,mbNo]);
    try
      for i:=0 to f.ComponentCount -1 do
      begin
        if f.Components[i] is TButton then
          with TButton(f.Components[i]) do
            case modalresult of
              mrYes: Caption := '&Sim';
              mrNo: Caption := '&Não';
            end;
      end;
      f.Caption := 'Confirmação';
      Result := f.ShowModal = mrYes;
    finally
      f.Free;
    end;
end;

class procedure TTools.LimpaRecord(var Buffer);
begin
  FillChar(Buffer, sizeof(Buffer), 0);
end;

end.
