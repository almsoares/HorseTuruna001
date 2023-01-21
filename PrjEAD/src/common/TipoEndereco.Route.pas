unit TipoEndereco.Route;

{$ifdef fpc}
  {$mode delphi}
{$endif}

interface

uses
  {$ifdef fpc}
  Classes, SysUtils,
  {$else}
  System.Classes, System.SysUtils,
  {$endif}
  Horse, TipoEndereco.Service;

type
  TTipoEndereco = class
  public
    class procedure Route;
  end;

implementation

{ TTipoEndereco }

procedure OnLoad(aReq: THorseRequest; aRes: THorseResponse);
begin
  aRes.ContentType('application/json')
      .Send( TTipoEnderecoService.New
                                 .Load( aReq.Params.Required(False).Field('id').AsString,
                                        aReq.Params.Required(False).Field('descricao').AsString,
                                        aReq.Params.Required(False).Field('page').AsInteger,
                                        aReq.Params.Required(False).Field('limit').AsInteger));
end;

procedure OnSave(aReq: THorseRequest; aRes: THorseResponse);
begin
  aRes.ContentType('application/json')
      .Send( TTipoEnderecoService.New
                                 .Save( aReq.Params
                                            .Required(false)
                                            .Field('id').AsString,
                                        aReq.Body ) );
end;

procedure OnDelete(aReq: THorseRequest; aRes: THorseResponse);
begin
  aRes.ContentType('application/json')
      .Send( TTipoEnderecoService.New
                                 .Delete( aReq.Params.Field('id').AsString) );
end;

class procedure TTipoEndereco.Route;
begin
  THorse.Group
        .Prefix('/tipoendereco')
        .Get('', OnLoad)
        .Get('/page/:page', OnLoad)
        .Get('/page/:page/limit/:limit', OnLoad)
        .Get('/id/:id', OnLoad)
        .Get('/descricao/:descricao', OnLoad)
        .Get('/descricao/:descricao/page/:page', OnLoad)
        .Get('/descricao/:descricao/page/:page/limit/:limit', OnLoad)
        .Post('', OnSave)
        .Put('/:id', OnSave)
        .Delete('/:id', OnDelete);
end;

end.
