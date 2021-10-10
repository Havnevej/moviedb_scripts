$PSQL=""
$env:PGPASSWORD='postgres'
$env:PGOPTIONS="-c client_min_messages=error"
$order = @("add_database_and_tables.sql", "add_constraints.sql", "add_data.sql", "functions.sql", "final.sql")
$database_name = "imdb"
$server = "127.0.0.1"

if(Test-Path -Path "C:\Program Files\PostgreSQL\13\bin\psql.exe"){
    Write-Host "Using psql ver. 13"
    $PSQL="C:\Program Files\PostgreSQL\13\bin\psql.exe" #version 13
} elseif (Test-Path -Path "C:\Program Files\PostgreSQL\14\bin\psql.exe"){
    Write-Host "Using psql ver. 14"
    $PSQL="C:\Program Files\PostgreSQL\14\bin\psql.exe" #version 14
}

function setup_databases{
    Write-Host "dropping imdb database" -ForegroundColor red
    & $PSQL -U postgres -h $server  "-c drop database $database_name WITH (FORCE);"
    Write-Host "creating imdb database" -ForegroundColor red
    & $PSQL -U postgres -h $server  "-c create database $database_name"
    Write-Host "restoring imdb database from backup" -ForegroundColor red
    & $PSQL -U postgres -h $server  -d "$database_name" -q -f "./scripts/imdb_small.backup"
}
function run_scripts{
    Write-Host "Running our scripts in order:"  -ForegroundColor green
    Write-Host "[$order]"  -ForegroundColor yellow
    foreach ($script in $order) {
        Write-Host "running $script" -ForegroundColor red
        & $PSQL -U postgres -h $server -d "$database_name" -q -f "./scripts/$script" 
    }
}
if($args[0] -eq "ours_only"){
    run_scripts
} else {
    setup_databases
    run_scripts
}

