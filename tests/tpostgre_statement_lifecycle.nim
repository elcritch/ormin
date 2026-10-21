import std/[os, strutils, unittest]

import db_connector/db_postgres as pg
from db_connector/postgres import pqgetvalue
import ormin/ormin_postgre as orminPostgre

let target = getEnv("TEST_DATABASE_URL")
let db =
  if target.len > 0:
    pg.open("", "", "", target)
  else:
    pg.open("localhost", "test", "test", "test_ormin")

suite "PostgreSQL statement lifecycle":
  test "repeated parameterized queries leave no named plans behind":
    let before = pg.getValue(db, sql"select count(*) from pg_prepared_statements").parseInt()
    for value in 0 ..< 1000:
      let statement = orminPostgre.prepareStmt(db, "select $1::integer")
      orminPostgre.startBindings(statement, 1)
      orminPostgre.bindParam(db, statement, 1, value, int)
      orminPostgre.startQuery(db, statement)
      check orminPostgre.stepQuery(db, statement, true)
      check $pqgetvalue(queryResult, queryI, 0) == $value
      orminPostgre.stopQuery(db, statement)
    let after = pg.getValue(db, sql"select count(*) from pg_prepared_statements").parseInt()
    check after == before

pg.close(db)
