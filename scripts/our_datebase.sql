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
    person_id character(10),
    person_name character varying(256),
    birthyear character(4),
    deathyear character(4)
);

CREATE TABLE public.Professon_key(
    person_id character(10),
    profession_id character(20)
);

CREATE TABLE public.Profession(
    profession_id character(10),
    profession_type character(20)
);

CREATE TABLE public.Known_for_titles_key (
    person_id character (10),
    k_id character(20)
);

CREATE TABLE public.Known_for_titles (
    k_id character(20),
    title_id character(20)
);

CREATE TABLE public.Title_versions (
    title_id character(20),
    title_version character(16),
    title_name character(20),
    region character (20),
    language character(16),
    types character(10),
    attributes character(10),
    is_original_title boolean
);

CREATE TABLE public.Genre_key(
    title_id character(20),
    Genre_id character(20)
);

CREATE TABLE public.Genre(
    Genre_id character(20),
    genre_name character(20)
);

CREATE TABLE public.title(
    title_id character(20),
    title_type character(20),
    original_title character(20),
    primary_title character(20),
    is_adult boolean,
    start_year character(4),
    end_year character(4),
    run_time_minutes int4
);


CREATE TABLE public.crew(
    title_id character(20),
    person_id character(20),
    primary_profession character(10),
    additional_profession character(10),
    is_principal boolean,
    ordering int4
);


CREATE TABLE public.characters(
    character_name character(20),
    person_id character(20),
    title_id character(20)
);

CREATE TABLE public.Title_rating(
    title_id character(20),
    rating_avg float(10),
    votes character (10)
);

CREATE TABLE public.Episodes(
    parent_title_id character(20),
    title_id character(16),
    season_nr character(20),
    episode_nr character(20)
);


CREATE TABLE public.omdb_data (
    t_id character(10) NOT NULL,
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







--
-- Name: omdb_data omdb_data_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.omdb_data
    ADD CONSTRAINT omdb_data_pkey PRIMARY KEY (t_id);


--
-- Name: wi wi_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.word_index
    ADD CONSTRAINT wi_pkey PRIMARY KEY (t_id, word, field);








--
-- Name: name_basics; Type: TABLE; Schema: public; Owner: -
--







--INSERT DATA HERE