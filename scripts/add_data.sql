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

-- person 
INSERT INTO public.person ("person_id", "person_name","birthyear","deathyear") 
SELECT "nconst", "primaryname", "birthyear","deathyear"
from "public".name_basics

-- genre
INSERT INTO genre (genre_name) select distinct trim(unnest(string_to_array(title_basics.genres, ','))) from title_basics;

-- genre key
INSERT INTO public.genre_key("title_id", "genre_id")
SELECT "tconst", "genre_id"
FROM "public".title, "public".genre

-- profession 
INSERT INTO profession (profession_type) 
select distinct trim(unnest(string_to_array(primaryprofession, ','))) 
from name_basics;


-- profession key
/*
select unnest(string_to_array(primaryprofession, ',')),nconst 
from name_basics
*/

INSERT INTO public.profession_key("person_id", "profession_id")
SELECT unnest(string_to_array(primaryprofession, ',')), nconst 
FROM name_basics



/*
INSERT INTO public.profession_key("person_id", "profession_id")
SELECT "person_id", "profession_id" 
FROM "public".person, "public".profession
*/

-- Known_for_titles
INSERT INTO known_for_titles (title_id) 
select distinct trim(unnest(string_to_array(knownfortitles, ','))) 
from name_basics;




-- Known_for_tiles_key


-- character split
insert into public.character(character,person_id,title_id) 
select unnest(string_to_array(characters, ','))as character,nconst,tconst 
from title_principals