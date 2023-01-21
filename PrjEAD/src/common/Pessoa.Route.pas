unit Pessoa.Route;

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
  Horse, Pessoa.Service;

type
  TPessoa = class
  public
    class procedure Route;
  end;

implementation

{ TPessoa }

procedure OnLoad(aReq: THorseRequest; aRes: THorseResponse);
begin
  aRes.ContentType('application/json')
      .Send( TPessoaService.New
                           .Load( aReq.Params.Required(False).Field('id').AsString,
                                  aReq.Params.Required(False).Field('cpf_cnpj').AsString,
                                  aReq.Params.Required(False).Field('nome_razao').AsString,
                                  aReq.Params.Required(False).Field('apelido_fantasia').AsString,
                                  aReq.Params.Required(False).Field('page').AsInteger,
                                  aReq.Params.Required(False).Field('limit').AsInteger));
end;

procedure OnSave(aReq: THorseRequest; aRes: THorseResponse);
begin
  aRes.ContentType('application/json')
      .Send( TPessoaService.New
                           .Save( aReq.Params
                                      .Required(false)
                                      .Field('id').AsString,
                                  aReq.Body ) );
end;

procedure OnDelete(aReq: THorseRequest; aRes: THorseResponse);
begin
  aRes.ContentType('application/json')
      .Send( TPessoaService.New
                           .Delete( aReq.Params.Field('id').AsString) );
end;

class procedure TPessoa.Route;
begin
  THorse.Group
        .Prefix('/pessoa')
        .Get('', OnLoad)
        .Get('/page/:page', OnLoad)
        .Get('/page/:page/limit/:limit', OnLoad)
        .Get('/id/:id', OnLoad)
        .Get('/doc/:cpf_cnpj', OnLoad)
        .Get('/nomerazao/:nome_razao', OnLoad)
        .Get('/nomerazao/:nome_razao/page/:page', OnLoad)
        .Get('/nomerazao/:nome_razao/page/:page/limit/:limit', OnLoad)
        .Get('/apelidofantasia/:apelido_fantasia', OnLoad)
        .Get('/apelidofantasia/:apelido_fantasia/page/:page', OnLoad)
        .Get('/apelidofantasia/:apelido_fantasia/page/:page/limit/:limit', OnLoad)
        .Post('', OnSave)
        .Put('/:id', OnSave)
        .Delete('/:id', OnDelete);
end;

end.
