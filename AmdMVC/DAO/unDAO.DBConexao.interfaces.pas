////////////////////////////////////////////////////////////////////////////////
// Classe de dados : MVC-DAO.DBConexao.interfaces - SERVER SIDE
// Templarium      : 2.0.0.00
// Data de Geração : 2023/01/16 - 12:00:01
////////////////////////////////////////////////////////////////////////////////

unit unDAO.DBConexao.interfaces;

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
    ['{AFE874D1-3AE7-4D88-83F0-178BDB78A541}']
    function Connected: Boolean; overload;
    function Connected(Value: Boolean): IDBConexao; overload;
    function InTransaction: Boolean;
    function StartTransaction: IDBConexao;
    function Commit: IDBConexao;
    function Rollback: IDBConexao;

    function GetQuery: TComponent;
    function CheckDB: string;
    function Paginate(aPage, aLimit: Integer): string;
  end;

implementation

end.
