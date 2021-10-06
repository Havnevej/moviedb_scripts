-- STEP 1
-- create extension dblink 

-- create table table_testt (primary_title varchar(500));

--insert into table_testt
--SELECT primarytitle FROM dblink('dbname=imdb user=postgres password=Amazing1234', 'select primarytitle from title_basics')
--AS tt(primarytitle varchar(500))

-- Insert in db template
insert into title(title_id)
SELECT tconst FROM dblink('dbname=imdb user=postgres password=Amazing1234', 'select tconst from title_basics')
AS tt(tconst varchar(500))
              
						