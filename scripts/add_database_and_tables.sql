/*
SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;
SET default_tablespace = '';
SET default_table_access_method = heap;
*/

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
    title_id varchar(255),
    title_version varchar(255),
    title_name varchar(255),
    region varchar(255),
    language varchar(255),
    types varchar(255),
    attributes varchar(255),
    is_original_title boolean
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

CREATE TABLE public.director(
    title_id varchar(255),
    director_id varchar(255),
);

CREATE TABLE public.writer(
    title_id varchar(255),
    writer_id varchar(255),
);

CREATE TABLE public.Character_names_temp(
    character_name varchar(255),
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
    poster character varying(256),
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


/*
CREATE TABLE public.Genre_key(
    title_id varchar(255),
    genre_id varchar(255)
);

CREATE TABLE public.Profession_key(
    person_id varchar(255),
    profession_id varchar(255)
);

CREATE TABLE public.Known_for_titles_key (
    person_id varchar(255),
    k_id varchar(255)
);

*/