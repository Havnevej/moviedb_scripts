$PSQL="C:\Program Files\PostgreSQL\13\bin\psql.exe"
$env:PGPASSWORD='postgres'
$env:PGOPTIONS="-c client_min_messages=error"
$order = @('our_datebase.sql', 'add_consraint.sql', 'add_data.sql')
$temp_database_name = "imdb"
$our_database_name = "moviedb"
$server = "127.0.0.1"

function setup_databases{
    if($args[0] -ne "keep"){
        Write-Host "dropping imdb database" -ForegroundColor red
        & $PSQL -U postgres -h $server  "-c drop database $temp_database_name"
        Write-Host "creating imdb database" -ForegroundColor red
        & $PSQL -U postgres -h $server  "-c create database $temp_database_name"
        Write-Host "restoring imdb database from backup" -ForegroundColor red
        & $PSQL -U postgres -h $server  -d "$temp_database_name" -q -f "./scripts/imdb_small.backup"
    }
    & $PSQL -U postgres -h $server  "-c drop database $our_database_name"
    & $PSQL -U postgres -h $server  "-c create database $our_database_name"
}


setup_databases 'keep'
Write-Host "Running our scripts in order:"  -ForegroundColor green
Write-Host "[$order]\n\n"  -ForegroundColor yellow
foreach ($script in $order) {
    Write-Host "running $script" -ForegroundColor red
    & $PSQL -U postgres -h $server -d "$our_database_name" -q -f "./scripts/$script" 
}