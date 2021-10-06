INSERT INTO public.Title("title_id")
SELECT "tconst"  
FROM title_basic


INSERT INTO public.titletest("title_type","original_title")
SELECT "titletype", "originaltitle" 
FROM "public".title_basics 


/*
CREATE TABLE "public".TitleTest(
    title_id character(20),
    title_type character(20),
    original_title character(20),
    primary_title character(20),
    is_adult boolean,
    start_year character(4),
    end_year character(4),
    run_time_minutes int4
);*/