CREATE TABLE netflix_data.netflix_listed_in AS
(
  SELECT *
  FROM
  (
    SELECT show_id, listed_in_1 AS category FROM netflix_data.listed_in
    UNION
    SELECT show_id, listed_in_2 AS category FROM netflix_data.listed_in
    UNION
    SELECT show_id, listed_in_3 AS category FROM netflix_data.listed_in
  ) a
  WHERE category IS NOT NULL
);