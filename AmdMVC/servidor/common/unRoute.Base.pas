////////////////////////////////////////////////////////////////////////////////
// Classe de dados : Route.Base - SERVER SIDE
// Templarium      : 2.0.0.00
// Data de Geração : 2023/01/16 - 12:00:01
////////////////////////////////////////////////////////////////////////////////

unit unRoute.Base;

{$ifdef fpc}
  {$mode delphi}{$H+}
{$endif}

interface

uses
  {$ifdef fpc}
  Classes, SysUtils,
  {$else}
  System.Classes, System.SysUtils,
  {$endif}
  Horse, unDAO.DBConexao.Services;

type
  TBase = class
  public
    class procedure Route;
  end;

implementation

{ TBase }

procedure OnStatus(aReq: THorseRequest; aRes: THorseResponse);
begin
  aRes.ContentType('text/html')
      .Send( Format('<h1>Servidor Horse-Amadeus versão %s - %s </h1>', [THorse.Version, FormatDateTime('dd/mm/yyyy hh:mm:ss', now())]) );
end;

procedure OnCheckDB(aReq: THorseRequest; aRes: THorseResponse);
begin
  aRes.ContentType('application/json')
      .Send( TStructureService.New
                              .CheckDB);
end;

//procedure OnStructure(aReq: THorseRequest; aRes: THorseResponse);
//begin
//  aRes.ContentType('application/json')
//      .Send( TStructureService.New
//                              .GetStructure( aReq.Params
//                                                 .Required(False)
//                                                 .Field('tablename')
//                                                 .AsString) );
//end;

class procedure TBase.Route;
begin
  THorse.Get('/', OnStatus)
        .Get('/checkdb', OnCheckDB)
//        .Get('/structure/:tablename', OnStructure)
        ;
end;

end.
