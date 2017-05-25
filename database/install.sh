#!/usr/bin/env bash

set -e

clear

echo
echo "Installing Database"
echo "= = ="
echo

default_name=event_source

if [ -z ${DATABASE_USER+x} ]; then
  echo "(DATABASE_USER is not set)"
  user=$default_name
else
  user=$DATABASE_USER
fi

if [ -z ${DATABASE_NAME+x} ]; then
  echo "(DATABASE_NAME is not set)"
  database=$default_name
else
  database=$DATABASE_NAME
fi

echo

function create-user {
  echo "Database user is: $user"

  user_exists=`psql -h $PG_HOST -U postgres -tAc "SELECT 1 FROM pg_roles WHERE rolname='$user'"`

  if [ "$user_exists" = "1" ]; then
    echo "Database user \"$user\" was previously created. Not creating again."
  else
    echo "Database user \"$user\" has not yet been created"
    echo "Creating database user \"$user\""
    createuser -h $PG_HOST -U postgres -s $user
  fi

  echo
}

function create-database {
  echo "Database name is: $database"

  database_exists=`psql -h $PG_HOST -U postgres -tAc "SELECT 1 FROM pg_database WHERE datname='$database'"`

  if [ "$database_exists" = "1" ]; then
    echo "Database \"$database\" was previously created. Not creating again."
  else
    echo "Database \"$database\" has not yet been created"
    echo "Creating database \"$database\""
    createdb  -h $PG_HOST -U $user $database || true
  fi

  echo
}

function create-table {
  psql  -h $PG_HOST -U $user $database -f database/table/events-table.sql
}

function create-functions {
  psql  -h $PG_HOST -U $user $database -f database/functions/category.sql
  psql  -h $PG_HOST -U $user $database -f database/functions/stream-version.sql
  psql  -h $PG_HOST -U $user $database -f database/functions/write-event.sql
}

function create-indexes {
  psql  -h $PG_HOST -U $user $database -f database/indexes/events-indexes.sql
}

create-user
create-database
create-table
create-functions
create-indexes
