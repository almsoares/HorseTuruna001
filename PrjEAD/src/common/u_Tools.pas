unit u_Tools;

{$ifdef fpc}
  {$mode delphi}
{$endif}

interface

uses
  {$ifdef fpc}
  Classes, SysUtils, MaskUtils, DB;
  {$else}
  System.Classes, System.SysUtils, System.MaskUtils, Data.DB, Soap.EncdDecd,
  System.NetEncoding;
  {$endif}

type
  TTools = class
  public
    class function RemoveCaracterEspecial(aValue: string): string;
    class function FormatCepCpfCnpj(aValue: string): string;
    class function SetTipoPessoa(aCpfCnpj: string): string;
    class function GetTipoPessoa(aCpfCnpj: string): string;
  end;

implementation

{ TTools }

class function TTools.FormatCepCpfCnpj(aValue: string): string;
var
  lValue: string;
begin
  Result := aValue;
  if not aValue.Trim.IsEmpty then
  begin
    lValue := RemoveCaracterEspecial(aValue);
    case lValue.Length of
       8: Result := {$ifndef fpc}System.{$endif}MaskUtils.FormatMaskText('00.000-000;0; ', lValue);
      11: Result := {$ifndef fpc}System.{$endif}MaskUtils.FormatMaskText('000.000.000-00;0; ', lValue);
      14: Result := {$ifndef fpc}System.{$endif}MaskUtils.FormatMaskText('00.000.000/0000-00;0; ', lValue);
    end;
  end;
end;

class function TTools.GetTipoPessoa(aCpfCnpj: string): string;
var
  lValue: string;
begin
  Result := aCpfCnpj;
  if not aCpfCnpj.Trim.IsEmpty then
  begin
    lValue := RemoveCaracterEspecial(aCpfCnpj);
    case lValue.Length of
      11: Result := 'Pessoa Física';
      14: Result := 'Pessoa Jurídica';
    end;
  end;
end;

class function TTools.RemoveCaracterEspecial(aValue: string): string;
var
  lLetter: Char;
begin
  Result := '';
  for lLetter in aValue do
    if CharInSet(lLetter, ['0'..'9', 'A'..'Z', 'a'..'z']) then
      Result := Result + lLetter;
end;

class function TTools.SetTipoPessoa(aCpfCnpj: string): string;
var
  lValue: string;
begin
  Result := aCpfCnpj;
  if not aCpfCnpj.Trim.IsEmpty then
  begin
    lValue := RemoveCaracterEspecial(aCpfCnpj);
    case lValue.Length of
      11: Result := 'F';
      14: Result := 'J';
    end;
  end;
end;

end.
