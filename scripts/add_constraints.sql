ALTER TABLE ONLY public.omdb
    ADD CONSTRAINT omdb_pkey PRIMARY KEY (title_id);

ALTER TABLE ONLY public.word_index
    ADD CONSTRAINT word_index_pkey PRIMARY KEY (title_id, word, field);

ALTER TABLE ONLY public.director
    ADD CONSTRAINT director_pkey PRIMARY KEY (director_id, title_id);

ALTER TABLE ONLY public.writer
    ADD CONSTRAINT writer_pkey PRIMARY KEY (writer_id, title_id);

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

ALTER TABLE ONLY public.Principals
    ADD CONSTRAINT principals_pkey PRIMARY KEY (title_id, ordering);


--Setting constraints for user (c framework)

ALTER TABLE ONLY public.Person_rating
    ADD CONSTRAINT person_rating_pkey PRIMARY KEY (person_id);

ALTER TABLE ONLY public.User
    ADD CONSTRAINT user_pkey PRIMARY KEY (user_id);

ALTER TABLE ONLY public.User_title_rating
    ADD CONSTRAINT user_title_rating_pkey PRIMARY KEY (user_id);

ALTER TABLE ONLY public.Bookmark_title
    ADD CONSTRAINT bookmark_title_pkey PRIMARY KEY (user_id);

ALTER TABLE ONLY public.Bookmark_person
    ADD CONSTRAINT bookmark_person_pkey PRIMARY KEY (user_id, person_id);

ALTER TABLE ONLY public.Search_history
    ADD CONSTRAINT search_history_pkey PRIMARY KEY (user_id);

/*
ALTER TABLE ONLY public.Genre_key
    ADD CONSTRAINT genre_key_pkey PRIMARY KEY (title_id);

ALTER TABLE ONLY public.Known_for_titles_key
    ADD CONSTRAINT Known_for_titles_key_pkey PRIMARY KEY (person_id, k_id);

ALTER TABLE ONLY public.Profession_key
    ADD CONSTRAINT profession_key_pkey PRIMARY KEY (person_id,profession_id);

*/