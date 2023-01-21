unit u_BaseInterfacedObject;

{$ifdef fpc}
  {$mode delphi}
{$endif}

interface

uses
  {$ifdef fpc}
  Classes, SysUtils;
  {$else}
  System.Classes, System.SysUtils;
  {$endif}

type
  TBaseInterfacedObject = class(TInterfacedObject)
  public
    function Paginate(aPage, aLimit: Integer): string;
    function GenGUID: string;
  end;

implementation

{ TBaseInterfacedObject }

function TBaseInterfacedObject.GenGUID: string;
begin
  Result := TGUID.NewGuid.ToString;
  Result := StringReplace(Result, '{', '', [rfReplaceAll]);
  Result := StringReplace(Result, '}', '', [rfReplaceAll]);
end;

function TBaseInterfacedObject.Paginate(aPage, aLimit: Integer): string;
var
  lRows,
  lTo: Integer;
begin
  Result := '';

  if (aPage > 0) then
  begin
    if (aLimit <= 0) then
      aLimit := 50;

    lRows := aPage;
    lTo := aLimit;

    if (aPage > 1) then
    begin
      lRows := (aLimit * (aPage - 1));
      lTo := (lRows + aLimit);
      Inc(lRows);
    end;

    Result := Format('ROWS %d TO %d', [lRows, lTo]);
    // mssql order by []  OFFSET 50 ROWS  FETCH NEXT 50 ROWS ONLY;
    // sqlite limit 3 offset 6
    // Postgres order by bloquetoid limit 10 offset 10;
  end;
end;

end.
