#!/usr/bin/env bash

set -e

clear

echo
echo "Clearing Events Table"
echo "= = ="
echo

default_name=event_source

if [ -z ${DATABASE_USER+x} ]; then
  echo "(DATABASE_USER is not set)"
  user=$default_name
else
  user=$DATABASE_USER
fi
echo "Database user is: $user"

if [ -z ${DATABASE_NAME+x} ]; then
  echo "(DATABASE_NAME is not set)"
  database=$default_name
else
  database=$DATABASE_NAME
fi
echo "Database name is: $database"

default_table_name=events

if [ -z ${TABLE_NAME+x} ]; then
  echo "(TABLE_NAME is not set)"
  table=$default_table_name
else
  table=$TABLE_NAME
fi
echo "Table name is: $table"

echo

psql -h postgreshost -U postgres $database -c "TRUNCATE $table RESTART IDENTITY;"
