--Title,title_basics
TRUNCATE "public".title;

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
INSERT INTO public.person ("person_id", "person_name","birthyear","deathyear") 
SELECT "nconst", "primaryname", "birthyear","deathyear"
from "public".name_basics

--Genre
INSERT INTO pulic.genre(title_id,genre_name) 
SELECT DISTINCT trim(unnest(string_to_array(title_basics.genres, ','))) 
FROM title_basics;

--Profession 
INSERT INTO public.profession("person_id", "profession_type")
SELECT nconst, unnest(string_to_array(primaryprofession, ',')) 
FROM name_basics

--Known_for_titles
INSERT INTO known_for_titles (title_id) 
select distinct trim(unnest(string_to_array(knownfortitles, ','))) 
from name_basics;

/*
-- Genre_key
INSERT INTO public.genre_key("title_id", "genre_id")
SELECT "tconst", "genre_id"
FROM "public".title, "public".genre

-- Profession_key
INSERT INTO public.profession_key("person_id", "profession_id")
SELECT unnest(string_to_array(primaryprofession, ',')), nconst 
FROM name_basics


*/






