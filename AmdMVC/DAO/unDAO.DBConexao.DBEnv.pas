////////////////////////////////////////////////////////////////////////////////
// Classe de dados : MVC-DAO.DBConexao.DBEnv - SERVER SIDE
// Templarium      : 2.0.0.00
// Data de Geração : 2023/01/16 - 12:00:01
////////////////////////////////////////////////////////////////////////////////

unit unDAO.DBConexao.DBEnv;

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
//  // Firebird
//  DB_PROTOCOL  = 'firebird';
//  DB_DRIVER_ID = 'FB';
//  DB_HOST      = '127.0.0.1';
//  DB_PORT      = 3050;
//  DB_DATABASE  = 'C:\TurunaDev\amadeus\horse-ead\Projeto\database\db_curso.fdb';
//  DB_USERNAME  = 'SYSDBA';
//  DB_PASSWORD  = 'masterkey';

  // Postgres
  DB_PROTOCOL  = 'Postgres';
  DB_DRIVER_ID = 'PG';
  DB_HOST      = '127.0.0.1';
  DB_PORT      = 5432;
  DB_DATABASE  = 'WKHorse';
  DB_USERNAME  = 'postgres';
  DB_PASSWORD  = 'rm045369';

  DB_PATH_LIB  = '';

implementation

end.
