unit DBEnv;

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

const
  DB_PROTOCOL  = 'firebird';
  DB_DRIVER_ID = 'FB';
  DB_HOST      = '127.0.0.1';
  DB_PORT      = 3050;
  DB_DATABASE  = 'C:\TurunaDev\amadeus\horse-ead\Projeto\database\db_curso.fdb';
  DB_USERNAME  = 'SYSDBA';
  DB_PASSWORD  = 'masterkey';

  DB_PATH_LIB  = '';

implementation

end.
