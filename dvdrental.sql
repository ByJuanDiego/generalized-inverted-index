-- sudo pg_restore -h 127.0.0.1 -p 5432 -U "postgres" -d "cs2042db2" -v "/home/juandiego/UTEC/data-base-2/gin/dvdrental.tar";

SET SEARCH_PATH TO public;

SELECT setweight(to_tsvector('english', title), 'A') || setweight(to_tsvector('english', description), 'B')
FROM film;

ALTER TABLE film ADD COLUMN indexed tsvector;

UPDATE film SET indexed = T.indexed FROM (
    SELECT film_id,
    setweight(to_tsvector('english', title), 'A')  || setweight(to_tsvector('english', description), 'B') AS indexed
    FROM film
) AS T WHERE film.film_id = T.film_id;


CREATE INDEX film_gin_indexed ON film using gin(indexed);

SELECT indexed, fulltext FROM film;
select indexed, fulltext  from film where film_id = 133;

EXPLAIN ANALYSE
SELECT title, description FROM film WHERE description ILIKE '%man%' OR description ILIKE '%woman%';

SET enable_seqscan = OFF;
EXPLAIN ANALYSE
SELECT title, description FROM film WHERE indexed @@ to_tsquery('english', 'Man | woman');
-- @@ operator returns boolean: tsvector matches tsquery?

EXPLAIN ANALYSE
SELECT title, description, ts_rank_cd(indexed, query) as rank
FROM film, to_tsquery('english', 'Man | Woman') query
ORDER BY rank DESC LIMIT 16;

EXPLAIN ANALYSE
SELECT title, description, ts_rank_cd(indexed, query) as rank
FROM film, to_tsquery('english', 'Man | Woman') query
ORDER BY rank DESC LIMIT 32;
