#!/bin/bash

export PGPASSWORD='postgres'
export PGOPTIONS="-c client_min_messages=error"
order=('our_datebase.sql' 'add_consraint.sql' 'add_data.sql')
temp_database_name="imdb"
our_database_name="moviedb"
server="127.0.0.1"

RED='\033[0;31m'
NC='\033[0m' # No Color

function setup_databases {
    if [ -z "$1" ]; then
        if [ "$1" != "keep" ]; then 
            echo -e "${RED}dropping imdb database${NC}"
            psql -U postgres -h $server  "-c drop database $temp_database_name"
            echo -e "${RED}creating imdb database${NC}"
            psql -U postgres -h $server  "-c create database $temp_database_name"
            echo -e "${RED}restoring imdb database from backup${NC}"
            psql -U postgres -h $server  -d "$temp_database_name" -q -f "./scripts/imdb_small.backup"
        fi
    fi
    psql -U postgres -h $server  "-c drop database $our_database_name"
    psql -U postgres -h $server  "-c create database $our_database_name"
}

setup_databases

for script in "${order[@]}"; do
    echo -e "${RED}running script: $script ${NC}"
    psql -U postgres -h $server -d "$our_database_name" -q -f "./scripts/$script" 
done