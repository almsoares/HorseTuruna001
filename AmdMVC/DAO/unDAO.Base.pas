////////////////////////////////////////////////////////////////////////////////
// Classe de dados : MVC-DAO.Base - Data Access Objects - SERVER SIDE
// Templarium      : 2.0.0.00
// Data de Geração : 2023/01/16 - 12:00:01
////////////////////////////////////////////////////////////////////////////////

unit unDAO.Base;

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
  db, unModel.Base;

  Function GetSelect(EntidadeDB: IEntidadeDB; sSQLSelList: Boolean; sApagado:Boolean): string;
  Function GetInsert(EntidadeDB: IEntidadeDB): string;
  Function GetUpdate(EntidadeDB: IEntidadeDB): string;
  Function GetDelete(EntidadeDB: IEntidadeDB): string;

  Function GetPkName(EntidadeDB: IEntidadeDB): string;

implementation

Function GetSelect(EntidadeDB: IEntidadeDB; sSQLSelList: Boolean; sApagado:Boolean): string;
var
  RecAtributo: RAtributo;
  SQLQuery: string;
  AuxSQLSel: boolean;
begin
  // Montar consulta SQL de uma Classe de dados
  SQLQuery := '';
  for RecAtributo in EntidadeDB.GetAtributoSmartP.Value.Values do
  begin
    if sSQLSelList then AuxSQLSel:= RecAtributo.SQLSelList
      else AuxSQLSel:= RecAtributo.SQLSel;
    if AuxSQLSel then
    begin
      if SQLQuery = '' then
        SQLQuery := 'SELECT '
      else
        SQLQuery := SQLQuery + ', ';
      SQLQuery := SQLQuery + RecAtributo.Nome;
    end;
  end;
  SQLQuery := SQLQuery + ' FROM ' + EntidadeDB.GetTbSelect;
  if sApagado then
   SQLQuery := SQLQuery + ' WHERE apagado = 0 '
  else SQLQuery := SQLQuery + ' WHERE 1=1 ';
  Result := SQLQuery;
end;

Function GetInsert(EntidadeDB: IEntidadeDB): string;
var
  RecAtributo: RAtributo;
  SQLQueryFields,
  SQLQueryValues,
  SQLQueryReturnID: string;
begin
  // Montar SQL INSERT de uma Classe de dados
  SQLQueryFields := '';
  SQLQueryValues := '';
  SQLQueryReturnID := '';
  for RecAtributo in EntidadeDB.GetAtributoSmartP.Value.Values do
  begin
    if RecAtributo.SQLIns then
    begin
      if RecAtributo.PK then
        if EntidadeDB.PkAutoInc then
        begin
          SQLQueryReturnID:= ' RETURNING ' + RecAtributo.Nome;   // MSSQL OUTPUT Inserted.ID - MYSQL SELECT LAST_INSERT_ID();
          continue;
        end;

      if not SQLQueryFields.IsEmpty then
      begin
        SQLQueryFields:= SQLQueryFields + ', ';
        SQLQueryValues:= SQLQueryValues + ', ';
      end;
      SQLQueryFields := SQLQueryFields + RecAtributo.Nome;
      SQLQueryValues := SQLQueryValues + ':' + RecAtributo.Nome;

    end;
  end;
  SQLQueryFields:= 'INSERT INTO ' + EntidadeDB.GetTbInsert + '(' + SQLQueryFields + ')';
  SQLQueryValues:= ' VALUES ( ' + SQLQueryValues + ')';
  if SQLQueryReturnID.IsEmpty then
    Result := SQLQueryFields + SQLQueryValues
  else Result := SQLQueryFields + SQLQueryValues + SQLQueryReturnID;
end;

Function GetUpdate(EntidadeDB: IEntidadeDB): string;
var
  RecAtributo: RAtributo;
  SQLQuery,
  SQLQueryPk: string;
begin
  // Montar SQL UPDATE de uma Classe de dados
  SQLQuery := '';
  SQLQueryPk:= '';
  for RecAtributo in EntidadeDB.GetAtributoSmartP.Value.Values do
  begin
    if RecAtributo.SQLIns then
    begin
      if not RecAtributo.PK then
      begin
        if not SQLQuery.IsEmpty then
          SQLQuery:= SQLQuery + ', ';
        SQLQuery := SQLQuery + RecAtributo.Nome + ' :' + RecAtributo.Nome;
      end else
        SQLQueryPk:= ' WHERE ' + RecAtributo.Nome + ' = :' + RecAtributo.Nome;
    end;
  end;
  SQLQuery := 'UPDATE ' + EntidadeDB.GetTbInsert + ' SET ' + SQLQuery + SQLQueryPk;
  Result := SQLQuery;
end;

Function GetDelete(EntidadeDB: IEntidadeDB): string;
var
  RecAtributo: RAtributo;
  SQLQuery,
  SQLQueryPk: string;
begin
  // Montar SQL UPDATE de uma Classe de dados
  SQLQuery := '';
  SQLQueryPk:= '';
  for RecAtributo in EntidadeDB.GetAtributoSmartP.Value.Values do
  begin
    if RecAtributo.PK then
      SQLQueryPk:= ' WHERE ' + RecAtributo.Nome + ' = :' + RecAtributo.Nome;
  end;
  SQLQuery := 'UPDATE ' + EntidadeDB.GetTbInsert + ' SET Apagado = 1 ' + SQLQueryPk;
  Result := SQLQuery;
end;

Function GetPkName(EntidadeDB: IEntidadeDB): string;
var
  RecAtributo: RAtributo;
  PkName: string;
begin
  // Retorna nome da PK
  PkName := '';
  for RecAtributo in EntidadeDB.GetAtributoSmartP.Value.Values do
  begin
    if RecAtributo.PK then
      PkName:= RecAtributo.Nome;
  end;
  Result := PkName;
end;

end.
