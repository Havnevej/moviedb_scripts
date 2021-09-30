#!/bin/bash

PSQL="C:\Program Files\PostgreSQL\13\bin\psql.exe"

PSQL -U postgres -c "create database imdb"
PSQL -U postgres -d imdb -f imdb_small.backup