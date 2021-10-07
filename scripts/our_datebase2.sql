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
    profession_id varchar(255),
    profession_type varchar(255)
);

CREATE TABLE public.Known_for_titles_key (
    person_id varchar(255),
    k_id varchar(255)
);

CREATE TABLE public.Known_for_titles (
    k_id varchar(255),
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
    Genre_id varchar(255)
);

CREATE TABLE public.Genre(
    Genre_id varchar(255),
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
    t_id varchar(255) NOT NULL,
    word text NOT NULL,
    field varchar(255) NOT NULL,
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
    ADD CONSTRAINT word_index_pkey PRIMARY KEY (t_id, word, field);

ALTER TABLE ONLY public.crew
    ADD CONSTRAINT crew_pkey PRIMARY KEY (title_id, ordering);

ALTER TABLE ONLY public.characters
    ADD CONSTRAINT characters_pkey PRIMARY KEY (character_name, title_id);

ALTER TABLE ONLY public.Title_rating
    ADD CONSTRAINT title_rating_pkey PRIMARY KEY (Title_id);

ALTER TABLE ONLY public.Title
    ADD CONSTRAINT title_pkey PRIMARY KEY (Title_id);

ALTER TABLE ONLY public.Person
    ADD CONSTRAINT person_pkey PRIMARY KEY (person_id);

ALTER TABLE ONLY public.Profession_key
    ADD CONSTRAINT profession_key_pkey PRIMARY KEY (person_id,profession_id);

ALTER TABLE ONLY public.Profession
    ADD CONSTRAINT profession_pkey PRIMARY KEY (profession_id);

ALTER TABLE ONLY public.Known_for_titles_key
    ADD CONSTRAINT Known_for_titles_key_pkey PRIMARY KEY (person_id, k_id);

ALTER TABLE ONLY public.Known_for_titles
    ADD CONSTRAINT known_for_titles_pkey PRIMARY KEY (k_id);

ALTER TABLE ONLY public.Title_versions
    ADD CONSTRAINT Title_versions_pkey PRIMARY KEY (title_id,title_version);

ALTER TABLE ONLY public.Genre
    ADD CONSTRAINT genre_pkey PRIMARY KEY (genre_id);

ALTER TABLE ONLY public.Genre_key
    ADD CONSTRAINT genre_key_pkey PRIMARY KEY (title_id);

ALTER TABLE ONLY public.Episodes
    ADD CONSTRAINT episodes_pkey PRIMARY KEY (parent_title_id, title_id);







--
-- Name: name_basics; Type: TABLE; Schema: public; Owner: -
--







--INSERT DATA HERE