-- D1
--Create table "user"(user_id varchar, user_name varchar, "password" varchar)
CREATE EXTENSION pgcrypto;
create or replace function create_user(user_id varchar, user_name varchar, user_pwd varchar) returns void language plpgsql
as
$$
begin
	insert into "user" values (user_id, user_name, crypt(user_pwd, gen_salt('bf',4))); 
end;
$$;
--Create user
select create_user('3', 'Larry', 'CatsAndDogs1234');

--Authentication:
SELECT * from "user" where "user".password = crypt('CatsAndDogs1234', password);

-----------------------------------------------------------------------------------------------------------------------------

-- Delete user
create or replace function delete_user(u_name varchar, u_pwd varchar) returns void language plpgsql
as
$$
begin

delete from "user" * where user_name = u_name and password = crypt(u_pwd, password);
end;
$$;

SELECT delete_user('Larry','CatsAndDogs1234');

-----------------------------------------------------------------------------------------------------------------------------

-- Update user 
create or replace function update_user(u_name varchar, u_pwd varchar, new_uname varchar) returns void language plpgsql
as
$$
begin

update "user" set user_name = new_uname where user_name = u_name and password = crypt(u_pwd, password);

end;
$$;

SELECT update_user('Larry', 'CatsAndDogs1234', 'John');


-----------------------------------------------------------------------------------------------------------------------------

--create rating table

create table user_title_rating(user_id varchar, title_id varchar, rating varchar);

--create bookmark_title
create table bookmark_title(user_id varchar, title_id varchar);

--create bookmark_person
create table bookmark_person(user_id varchar, person_id varchar);


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
-- D2
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

select string_search('Parasite'); 

-----------------------------------------------------------------------------------------------------------------------------

-- Search with history log:

create table search_history(user_id varchar, search_string varchar, "date" varchar);

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

select string_search('Parasite', '21');

-----------------------------------------------------------------------------------------------------------------------------

-- D3
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
select user_rate_title ('55', 'tt0108549 ', '10');
-----------------------------------------------------------------------------------------------------------------------------

-- D4
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
natural join "characters" 
where title.primary_title like '%' || title_ || '%' and 
omdb_data.plot like '%' || plot_|| '%' and
person.person_name like '%' || names_ || '%' and
"characters".character_name like '%' || characters_ || '%';
insert into search_history (user_id, search_string, "date") VALUES (user_id, search_query, date_now);
end; 
$$;

select structured_string_search('Parasite', '', '', '', '12');

-----------------------------------------------------------------------------------------------------------------------------

-- D5
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
select title.primary_title, "characters".character_name from title natural join person natural join "characters" where person.person_name like
'%' ||  actor_name || '%';
insert into search_history (user_id, search_string, "date") VALUES (user_id, actor_name, date_now); 
end;
$$;

select * from search_by_actor_name('Daniel', '22');


-----------------------------------------------------------------------------------------------------------------------------
-- D6

-- GET ALL CO-WORKERS:
create or replace function get_co_workers(name varchar) returns table(p_id varchar, p_name varchar, title varchar) language plpgsql as
$$
declare 
r record;
begin
	for r in SELECT distinct title_id from person natural join "characters" where person_name = name
	loop
	return query
	
	SELECT person_id, person_name, primary_title
	from person natural join "characters" natural join title 
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

select c_id as actor_id, c_name as actor_name, countt as frequency from m_freq_co_worker('Daniel Craig', 10)


--TEST QUERY
/*select p_name, count(*) as countt 
from (select * from get_co_workers('Daniel Craig')) as x 
GROUP BY p_name 
order by countt desc limit 3;*/

-----------------------------------------------------------------------------------------------------------------------------

-- D7

create table person_rating (person_id varchar, person_name varchar, rating bigint, num_votes bigint);

create or replace function person_rate2() returns void language plpgsql as
$$
declare 
r record;
begin
create index h on person(person_name);
for r in SELECT distinct person_name from person join characters on "characters".person_id=person.person_id join title_rating on "characters".title_id = title_rating.title_id join profession on profession.person_id = "characters".person_id where profession.profession_type = 'actor'
	loop
	insert into person_rating (person_id, person_name, rating, num_votes)
		values (
			(select person_id from person where person_name = r.person_name limit 1),
			
			(select person_name from person where person_name = r.person_name limit 1),
			
			(select sum(cast(rating_avg as integer))/count(rating_avg)
					from person join characters on person.person_id = "characters".person_id join title_rating on title_rating.title_id = "characters".title_id 
					where person_name = r.person_name limit 1),
					
			(select sum(cast(votes as integer)) from person join characters on person.person_id = "characters".person_id join title_rating on 
					title_rating.title_id = "characters".title_id 
					where person_name = r.person_name limit 1)
		);	
	end loop;
end;
$$;

select person_rate2();

if num_votes > 100000 * 1.2
-----------------------------------------------------------------------------------------------------------------------------

-- D8

create or replace function movie_cast(inputt varchar) returns table ("cast" varchar, rating bigint) language plpgsql
as
$$
begin

return query

select rr.person_name, rr.rating from title join "characters" on title.title_id = "characters".title_id join person_rating as rr on rr.person_id = "characters".person_id where title.primary_title like '%' || inputt || '%'
ORDER BY rating desc;

end;
$$;

SELECT * FROM movie_cast('Casino Royale');

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

select * from co_actor_popularity('Daniel Craig');


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

select * from similar_titles ('Casino Royale');

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

SELECT * from exact_match('apple', 'mads', 'mikkelsen');

-----------------------------------------------------------------------------------------------------------------------------

-- D12

CREATE OR REPLACE FUNCTION best_match
(w1 varchar, w2 varchar, w3 varchar)
RETURNS TABLE (_title_id varchar, "rank" bigint, title varchar) LANGUAGE plpgsql
AS $$
begin
return query
SELECT t.title_id, sum(relevance) rank, primary_title FROM title t,
(SELECT distinct title_id, 1 relevance FROM word_index WHERE word = w1
UNION ALL
SELECT distinct title_id, 1 relevance FROM word_index WHERE word = w2
UNION ALL
SELECT distinct title_id, 1 relevance FROM word_index WHERE word = w3) w
WHERE t.title_id = w.title_id
GROUP BY t.title_id, primary_title ORDER BY rank DESC limit 10;
end;
$$;

SELECT * FROM best_match('apple','mads','mikkelsen');

-----------------------------------------------------------------------------------------------------------------------------

-- D13

create or replace function word_to_word(variadic inputt text[]) returns table (movie_name varchar, rank bigint) language plpgsql as 
$$
declare 
elem text;
begin 
foreach elem in array inputt
loop
raise notice '%', elem;
return query 
SELECT tt.primary_title, count(ww.word) as title_name from title as tt join word_index as ww on tt.title_id = ww.title_id where ww.word like '%' || elem || '%' 
GROUP BY tt.primary_title, ww.word
order by count(ww.word) desc limit 10;
end loop;
end;
$$;

SELECT * from word_to_word('olivia', 'jim', 'corin') order by rank desc; 
