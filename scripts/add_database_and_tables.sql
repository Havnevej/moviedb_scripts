CREATE TABLE public.Person (
    person_id varchar(255),
    person_name varchar(255),
    birthyear varchar(255),
    deathyear varchar(255)
);

CREATE TABLE public.Profession(
    person_id varchar(255),
    profession_type varchar(255)
);

CREATE TABLE public.Known_for_titles (
    person_id varchar(255),
    title_id varchar(255)
);

CREATE TABLE public.Title_versions (
    title_id varchar(1024),
    title_version varchar(255),
    title_name varchar(1024),
    region varchar(255),
    language varchar(255),
    types varchar(255),
    attributes varchar(1024),
    is_original_title varchar(255)
);

CREATE TABLE public.Genre(
    title_id varchar(255),
    genre_name varchar(255)
);

CREATE TABLE public.Title(
    title_id varchar(255),
    title_type varchar(255),
    original_title varchar(255),
    primary_title varchar(255),
    is_adult boolean,
    start_year varchar(255),
    end_year varchar(255),
    run_time_minutes int4
);

CREATE TABLE public.Director_temp(
    title_id varchar(255),
    director_id varchar(255)
);

CREATE TABLE public.Writer_temp(
    title_id varchar(255),
    writer_id varchar(255)
);

CREATE TABLE public.Character_names_temp(
    character_name varchar(555),
    person_id varchar(255),
    title_id varchar(255)
);

CREATE TABLE public.Title_rating(
    title_id varchar(255),
    rating_avg float(10),
    votes varchar(255)
);

CREATE TABLE public.Episodes(
    parent_title_id varchar(255),
    title_id varchar(255),
    season_nr varchar(255),
    episode_nr varchar(255)
);

CREATE TABLE public.Omdb (
    title_id varchar(255) NOT NULL,
    poster varchar(255),
    awards text,
    plot text
);

CREATE TABLE public.Word_index (
    title_id character(10) NOT NULL,
    word VARCHAR(255),
    field VARCHAR(255),
    lexeme VARCHAR(255)
);

CREATE TABLE public.Principals (
    title_id character(10) NOT NULL,
    ordering int4 NOT NULL,
    person_id VARCHAR(255) NOT NULL,
    category VARCHAR(255),
    job VARCHAR(255)
);

-- CREATE Tables user (C framework)

CREATE TABLE person_rating (
    person_id VARCHAR(255), 
    person_name VARCHAR(255), 
    weight float,
    rating BIGINT, 
    num_votes BIGINT
    );

DROP TABLE IF EXISTS "public"."user";
CREATE TABLE "public"."user" (
  "user_id" int8 NOT NULL,
  "username" varchar(512) COLLATE "pg_catalog"."default" NOT NULL,
  "password" varchar(1024) COLLATE "pg_catalog"."default" NOT NULL,
  "salt" varchar(1024) COLLATE "pg_catalog"."default" NOT NULL,
  "created_date" date NOT NULL
);

CREATE TABLE user_title_rating(
    username VARCHAR(255),
    title_id VARCHAR(255),
    rating VARCHAR(255)
    );

CREATE TABLE bookmark_title(
    username VARCHAR(255),
    title_id VARCHAR(255)
    );

CREATE TABLE bookmark_person(
    username VARCHAR(255),
    person_id VARCHAR(255)
    );


CREATE TABLE "public"."search_history" (
  "username" varchar(255) NOT NULL,
  "search_string" varchar(255),
  "search_date" timestamp NOT NULL
);

CREATE TABLE Comment(
    username VARCHAR(255),
    "date" timestamp NOT NULL,
    title_id VARCHAR(255),
    comment VARCHAR(1024)
    );