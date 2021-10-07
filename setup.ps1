$PSQL="C:\Program Files\PostgreSQL\13\bin\psql.exe"
$env:PGPASSWORD='postgres'
$order = @('our_datebase.sql', 'add_constraint.sql', 'add_data.sql')
$temp_database_name = "imdb"
$our_database_name = "moviedb"
$server = "127.0.0.1"



& $PSQL -U postgres -h $server  "-c create database $temp_database_name"
& $PSQL -U postgres -h $server  "-c create database $our_database_name"
& $PSQL -U postgres -h $server  -d "$temp_database_name" -f "./scripts/imdb_small.backup"

foreach ($script in $order) {
    & $PSQL -U postgres -h $server -d "$our_database_name" -f "./scripts/$script"
}