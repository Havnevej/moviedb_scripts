-- D1
--Create table "user"(user_id varchar, user_name varchar, "password" varchar)
CREATE EXTENSION pgcrypto;
create or replace function create_user(user_id varchar, user_name varchar, user_pwd varchar) returns void language plpgsql
as
$$
begin
	insert into "user" values (user_id, user_name, crypt(user_pwd, gen_salt('bf',4))); 
end;
$$
--Create user
select create_user('3', 'Larry', 'CatsAndDogs1234');

--Authentication:
SELECT * from "user" where "user".password = crypt('CatsAndDogs1234', password)

-----------------------------------------------------------------------------------------------------------------------------

-- Delete user
create or replace function delete_user(u_name varchar, u_pwd varchar) returns void language plpgsql
as
$$
begin

delete from "user" * where user_name = u_name and password = crypt(u_pwd, password);
end;
$$

SELECT delete_user('Larry','CatsAndDogs1234');

-----------------------------------------------------------------------------------------------------------------------------

-- Update user
create or replace function update_user(u_name varchar, u_pwd varchar, new_uname varchar) returns void language plpgsql
as
$$
begin

update "user" set user_name = new_uname where user_name = u_name and password = crypt(u_pwd, password);

end;
$$

SELECT update_user('Larry', 'CatsAndDogs1234', 'John');


-----------------------------------------------------------------------------------------------------------------------------

--create rating table
create table user_title_rating(user_id varchar, title_id varchar, rating varchar)

create table bookmark_title(user_id varchar, title_id varchar)

create table bookmark_person(user_id varchar, person_id varchar)

-----------------------------------------------------------------------------------------------------------------------------

--D1
--create functions for user_rating, bookmarks
Create or replace function user_rate_title(user_id varchar, title_id varchar, user_rating int) returns void language plpgsql
as
$$
begin
insert into user_title_rating values (user_id, title_id, user_rating); --(user_id, title_id, rating)
end; 
$$

select user_rate_title ('55', '1242325', '9')

-- bookmark_title
create or replace function bookmark_title (user_id varchar, title_id varchar) returns void language plpgsql
as
$$
begin
insert into bookmark_title values (user_id, title_id);
end;
$$

-- bookmark_person
create or replace function bookmark_person (user_id varchar, person_id varchar) returns void language plpgsql
as
$$
begin
insert into bookmark_person values (user_id, person_id);
end;
$$


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
$$ 

select string_search('Parasite') 

-----------------------------------------------------------------------------------------------------------------------------

-- Search with history log:

--create table search_history(user_id varchar, search_string varchar, "date" varchar)

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
$$ 

select string_search('Parasite', '21')

-----------------------------------------------------------------------------------------------------------------------------

-- D3 ()
create or replace function rate(title varchar (20), rate varchar(5))
-- continuation

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
natural join "characters" 
where title.primary_title like '%' || title_ || '%' and 
omdb_data.plot like '%' || plot_|| '%' and
person.person_name like '%' || names_ || '%' and
"characters".character_name like '%' || characters_ || '%';
insert into search_history (user_id, search_string, "date") VALUES (user_id, search_query, date_now);
end; 
$$

select structured_string_search('Parasite', '', '', '', '12')

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
select title.primary_title, "characters".character_name from title natural join person natural join "characters" where person.person_name like
'%' ||  actor_name || '%';
insert into search_history (user_id, search_string, "date") VALUES (user_id, actor_name, date_now); 
end;
$$

select * from search_by_actor_name('Daniel', '22')


-----------------------------------------------------------------------------------------------------------------------------


 
-----------------------------------------------------------------------------------------------------------------------------

-- D6
create or replace function coplayer(name_ varchar(20))
return table(
    person_id varchar,
    person_name varchar,
    number_of_titles varchar
)
language plpgsql 
as
$$
begin
return query 
select Person.person_id, Person.person_name, count(Title.title_id) from Person
natural join Title
where Title.title_id --continuation 
end; 

-- D7

-- D8

-- D9

-- D10