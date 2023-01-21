unit Json.Result;

{$ifdef fpc}
  {$mode delphi}
{$endif}

interface

uses
  {$ifdef fpc}
  Classes, SysUtils,
  {$else}
  System.Classes, System.SysUtils, System.Math,
  {$endif}
  j4dl;

type
  IJsonResult = interface
    ['{C3716A25-BCBF-40FF-A867-F54C598F4E43}']
    function Success(aValue: Boolean): IJsonResult;
    function Statuscode(aValue: integer): IJsonResult;
    function Message(aValue: string): IJsonResult;
    function Data(aValue: TJsonObject): IJsonResult; overload;
    function Data(aValue: TJsonArray): IJsonResult; overload;
    function Data(aValue: string): IJsonResult; overload;
    function ToJson: TJsonObject;
    function ToString: string;
    function Paginate(aTotal, aPage, aLimit: Integer): IJsonResult;
  end;

  TJsonResult = class(TInterfacedObject, IJsonResult)
  private
    FJson: TJsonObject;
  public
    constructor Create(aSuccess: Boolean);
    destructor Destroy; override;
    class function New(aSuccess: Boolean = True): IJsonResult;

    function Success(aValue: Boolean): IJsonResult;
    function Statuscode(aValue: integer): IJsonResult;
    function Message(aValue: String): IJsonResult;
    function Data(aValue: TJsonObject): IJsonResult; overload;
    function Data(aValue: TJsonArray): IJsonResult; overload;
    function Data(aValue: string): IJsonResult; overload;
    function ToJson: TJsonObject;
    function ToString: string; override;
    function Paginate(aTotal, aPage, aLimit: Integer): IJsonResult;
  end;

implementation

{ TJsonResult }

constructor TJsonResult.Create(aSuccess: Boolean);
begin
  FJson := TJsonObject.Create();
  FJson.Put('success', aSuccess);
  FJson.Put('statuscode', 200);
end;

function TJsonResult.Data(aValue: TJsonObject): IJsonResult;
begin
  Result := Self;

  if (FJson.Find('data') > -1) then
    FJson.Delete('data');

  FJson.Put('data', aValue);
end;

function TJsonResult.Data(aValue: TJsonArray): IJsonResult;
begin
  Result := Self;

  if (FJson.Find('data') > -1) then
    FJson.Delete('data');

  FJson.Put('data', aValue);
end;

function TJsonResult.Data(aValue: string): IJsonResult;
var
  lJson: TJsonObject;
begin
  Result := Self;

  if (FJson.Find('data') > -1) then
    FJson.Delete('data');

  lJson := TJsonObject.Create();
  try
    if not aValue.Trim.IsEmpty and lJson.IsJsonObject(aValue) then
      lJson.Parse(aValue);

    if (lJson.Find('data') > -1) then
      FJson.Put('data', lJson.Values['data'].AsArray[0].AsObject)
    else
      FJson.Put('data', lJson);
  finally
    FreeAndNil(lJson);
  end;
end;

destructor TJsonResult.Destroy;
begin
  FreeAndNil(FJson);

  inherited;
end;

function TJsonResult.Message(aValue: String): IJsonResult;
begin
  Result := Self;

  if (FJson.Find('message') > -1) then
    FJson.Delete('message');

  FJson.Put('message', aValue);
end;

class function TJsonResult.New(aSuccess: Boolean): IJsonResult;
begin
  Result := Self.Create(aSuccess);
end;

function TJsonResult.Statuscode(aValue: integer): IJsonResult;
begin
  Result := Self;

  if (FJson.Find('statuscode') > -1) then
    FJson.Delete('statuscode');

  FJson.Put('statuscode', aValue);
end;

function TJsonResult.Success(aValue: Boolean): IJsonResult;
begin
  Result := Self;

  FJson.Clear;
  FJson.Put('success', aValue);
end;

function TJsonResult.ToJson: TJsonObject;
begin
  Result := FJson;
end;

function TJsonResult.ToString: string;
begin
  Result := FJson.Stringify;
end;

function TJsonResult.Paginate(aTotal, aPage, aLimit: Integer): IJsonResult;
begin
  Result := Self;
  if (aLimit <= 0) then
    aLimit := 50;
  FJson.Put('total', aTotal);
  FJson.Put('limit', aLimit);
  FJson.Put('page', aPage);
  FJson.Put('Pages', Ceil(aTotal/aLimit));
end;

end.
