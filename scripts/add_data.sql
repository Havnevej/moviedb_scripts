--Title,title_basics
INSERT INTO public.Title("title_id", "title_type", "original_title", 
"primary_title", "is_adult", "start_year", "end_year", "run_time_minutes" )
SELECT DISTINCT on ("tconst") "tconst","titletype","originaltitle","primarytitle","isadult","startyear","endyear","runtimeminutes"
FROM "public".title_basics; 

--Title_version
INSERT INTO public.Title_versions ("title_id", "title_version", "title_name", "region","language", "types", "attributes", "is_original_title") 
SELECT DISTINCT on ("titleid", "ordering") titleid, ordering, title, region, language, types, attributes, isoriginaltitle
FROM "public".title_akas;

--Title_rating,title_ratings
INSERT INTO public.Title_rating("title_id", "rating_avg", "votes")
SELECT DISTINCT on ("tconst") "tconst", "averagerating", "numvotes"
FROM "public".title_ratings;

--Omdb
INSERT INTO public.omdb ("title_id", "poster","awards","plot") 
SELECT DISTINCT on ("tconst") tconst, poster, awards, plot
FROM "public".omdb_data;

--Word_index,wi
INSERT INTO public.Word_index("title_id", "word", "field", "lexeme")
SELECT DISTINCT on ("tconst", "word", "field") "tconst", "word", "field", "lexeme"
FROM "public".wi;

--Episodes,title_episode
INSERT INTO public.Episodes("parent_title_id", "title_id", "season_nr", "episode_nr")
SELECT DISTINCT on ("tconst", "parenttconst") "parenttconst", "tconst", "seasonnumber", "episodenumber"
FROM "public".title_episode;

--Person 
INSERT INTO public.Person ("person_id", "person_name","birthyear","deathyear") 
SELECT DISTINCT on ("nconst") "nconst", "primaryname", "birthyear","deathyear"
FROM "public".name_basics;

--Genre
INSERT INTO public.Genre(title_id,genre_name) 
SELECT DISTINCT on ("tconst") tconst, unnest(string_to_array(genres, ','))
FROM title_basics;

--Profession 
INSERT INTO public.Profession("person_id", "profession_type")
SELECT nconst, unnest(string_to_array(primaryprofession, ',')) 
FROM name_basics;

--Character_names
INSERT INTO "public".character_names_temp (person_id, title_id, character_name)
SELECT 
	DISTINCT on (nconst, tconst, unnest(string_to_array(characters, ',')))
		nconst, tconst, unnest(string_to_array(characters, ','))
FROM "public".title_principals;
--DROP TABLE "public".character_names;
ALTER TABLE "public".character_names_temp
RENAME TO character_names;

--Principals
INSERT INTO public.principals ("title_id", "ordering","person_id","category", "job") 
SELECT DISTINCT on ("tconst", "ordering") tconst, ordering, nconst, category, job
FROM "public".title_principals;

--Writer 
INSERT INTO public.Writer_temp(title_id, writer_id)
SELECT 
	DISTINCT on (tconst, unnest(string_to_array(writers, ',')))
		tconst, unnest(string_to_array(writers, ','))
FROM title_crew;
ALTER TABLE "public".Writer_temp
RENAME TO Writer;

--Director
INSERT INTO public.Director_temp(title_id, director_id)
SELECT 
	DISTINCT on (tconst, unnest(string_to_array(directors, ',')))
		tconst, unnest(string_to_array(directors, ','))
FROM title_crew;
ALTER TABLE "public".Director_temp
RENAME TO Director;

--User
INSERT INTO "user"(user_id, username, "password", salt, created_date, is_admin) values (1, 'JLP', 
'mF6mRnm3eR/dju78eV3rGytsldfCWRLi8FpUUs2g2zQJKZNbkVWzkKkDSqvzbXA228Dz8DbJeu36Oqcmgw0jmFMeO3+t5VmMrUSz7daiZ7W1OAr7bJi9ZxQ99GfspgKtqXNBO6Ao2GGeCozrrTmXzjHrX4gXrTy8pJu3QpFdtIsgmHslXp9GyH0BJxJiJXiN1nWPBQP8b5oiodCsDk4F2O2hyVRXK7KGZ/Eov7h+U04vlhE87PsV7lLsy2r2arVZi4AJN64Fo2s9aOUiBIUZmOJmkdFfiVy4+uc1QogGM9IY04gblDro9rSKgFa7oIYQWmy30mP5Vg5/5/wrETtlsg==', 'XYrQRcopAN1ik9RarIitmmbLjQDoXaL6yewQzLjlTZG6Z36KrRwTYUTCLIUoSgu0Yg9H9n2Ilnzg03iTkQ5PiMgD/vS1fvSRiJDyVLCYfcVcFvh4b3aHdluoOCsQIkLbey6BHOifrCTz3wPkCA2g7XwVGYk+bTF1ne4xExH1QKMVdXCBK5FuT0D8ia1Ll8MU00LntUKPl/2XcCHz9/5uwr5ayYrwQGX4h3xxp7YpzudEv7fQ5ADAnMAKZsDs2UaCKxWdcY/9myKjgTvA93DYVtNCsinVf4Ih9kJ9mhiezcBkvb9FI06ipnh2mZnagDyQyh4ezwfHhWkxyknfUBWwoA==',
'2021-11-17', 'true');

--Search_history
INSERT INTO "search_history"(username,search_string,search_date) VALUES ('JLP', 'parasite', '2021-11-17 14:07:35');


--Known_for_titles
CREATE TEMP TABLE IF NOT EXISTS temp_table(person_id VARCHAR, title_id VARCHAR);
INSERT INTO temp_table (person_id, title_id)
	SELECT nconst, unnest(string_to_array(knownfortitles, ',')) from name_basics;

INSERT INTO "public".known_for_titles(person_id, title_id)
	SELECT * FROM temp_table as tp
		WHERE EXISTS (
				SELECT *
				FROM title
				WHERE title_id = tp.title_id
		);



/*
--Director 
INSERT INTO public.Director_temp("title_id", "director_id")
SELECT (tconst, unnest(string_to_array(directors, ','))) 
FROM title_crew;

INSERT INTO "public".character_names_temp (person_id, title_id, character_name)
SELECT 
	DISTINCT on (nconst, tconst, unnest(string_to_array(characters, ',')))
		nconst, tconst, unnest(string_to_array(characters, ','))
FROM "public".title_principals;
--DROP TABLE "public".character_names;
ALTER TABLE "public".character_names_temp
RENAME TO character_names;

*/