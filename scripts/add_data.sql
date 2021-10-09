--Title,title_basics
TRUNCATE "public".titletest;

INSERT INTO public.Title("title_id", "title_type", "original_title", 
"primary_title", "is_adult", "start_year", "end_year", "run_time_minutes" )
SELECT  "tconst","titletype","originaltitle","primarytitle","isadult","startyear","endyear","runtimeminutes"
FROM "public".title_basics; 

--Title_rating,title_ratings
TRUNCATE "public".Title_rating;

INSERT INTO public.Title_rating("title_id", "rating_avg", "votes")
SELECT "tconst", "averagerating", "numvotes"
FROM "public".title_ratings;

--Word_index,wi
TRUNCATE "public".Word_index;

INSERT INTO public.Word_index("title_id", "word", "field", "lexeme")
SELECT "tconst", "word", "field", "lexeme"
FROM "public".wi;

--Episodes,title_episode
TRUNCATE "public".Episodes;

INSERT INTO public.Episodes("parent_title_id", "title_ud", "season_nr", "episode_nr")
SELECT "parenttconst", "tconst", "seasonnumber", "episodenumber"
FROM "public".title_episode;

--Person 
INSERT INTO public.Person ("person_id", "person_name","birthyear","deathyear") 
SELECT "nconst", "primaryname", "birthyear","deathyear"
from "public".name_basics

--Genre
INSERT INTO public.Genre(title_id,genre_name) 
SELECT tconst, unnest(string_to_array(genres, ','))
FROM title_basics;

--Profession 
INSERT INTO public.Profession("person_id", "profession_type")
SELECT nconst, unnest(string_to_array(primaryprofession, ',')) 
FROM name_basics

--Known_for_titles
INSERT INTO "public".Known_for_titles (person_id, title_id) 
SELECT nconst, unnest(string_to_array(knownfortitles, ','))
FROM name_basics;

--Characters
INSERT INTO "public".characters (person_id, title_id, character_name)
SELECT nconst, tconst, unnest(string_to_array(characters, ','))
FROM "public".title_principals;



/*
-- genre key
INSERT INTO public.genre_key("title_id", "genre_id")
SELECT "tconst", "genre_id"
FROM "public".title, "public".genre

-- profession key
INSERT INTO public.profession_key("person_id", "profession_id")
SELECT unnest(string_to_array(primaryprofession, ',')), nconst 
FROM name_basics

-- Known_for_tiles_key  = not implementet
*/


