-- D1


-- D2 (Missing search history functionality)
create or replace function string_search(string char (20))
return table(
    title_id (char (20))
    primary_title (char (20))
) 
language plpgsql 
as
$$
begin
return query 
select Title.title_id, Title.primary_title
from Title
where Title.primary_title like '%' || string || '%' 
end; 
$$ 

-- D3 ()


-- D4 (Missing search history functionality)
create or replace function structured_string_search(title_ varchar, plot_ varchar, names_ varchar, characters_ varchar)
return table(
    title_id (varchar(20))
    primary_title (varchar(20))
)
language plpgsql 
as
$$
declare search_query text = concat(title_, ',', plot_, ',', names_, ',', characters_, ','); 
begin
return query
select Title.title_id, Title.primary_title from Title
natural join Omdb_data 
natural join Person 
natural join Characters 
where Title.primary_title like '%' || title_ || '%' and 
Omdb_data.plot like '%' || plot_|| '%' and
Person.person_name like '%' || names_ || '%' and
Characters.character_name like '%' || characters_ || '%'
end; 

-- D5 (Missing search history functionality)
create or replace function structured_string_search(title_ varchar, plot_ varchar, names_ varchar, characters_ varchar)
return table(
    title_id (varchar(20))
    primary_title (varchar(20))
    person_name (varchar(20))
)
language plpgsql 
as
$$
declare search_query text = concat(title_, ',', plot_, ',', names_, ',', characters_, ','); 
begin
return query
select Title.title_id, Title.primary_title from Title
natural join Omdb_data 
natural join Person 
natural join Characters 
where Title.primary_title like '%' || title_ || '%' and 
Omdb_data.plot like '%' || plot_|| '%' and
Person.person_name like '%' || names_ || '%' and
Characters.character_name like '%' || characters_ || '%'
end; 

-- D6 
create or replace function find_co_players ()
return table()
language plpgsqlas 
$$
begin
end;
$$

-- D7

-- D8

-- D9

-- D10
