create table titles
as 

select show_id, 
type,
title,
date_added,
release_year,
rating,
duration,
Duration_type
 from netflix_data.netflix_titles;
 