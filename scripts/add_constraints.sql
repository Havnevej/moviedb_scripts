ALTER TABLE ONLY public.omdb
    ADD CONSTRAINT omdb_pkey PRIMARY KEY (title_id);

ALTER TABLE ONLY public.word_index
    ADD CONSTRAINT word_index_pkey PRIMARY KEY (title_id, word, field);

ALTER TABLE ONLY public.crew
    ADD CONSTRAINT crew_pkey PRIMARY KEY (title_id, ordering);

ALTER TABLE ONLY public.character_names_temp
    ADD CONSTRAINT character_names_pkey PRIMARY KEY (person_id, title_id, character_name);

ALTER TABLE ONLY public.Title_rating
    ADD CONSTRAINT title_rating_pkey PRIMARY KEY (title_id);

ALTER TABLE ONLY public.Title
    ADD CONSTRAINT title_pkey PRIMARY KEY (title_id);

ALTER TABLE ONLY public.Person
    ADD CONSTRAINT person_pkey PRIMARY KEY (person_id);

ALTER TABLE ONLY public.Profession
    ADD CONSTRAINT profession_pkey PRIMARY KEY (person_id, profession_type);

ALTER TABLE ONLY public.Known_for_titles
    ADD CONSTRAINT known_for_titles_pkey PRIMARY KEY (person_id, title_id);

ALTER TABLE ONLY public.Title_versions
    ADD CONSTRAINT Title_versions_pkey PRIMARY KEY (title_id,title_version);

ALTER TABLE ONLY public.Genre
    ADD CONSTRAINT genre_pkey PRIMARY KEY (title_id, genre_name);

ALTER TABLE ONLY public.Episodes
    ADD CONSTRAINT episodes_pkey PRIMARY KEY (parent_title_id, title_id);

/*
ALTER TABLE ONLY public.Genre_key
    ADD CONSTRAINT genre_key_pkey PRIMARY KEY (title_id);

ALTER TABLE ONLY public.Known_for_titles_key
    ADD CONSTRAINT Known_for_titles_key_pkey PRIMARY KEY (person_id, k_id);

ALTER TABLE ONLY public.Profession_key
    ADD CONSTRAINT profession_key_pkey PRIMARY KEY (person_id,profession_id);

*/