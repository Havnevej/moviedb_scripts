--Deletes the entire schema with all tables from the sourcefile ' imdb_small.backup'.
--DROP SCHEMA public CASCADE;


--Drops all source tables
DROP TABLE name_basics, omdb_data, title_akas, title_basics, title_crew, title_episode, title_principals, title_ratings, omdb_data, wi;
/*
-- disconnect from the database to be renamed
\c postgres -- not working

-- force disconnect all other clients from the database to be renamed
SELECT pg_terminate_backend( pid )
FROM pg_stat_activity
WHERE pid <> pg_backend_pid( )
    AND datname = 'imdb_small';

-- rename the database (it should now have zero clients)
ALTER DATABASE "imdb_small" RENAME TO "moviedb" 



*/