program console;

{$ifdef fpc}
  {$mode delphi}
{$endif}

uses Classes, SysUtils,
  Horse,
  Base.Route,
  TipoContato.Route,
  TipoEndereco.Route,
  Pessoa.Route;

procedure OnListen(aHorse: THorse);
begin
  WriteLn(Format('Servidor ativo porta %d', [aHorse.Port]));
end;

begin

  TBase.Route;
  TTipoContato.Route;
  TTipoEndereco.Route;
  TPessoa.Route;

  THorse.Listen(9095, OnListen);
end.

