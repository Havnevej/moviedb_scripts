########################################Setup
$PSQL=""
$env:PGPASSWORD='postgres'
$user="postgres"
$env:PGOPTIONS="-c client_min_messages=error"
$order = @("add_database_and_tables.sql", "add_constraints.sql", "add_data.sql", "functions_with_test.sql", "final.sql")
$database_name = "imdb"
$server = "127.0.0.1"
$ErrorActionPreference = "Stop"

if(Test-Path -Path "C:\Program Files\PostgreSQL\13\bin\psql.exe"){
    Write-Host "Using psql ver. 13"
    $PSQL="C:\Program Files\PostgreSQL\13\bin\psql.exe" #version 13
} elseif (Test-Path -Path "C:\Program Files\PostgreSQL\14\bin\psql.exe"){
    Write-Host "Using psql ver. 14"
    $PSQL="C:\Program Files\PostgreSQL\14\bin\psql.exe" #version 14
} elseif (Get-Command "psql" -errorAction SilentlyContinue){
    $PSQL="psql"
}
New-Item -ItemType Directory -Force -Path "./scripts/output/"
##########################################Code

function setup_databases{
    Write-Host "dropping imdb database" -ForegroundColor red
    & $PSQL -U $user -h $server  "-c drop database $database_name WITH (FORCE);"
    Write-Host "creating imdb database" -ForegroundColor red
    & $PSQL -U $user -h $server  "-c create database $database_name"
    Write-Host "restoring imdb database from backup" -ForegroundColor red
    if($args[0] -eq "big"){
        & $PSQL -U $user -h $server  -d "$database_name" -q -f "./scripts/imdb_large.backup"
    } else {
        & $PSQL -U $user -h $server  -d "$database_name" -q -f "./scripts/imdb_small.backup"
    }
}
function run_scripts{
    Write-Host "Running our scripts in order:"  -ForegroundColor green
    Write-Host "[$order]"  -ForegroundColor yellow
    foreach ($script in $order) {
        Write-Host "running $script" -ForegroundColor red
        & $PSQL -U $user -h $server -d "$database_name" -a -f "./scripts/$script" >> "./scripts/output/$script.txt"
    }
}
if($args[0] -eq "ours_only"){
    run_scripts
} else {
    if($args[0] -eq "big"){
        if(-Not (Test-Path -Path "./scripts/imdb_large.backup" -PathType Leaf)){
            $ProgressPreference = 'SilentlyContinue'
            Invoke-WebRequest -Uri "https://www.dropbox.com/s/nmh4l73wf79gubi/imdb_large.backup.zip?dl=1" -OutFile "./scripts/large.zip"
            Expand-Archive -LiteralPath "./scripts/large.zip" -DestinationPath "./scripts/"
            Remove-Item "./scripts/large.zip"
        }
        setup_databases big
    } else {
        setup_databases
    }
    run_scripts
}

