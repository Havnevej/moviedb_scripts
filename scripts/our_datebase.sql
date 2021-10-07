--
-- PostgreSQL database dump
--

-- Dumped from database version 12.3
-- Dumped by pg_dump version 12.3

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

--
-- Name: name_basics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.Person (
    person_id varchar(255),
    person_name varchar(255),
    birthyear varchar(255),
    deathyear varchar(255)
);

CREATE TABLE public.Profession_key(
    person_id varchar(255),
    profession_id varchar(255)
);

CREATE TABLE public.Profession(
    profession_id SERIAL,
    profession_type varchar(255)
);

CREATE TABLE public.Known_for_titles_key (
    person_id varchar(255),
    k_id varchar(255)
);

CREATE TABLE public.Known_for_titles (
    k_id SERIAL,
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

CREATE TABLE public.Genre_key(
    title_id varchar(255),
    genre_id varchar(255)
);

CREATE TABLE public.Genre(
    genre_id SERIAL,
    genre_name varchar(255)
);

CREATE TABLE public.title(
    title_id varchar(255),
    title_type varchar(255),
    original_title varchar(255),
    primary_title varchar(255),
    is_adult boolean,
    start_year varchar(255),
    end_year varchar(255),
    run_time_minutes int4
);


CREATE TABLE public.character(
    character varchar(255),
    person_id varchar(255),
    title_id varchar(255)
)


CREATE TABLE public.crew(
    title_id varchar(255),
    person_id varchar(255),
    primary_profession varchar(255),
    additional_profession varchar(255),
    is_principal boolean,
    ordering int4
);


CREATE TABLE public.characters(
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


CREATE TABLE public.omdb_data (
    t_id varchar(255) NOT NULL,
    poster character varying(256),
    awards text,
    plot text
);

--
-- Name: wi; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.Word_index (
    t_id character(10) NOT NULL,
    word text NOT NULL,
    field character(1) NOT NULL,
    lexeme text
);