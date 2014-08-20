#!/bin/bash

set -e

if [ $# -eq 0 ]
  then
    echo "===> ERROR: Please provide the absolute path to the csv file"
else
  echo "===> Importing Alladopted Budget"

  psql -d postgres <<SQL
    CREATE SCHEMA IF NOT EXISTS budgetbuddy;
    DROP TABLE IF EXISTS budgetbuddy.alladopted;
    CREATE TABLE IF NOT EXISTS budgetbuddy.alladopted (
      agency_id INTEGER,
      agency_name TEXT,
      unit_of_appropriation_id  INTEGER,
      unit_of_appropriation_name  TEXT,
      responsibility_center_id  TEXT,
      responsibility_center_name  TEXT,
      budget_code_id  TEXT,
      budget_code_name  TEXT,
      object_class  TEXT,
      ic_ref  TEXT,
      obj TEXT,
      description TEXT,
      budget_period TEXT,
      inc_dec TEXT,
      key TEXT,
      value TEXT,
      file_name TEXT,
      source_line TEXT
    );
    COPY budgetbuddy.alladopted FROM '$1' DELIMITER ',' CSV HEADER;
SQL

DUMP_PATH=$(dirname $1)
echo "===> Exporting the budgetbuddy DB into $DUMP_PATH/alladopted.dump"
pg_dump -Fc --no-acl --no-owner -h localhost postgres -n budgetbuddy > $DUMP_PATH/alladopted.dump
echo "===> Done exporting the DB."

fi
