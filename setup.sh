#!/bin/bash

export PGPASSWORD='postgres'
export PGOPTIONS="-c client_min_messages=error"
order=('add_database_and_tables.sql' 'add_constraints.sql' 'add_data.sql' 'functions.sql' 'final.sql')
database_name="imdb"
server="127.0.0.1"

RED='\033[0;31m'
NC='\033[0m' # No Color

function setup_databases {
    if [ -z "$1" ]; then
        if [ "$1" != "keep" ]; then 
            echo -e "${RED}dropping imdb database${NC}"
            psql -U postgres -h $server  "-c drop database $database_name WITH(FORCE);"
            echo -e "${RED}creating imdb database${NC}"
            psql -U postgres -h $server  "-c create database $database_name"
            echo -e "${RED}restoring imdb database from backup${NC}"
            if [ "$1" == "big" ]; then 
                psql -U postgres -h $server  -d "$database_name" -q -f "./scripts/imdb_large.backup"
            else
                psql -U postgres -h $server  -d "$database_name" -q -f "./scripts/imdb_small.backup"
            fi
        fi
    fi
}

function run_scripts {
    for script in "${order[@]}"; do
        echo -e "${RED}running script: $script ${NC}"
        psql -U postgres -h $server -d "$database_name" -q -f "./scripts/$script" 
    done
}

if [ "$1" == "only_our" ]; then
    run_scripts
else
    if [ "$1" == "big" ]; then 
        if ! test -f "./scripts/imdb_large.backup"; then
            sudo apt install unzip
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


