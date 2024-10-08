#!/bin/bash
set -ex

POSTGRES="psql --username ${POSTGRES_USER}"

echo "Creating database: ${POSTGRES_DB}"
echo "Creating database: ${POSTGRES_TEST_DB}"

$POSTGRES <<EOSQL
CREATE DATABASE "${POSTGRES_DB}" OWNER "${POSTGRES_USER}";
CREATE DATABASE "${POSTGRES_TEST_DB}" OWNER "${POSTGRES_USER}";
EOSQL


$POSTGRES $POSTGRES_DB <<EOSQL
CREATE EXTENSION postgis;
CREATE EXTENSION plpgsql;
CREATE EXTENSION fuzzystrmatch;
CREATE EXTENSION postgis_tiger_geocoder;
CREATE EXTENSION postgis_topology;
EOSQL

$POSTGRES $POSTGRES_TEST_DB <<EOSQL
CREATE EXTENSION postgis;
CREATE EXTENSION plpgsql;
CREATE EXTENSION fuzzystrmatch;
CREATE EXTENSION postgis_tiger_geocoder;
CREATE EXTENSION postgis_topology;
EOSQL
