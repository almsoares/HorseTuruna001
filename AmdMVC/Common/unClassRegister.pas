unit unClassRegister;


{$ifdef fpc}
  {$mode delphi}
{$endif}

interface

uses
  {$ifdef fpc}
  Classes, SysUtils,  Generics.Collections,
  {$else}
  System.Classes, System.SysUtils, Generics.Collections,
  {$endif}
  db;

type
  TClassRegister = class
  public
    class procedure RegisterClass(AClass: TInterfacedClass);
    class function GetClass(const ClassName: string): TInterfacedClass; overload;
    class function GetClass(const IID: TGuid): TInterfacedClass; overload;
    class function GetClass(Index: Integer): TInterfacedClass; overload;
    class function Count: Integer;
  end;

implementation
var
  _ClassList: TList;

class procedure TClassRegister.RegisterClass(AClass: TInterfacedClass);
begin
  _ClassList.Add(AClass);
end;

class function TClassRegister.GetClass(const ClassName: string):TInterfacedClass;
var
  i: Integer;
begin
  i := 0;
  Result := nil;
  while (i < _ClassList.Count) and (Result = nil) do
    if TInterfacedClass(_ClassList[i]).ClassName = ClassName then
      Result := TInterfacedClass(_ClassList[i])
    else Inc(i);
end;

class function TClassRegister.GetClass(const IID: TGuid): TInterfacedClass;
var
  i: Integer;
begin
  i := 0;
  Result := nil;
  while (i < _ClassList.Count) and (Result = nil) do
    if Supports(TInterfacedClass(_ClassList[i]), IID) then
     Result := TInterfacedClass(_ClassList[i])
    else Inc(i);
end;

class function TClassRegister.GetClass(Index: Integer): TInterfacedClass;
begin
  Result := TInterfacedClass(_ClassList[Index])
end;

class function TClassRegister.Count: Integer;
begin
  Result := _ClassList.Count;
end;

initialization
  _ClassList := TList.Create;

finalization
  _ClassList.Free;

end.
