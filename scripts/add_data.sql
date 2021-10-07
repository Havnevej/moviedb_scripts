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

INSERT INTO public.Title("title_id", "rating_avg", "votes")
SELECT "tconst", "", ""
FROM "public".title_ratings;

hej noel 
hej noel
hej noel 
hej noel 
hej noel 
hej noel 
hej noel 
hej noel 
hej noel 
hej noel 