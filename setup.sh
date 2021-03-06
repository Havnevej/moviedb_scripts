#!/bin/bash

#password raw9=AQoKETAs
#user=raw9
export PGPASSWORD='postgres'
user=postgres
export PGOPTIONS="-c client_min_messages=error"
order=('add_database_and_tables.sql' 'add_constraints.sql' 'add_data.sql' 'functions.sql' 'final.sql')
database_name="imdb"
server="127.0.0.1"

imdb_small="imdb_small.backup"
imdb_large="imdb_large.backup"

if test -f "./scripts/imdb_large.backup.icloud"; then
    imdb_large="./scripts/imdb_large.backup.icloud"
fi
if test -f "./scripts/imdb_small.backup.icloud"; then
    imdb_small="./scripts/imdb_small.backup.icloud"
fi

mkdir -p "./scripts/output/"

RED='\033[0;31m'
NC='\033[0m' # No Color

function setup_databases {
    if [ "$1" != "keep" ]; then 
        echo -e "${RED}dropping imdb database${NC}"
        psql -U "$user" -h $server  "-c drop database $database_name WITH(FORCE);"
        echo -e "${RED}creating imdb database${NC}"
        psql -U "$user" -h $server  "-c create database $database_name"
        echo -e "${RED}restoring imdb database from backup${NC}"
        if [ "$1" == "big" ]; then 
            psql -U "$user" -h $server  -d "$database_name" -q -f "./scripts/$imdb_large"
        else
            psql -U "$user" -h $server  -d "$database_name" -q -f "./scripts/$imdb_small"
        fi
    fi
}

function run_scripts {
    for script in "${order[@]}"; do
        echo -e "${RED}running script: $script ${NC}"
        psql -U "$user" -h $server -d "$database_name" -a -f "./scripts/$script" > "./scripts/output/$script.txt"
    done
}

if [ "$1" == "only_our" ]; then
    run_scripts
else
    if [ "$1" == "big" ]; then 
        if ! test -f "./scripts/$imdb_large"; then
            brew install wget unzip
            wget https://www.dropbox.com/s/nmh4l73wf79gubi/imdb_large.backup.zip?dl=1 -O "./scripts/large.zip"
            unzip "./scripts/large.zip" -d "./scripts/"
            rm "./scripts/large.zip"
        fi
        setup_databases "big"
    else
        setup_databases
    fi
    run_scripts
fi


