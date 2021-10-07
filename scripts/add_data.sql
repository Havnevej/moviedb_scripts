--Title,title_basics
TRUNCATE "public".titletest;

INSERT INTO public.Title("title_id", "title_type", "original_title", 
"primary_title", "is_adult", "start_year", "end_year", "run_time_minutes" )
SELECT  "tconst","titletype","originaltitle","primarytitle","isadult","startyear","endyear","runtimeminutes"
FROM "public".title_basics; 

--Genre_key,
TRUNCATE "public".Genre_key;

INSERT INTO public.Genre_key("title_id") /*genre_id shold be auto incrementet*/
SELECT  "tconst"
FROM "public".title_basics; 

--Genre,
TRUNCATE "public".Genre;

INSERT INTO public.Genre("genre_id","genre_name")
SELECT "genre_id", --select with loop, that slits on comma
FROM "public".Genre_key;


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