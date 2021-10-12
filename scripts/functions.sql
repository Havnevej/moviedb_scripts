-- D1
create or replace function create_user(user_id varchar, user_name varchar, user_pwd varchar) returns void language plpgsql
as
$$
begin
	insert into "user" values (user_id, user_name, crypt(user_pwd, gen_salt('bf',4))); 
end;
$$;
--Create user
--select create_user('3', 'Larry', 'CatsAndDogs1234');

--Authentication:
--select * from "user" where "user".password = crypt('CatsAndDogs1234', password);

-----------------------------------------------------------------------------------------------------------------------------

-- Delete user
create or replace function delete_user(u_name varchar, u_pwd varchar) returns void language plpgsql
as
$$
begin

delete from "user" * where user_name = u_name and password = crypt(u_pwd, password);
end;
$$;

--selectdelete_user('Larry','CatsAndDogs1234');

-----------------------------------------------------------------------------------------------------------------------------

-- Update user 
create or replace function update_user(u_name varchar, u_pwd varchar, new_uname varchar) returns void language plpgsql
as
$$
begin

update "user" set user_name = new_uname where user_name = u_name and password = crypt(u_pwd, password);

end;
$$;

--select update_user('Larry', 'CatsAndDogs1234', 'John');

-----------------------------------------------------------------------------------------------------------------------------
--create functions for user_rating, bookmarks

-- bookmark_title
create or replace function bookmark_title (user_id varchar, title_id varchar) returns void language plpgsql
as
$$
begin
insert into bookmark_title values (user_id, title_id);
end;
$$;

-- bookmark_person
create or replace function bookmark_person (user_id varchar, person_id varchar) returns void language plpgsql
as
$$
begin
insert into bookmark_person values (user_id, person_id);
end;
$$;


-----------------------------------------------------------------------------------------------------------------------------
-- D2 (Missing search history functionality)
-- simple search
create or replace function string_search(string varchar)
returns table(
    title_id varchar,
    primary_title varchar
) 
language plpgsql 
as
$$
begin
return query 
select Title.title_id, Title.primary_title
from Title 
where Title.primary_title like '%' || string || '%'; 
end; 
$$; 

--select string_search('Parasite'); 

-----------------------------------------------------------------------------------------------------------------------------

-- Search with history log:
create or replace function string_search(string varchar, user_id varchar) returns 
table(
    t_id varchar,
    p_title varchar
) 

language plpgsql 
as
$$
	declare 
		date_now varchar;

	begin
		select TIMEOFDAY() into date_now;
		return query 
		select title_id, primary_title
		from title 
		where primary_title like '%' || string || '%';
		
		insert into search_history (user_id, search_string, "date")
		VALUES (user_id, string, date_now);
		
	end; 
$$; 

--select string_search('Parasite', '21');

-----------------------------------------------------------------------------------------------------------------------------

-- D3 ()
Create or replace function user_rate_title(user_id varchar, t_id varchar, user_rating int) returns void language plpgsql
as
$$
begin
insert into user_title_rating values (user_id, t_id, user_rating); --(user_id, title_id, rating)

update title_rating set rating_avg = 
((cast(user_rating as integer) + 
(cast(rating_avg as integer) * cast(votes as integer))) / cast(votes as integer) + 1)
, 
votes = cast(votes as integer) + 1 where 
title_rating.title_id = t_id;
end; 
$$;

--test query:
--select user_rate_title ('55', 'tt0108549 ', '10');
-----------------------------------------------------------------------------------------------------------------------------

-- D4 (Missing search history functionality)
create or replace function structured_string_search(title_ varchar, plot_ varchar, names_ varchar, characters_ varchar, user_id varchar)
returns table(
    title_id varchar,
    primary_title varchar
)
language plpgsql 
as
$$
declare 
search_query text = concat(title_, ',', plot_, ',', names_, ',', characters_); 
date_now varchar;
begin
select TIMEOFDAY() into date_now;
return query
select distinct title.title_id, title.primary_title from title
natural join omdb_data 
natural join person 
natural join characters_names
where title.primary_title like '%' || title_ || '%' and 
omdb_data.plot like '%' || plot_|| '%' and
person.person_name like '%' || names_ || '%' and
"characters_names".character_name like '%' || characters_ || '%';
insert into search_history (user_id, search_string, "date") VALUES (user_id, search_query, date_now);
end; 
$$;

-- select structured_string_search('Parasite', '', '', '', '12');

-----------------------------------------------------------------------------------------------------------------------------

--D.5
create or replace function search_by_actor_name(actor_name varchar, user_id varchar) returns 
table(
movie_title varchar,
"role" varchar
)
LANGUAGE plpgsql as
$$
declare 
date_now varchar;
begin
select TIMEOFDAY() into date_now;
return query
select title.primary_title, "characters_names".character_name from title natural join person natural join "characters_names" where person.person_name like
'%' ||  actor_name || '%';
insert into search_history (user_id, search_string, "date") VALUES (user_id, actor_name, date_now); 
end;
$$;

--select * from search_by_actor_name('Daniel', '22');


-----------------------------------------------------------------------------------------------------------------------------
-- D6

-- GET ALL CO-WORKERS:
create or replace function get_co_workers(name varchar) returns table(p_id varchar, p_name varchar, title varchar) language plpgsql as
$$
declare 
r record;
begin
	for r in SELECT distinct title_id from person natural join "characters_names" where person_name = name
	loop
	return query
	
	SELECT person_id, person_name, primary_title
	from person natural join "characters_names" natural join title 
	where title_id = r.title_id
	group by person_id, primary_title, person_name;
	end loop;
end;
$$;

--TEST QUERY:
--select * from get_co_workers('Daniel Craig');

-- GET MOST FREQUENT CO-WORKER
create or replace function m_freq_co_worker (person_name varchar, limitt integer) returns table (c_id varchar, c_name varchar, countt BIGINT) language plpgsql as
$$
begin
return query
select p_id, p_name, count(*) as countt 
from (select * from get_co_workers(person_name)) as x where p_name != person_name
GROUP BY p_id, p_name 
order by countt desc limit limitt;
end;
$$;

--select c_id as actor_id, c_name as actor_name, countt as frequency from m_freq_co_worker('Daniel Craig', 3)


--TEST QUERY
/*select p_name, count(*) as countt 
from (select * from get_co_workers('Daniel Craig')) as x 
GROUP BY p_name 
order by countt desc limit 3;*/

-----------------------------------------------------------------------------------------------------------------------------

-- D7
create or replace function person_rate2() returns void language plpgsql as
$$
declare 
r record;
begin
create index h on person(person_name);
for r in SELECT distinct person_name from person join characters_names on "characters_names".person_id=person.person_id join title_rating on "characters_names".title_id = title_rating.title_id join profession on profession.person_id = "characters_names".person_id where profession.profession_type = 'actor'
	loop
	insert into person_rating (person_id, person_name, rating, num_votes)
		values (
			(select person_id from person where person_name = r.person_name limit 1),
			
			(select person_name from person where person_name = r.person_name limit 1),
			
			(select sum(cast(rating_avg as integer))/count(rating_avg)
					from person join characters_names on person.person_id = "characters_names".person_id join title_rating on title_rating.title_id = "characters_names".title_id 
					where person_name = r.person_name limit 1),
					
			(select sum(cast(votes as integer)) from person join characters_names on person.person_id = "characters_names".person_id join title_rating on 
					title_rating.title_id = "characters_names".title_id 
					where person_name = r.person_name limit 1)
		);	
	end loop;
end;
$$;

--select person_rate2();


-----------------------------------------------------------------------------------------------------------------------------

-- D8

create or replace function movie_cast(inputt varchar) returns table ("cast" varchar, rating bigint) language plpgsql
as
$$
begin

return query

select rr.person_name, rr.rating from title join "characters_names" on title.title_id = "characters_names".title_id join person_rating as rr on rr.person_id = "characters_names".person_id where title.primary_title like '%' || inputt || '%'
ORDER BY rating desc;

end;
$$;

--select * FROM movie_cast('Casino Royale');

--

create or replace function co_actor_popularity(inputt varchar) returns table (actor_name varchar, rating bigint) language plpgsql
as 
$$
begin

return query
select x.c_name as actor_name, pp.rating from (select * from m_freq_co_worker(inputt,10)) as x join person_rating as pp on pp.person_id = x.c_id ORDER BY pp.rating
desc;

end;
$$;

--select * from co_actor_popularity('Daniel Craig');


-----------------------------------------------------------------------------------------------------------------------------


-- D9

create or replace function similar_titles(title_ varchar)
returns table(
    title_id varchar,
    title varchar,
    genre varchar
)
language plpgsql
as
$$
declare r record; 
begin
select * from genre join title on title.title_id = genre.title_id into r where primary_title = title_;
return query
select  s.title_id, s.primary_title, f.genre_name from genre as f join title as s on s.title_id = f.title_id where f.genre_name like '%' || r.genre_name || '%';
end;
$$;

--select * from similar_titles ('Casino Royale');

-----------------------------------------------------------------------------------------------------------------------------

-- D10

-----------------------------------------------------------------------------------------------------------------------------

-- D11

create or replace function exact_match(inputt1 varchar, inputt2 varchar, inputt3 varchar) returns table (_title_id varchar, movie_title varchar) language plpgsql as 
$$
begin
return query
SELECT t.title_id, primary_title FROM title t,
(SELECT title_id from word_index where word = inputt1
INTERSECT
SELECT title_id from word_index where word = inputt2
INTERSECT
SELECT title_id from word_index where word = inputt3) w
WHERE t.title_id=w.title_id;
end;
$$;

--select * from exact_match('apple', 'mads', 'mikkelsen');

-----------------------------------------------------------------------------------------------------------------------------

-- D12
/*
CREATE or replace FUNCTION best_match(VARIADIC w text[])
RETURNS text AS $$
DECLARE
w_elem text;
t text := 'The counts are: ';
BEGIN
FOREACH w_elem IN ARRAY w
LOOP
t := t || w_elem || ' ' ||
(select count(tconst) from wi where wi.word = w_elem) || ' ';
END LOOP;
RETURN t;
END $$
LANGUAGE 'plpgsql';

--------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION best_match
(w1 varchar, w2 varchar, w3 varchar)
RETURNS TABLE (tconst char(10), rank bigint, title text)
AS $$
SELECT t.tconst, sum(relevance) rank, primarytitle FROM title_basics t,
(SELECT distinct tconst, 1 relevance FROM wi WHERE word = w1
UNION ALL
SELECT distinct tconst, 1 relevance FROM wi WHERE word = w2
UNION ALL
SELECT distinct tconst, 1 relevance FROM wi WHERE word = w3) w
WHERE t.tconst=w.tconst
GROUP BY t.tconst, primarytitle ORDER BY rank DESC;
$$
LANGUAGE 'sql';
SELECT * FROM bestmatch3('apple','mads','mikkelsen');*/

-----------------------------------------------------------------------------------------------------------------------------

-- D13

-----------------------------------------------------------------------------------------------------------------------------