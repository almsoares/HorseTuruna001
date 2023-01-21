unit Base.Route;

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
  Horse, Structure.Service;

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
      .Send( Format('<h1>Servidor Horse versão %s - Vem pro Horse</h1>', [THorse.Version]) );
end;

procedure OnStructure(aReq: THorseRequest; aRes: THorseResponse);
begin
  aRes.ContentType('application/json')
      .Send( TStructureService.New
                              .GetStructure( aReq.Params
                                                 .Required(False)
                                                 .Field('tablename')
                                                 .AsString) );
end;

class procedure TBase.Route;
begin
  THorse.Get('/', OnStatus)
        .Get('/structure/:tablename', OnStructure);
end;

end.
