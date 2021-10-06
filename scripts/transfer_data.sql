-- STEP 1
-- create extension dblink 

-- create table table_testt (primary_title varchar(500));

--insert into table_testt
--SELECT primarytitle FROM dblink('dbname=imdb user=postgres password=Amazing1234', 'select primarytitle from title_basics')
--AS tt(primarytitle varchar(500))

-- Insert in db template

--insert into title(title_id)
--SELECT tconst FROM dblink('dbname=imdb user=postgres password=Amazing1234', 'select tconst from title_basics')
--AS tt(tconst varchar(500))
  
--transfer data to title: 

insert into title (title_id, title_type, original_title, primary_title, is_adult, start_year, end_year, run_time_minutes)

SELECT tconst, titletype, originaltitle, primarytitle, isadult, startyear, endyear, runtimeminutes 
FROM dblink('dbname=imdb user=postgres password=Amazing1234', 'select tconst, titletype, originaltitle, primarytitle, isadult, startyear, endyear, runtimeminutes from title_basics')
AS tt(tconst VARCHAR, titletype VARCHAR, originaltitle varchar, primarytitle varchar, isadult boolean, startyear VARCHAR, endyear VARCHAR, runtimeminutes integer)						

--NOTE: the table was altered into the following form:
/*CREATE TABLE public.title(
    title_id character(20),
    title_type character(20),
    original_title varchar(150),
    primary_title varchar(150),
    is_adult boolean,
    start_year VARCHAR(4),
    end_year VARCHAR(4),
    run_time_minutes Integer
);*/

