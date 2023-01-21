unit TipoContato.Route;

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
  Horse, TipoContato.Service;

type
  TTipoContato = class
  public
    class procedure Route;
  end;

implementation

{ TTipoContato }

procedure OnLoad(aReq: THorseRequest; aRes: THorseResponse);
//var
//  lStatusCode: Integer;
begin
  aRes.ContentType('application/json')
      .Send( TTipoContatoService.New
                                .Load( aReq.Params.Required(False).Field('id').AsString,
                                       aReq.Params.Required(False).Field('descricao').AsString,
                                       aReq.Params.Required(False).Field('page').AsInteger,
                                       aReq.Params.Required(False).Field('limit').AsInteger));
                                //       lStatusCode ))
                                //.Status(lStatusCode);
end;

procedure OnSave(aReq: THorseRequest; aRes: THorseResponse);
begin
  aRes.ContentType('application/json')
      .Send( TTipoContatoService.New
                                .Save( aReq.Params
                                           .Required(false)
                                           .Field('id').AsString,
                                       aReq.Body ) );
end;

procedure OnDelete(aReq: THorseRequest; aRes: THorseResponse);
begin
  aRes.ContentType('application/json')
      .Send( TTipoContatoService.New
                                .Delete( aReq.Params.Field('id').AsString) );
end;

class procedure TTipoContato.Route;
begin
  THorse.Group
        .Prefix('/tipocontato')
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
