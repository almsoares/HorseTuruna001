unit DBConexao.Contrato;

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
  IDBConexao = interface
    ['{B1BB40ED-58A3-4468-97B9-99EA26494E42}']
    function Connected: Boolean; overload;
    function Connected(Value: Boolean): IDBConexao; overload;
    function InTransaction: Boolean;
    function StartTransaction: IDBConexao;
    function Commit: IDBConexao;
    function Rollback: IDBConexao;

    function GetQuery: TComponent;
    function Paginate(aPage, aLimit: Integer): string;
    function GenGUID: string;
    function CheckDB: string;
  end;

implementation

end.
