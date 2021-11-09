--Title,title_basics
INSERT INTO public.Title("title_id", "title_type", "original_title", 
"primary_title", "is_adult", "start_year", "end_year", "run_time_minutes" )
SELECT DISTINCT on ("tconst") "tconst","titletype","originaltitle","primarytitle","isadult","startyear","endyear","runtimeminutes"
FROM "public".title_basics; 

--Title_rating,title_ratings
INSERT INTO public.Title_rating("title_id", "rating_avg", "votes")
SELECT DISTINCT on ("tconst") "tconst", "averagerating", "numvotes"
FROM "public".title_ratings;

--Word_index,wi
INSERT INTO public.Word_index("title_id", "word", "field", "lexeme")
SELECT DISTINCT on ("tconst", "word", "field") "tconst", "word", "field", "lexeme"
FROM "public".wi;

--Episodes,title_episode
INSERT INTO public.Episodes("parent_title_id", "title_id", "season_nr", "episode_nr")
SELECT DISTINCT on ("tconst", "parenttconst") "parenttconst", "tconst", "seasonnumber", "episodenumber"
FROM "public".title_episode;

--Person 
INSERT INTO public.Person ("person_id", "person_name","birthyear","deathyear") 
SELECT DISTINCT on ("nconst") "nconst", "primaryname", "birthyear","deathyear"
FROM "public".name_basics;

--Genre
INSERT INTO public.Genre(title_id,genre_name) 
SELECT DISTINCT on ("tconst") tconst, unnest(string_to_array(genres, ','))
FROM title_basics;

--Profession 
INSERT INTO public.Profession("person_id", "profession_type")
SELECT nconst, unnest(string_to_array(primaryprofession, ',')) 
FROM name_basics;

--Known_for_titles
INSERT INTO "public".Known_for_titles (person_id, title_id) 
SELECT nconst, unnest(string_to_array(knownfortitles, ','))
FROM name_basics;

--Character_names
INSERT INTO "public".character_names_temp (person_id, title_id, character_name)
SELECT 
	DISTINCT on (nconst, tconst, unnest(string_to_array(characters, ',')))
		nconst, tconst, unnest(string_to_array(characters, ','))
FROM "public".title_principals;
--DROP TABLE "public".character_names;
ALTER TABLE "public".character_names_temp
RENAME TO character_names;

--Omdb
INSERT INTO public.omdb ("title_id", "poster","awards","plot") 
SELECT DISTINCT on ("tconst") "tconst", "poster","awards","plot"
FROM "public".omdb_data;

--Principals
INSERT INTO public.principals ("title_id", "ordering","person_id","category", "job") 
SELECT DISTINCT on ("tconst", "ordering") tconst, ordering, nconst, category, job
FROM "public".title_principals;

--Title_version
INSERT INTO public.Title_versions ("title_id", "title_version", "title_name", "region","language", "types", "attributes", "is_original_title") 
SELECT DISTINCT on ("titleid", "ordering") title, region, "language", types, attributes, isoriginaltitle
FROM "public".title_akas;

--Writer 
INSERT INTO public.Writer_temp(title_id, writer_id)
SELECT 
	DISTINCT on (tconst, unnest(string_to_array(writers, ',')))
		tconst, unnest(string_to_array(writers, ','))
FROM title_crew;
ALTER TABLE "public".Writer_temp
RENAME TO Writer;

--Director
INSERT INTO public.Director_temp(title_id, director_id)
SELECT 
	DISTINCT on (tconst, unnest(string_to_array(directors, ',')))
		tconst, unnest(string_to_array(directors, ','))
FROM title_crew;
ALTER TABLE "public".Director_temp
RENAME TO Director;


/*
--Director 
INSERT INTO public.Director_temp("title_id", "director_id")
SELECT (tconst, unnest(string_to_array(directors, ','))) 
FROM title_crew;

INSERT INTO "public".character_names_temp (person_id, title_id, character_name)
SELECT 
	DISTINCT on (nconst, tconst, unnest(string_to_array(characters, ',')))
		nconst, tconst, unnest(string_to_array(characters, ','))
FROM "public".title_principals;
--DROP TABLE "public".character_names;
ALTER TABLE "public".character_names_temp
RENAME TO character_names;

*/