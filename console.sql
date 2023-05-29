-- CREATE SCHEMA lab8_2;
SET SEARCH_PATH TO lab8_2;

-- CREATE EXTENSION IF NOT EXISTS pg_trgm;
-- SELECT * FROM pg_available_extensions;

-- create tables
CREATE TABLE articles_1000
(
    body         text,
    body_indexed text
);

CREATE TABLE articles_10000
(
    body         text,
    body_indexed text
);

CREATE TABLE articles_100000
(
    body         text,
    body_indexed text
);

CREATE TABLE articles_1000000
(
    body         text,
    body_indexed text
);

CREATE TABLE articles_10000000
(
    body         text,
    body_indexed text
);

CREATE TABLE articles_100000000
(
    body         text,
    body_indexed text
);

-- populate tables with data

INSERT INTO articles_1000
SELECT md5(random()::TEXT), md5(random()::TEXT)
FROM (SELECT * FROM generate_series(1, 1000) AS id) AS x;

INSERT INTO articles_10000
SELECT md5(random()::text), md5(random()::text)
FROM (SELECT * FROM generate_series(1, 10000) AS id) AS x;

INSERT INTO articles_100000
SELECT md5(random()::text), md5(random()::text)
FROM (SELECT * FROM generate_series(1, 100000) AS id) AS x;

INSERT INTO articles_1000000
SELECT md5(random()::text), md5(random()::text)
FROM (SELECT * FROM generate_series(1, 1000000) AS id) AS x;

INSERT INTO articles_10000000
SELECT md5(random()::text), md5(random()::text)
FROM (SELECT * FROM generate_series(1, 10000000) AS id) AS x;

INSERT INTO articles_100000000
SELECT md5(random()::text), md5(random()::text) FROM  (
    SELECT * FROM generate_series(1, 100000000) AS id
) AS x;


-- Generally Trigram Index
CREATE INDEX articles_1000_gin ON articles_1000 USING gin(body_indexed gin_trgm_ops);
CREATE INDEX articles_10000_gin ON articles_10000 USING gin(body_indexed gin_trgm_ops);
CREATE INDEX articles_100000_gin ON articles_100000 USING gin(body_indexed gin_trgm_ops);
CREATE INDEX articles_1000000_gin ON articles_1000000 USING gin(body_indexed gin_trgm_ops);
CREATE INDEX articles_10000000_gin ON articles_10000000 USING gin(body_indexed gin_trgm_ops);
CREATE INDEX articles_100000000_gin ON articles_100000000 USING gin(body_indexed gin_trgm_ops);

-- test

EXPLAIN ANALYSE SELECT count(*) from articles_1000 WHERE body_indexed ILIKE '%3004%';
EXPLAIN ANALYSE SELECT count(*) from articles_1000 WHERE body ILIKE '%3004%';

EXPLAIN ANALYSE SELECT count(*) from articles_10000 WHERE body_indexed ILIKE '%3004%';
EXPLAIN ANALYSE SELECT count(*) from articles_10000 WHERE body ILIKE '%3004%';

EXPLAIN ANALYSE SELECT count(*) from articles_100000 WHERE body_indexed ILIKE '%3004%';
EXPLAIN ANALYSE SELECT count(*) from articles_100000 WHERE body ILIKE '%3004%';

EXPLAIN ANALYSE SELECT count(*) from articles_1000000 WHERE body_indexed ILIKE '%3004%';
EXPLAIN ANALYSE SELECT count(*) from articles_1000000 WHERE body ILIKE '%3004%';

EXPLAIN ANALYSE SELECT count(*) from articles_10000000 WHERE body_indexed ILIKE '%3004%';
EXPLAIN ANALYSE SELECT count(*) from articles_10000000 WHERE body ILIKE '%3004%';

EXPLAIN ANALYSE SELECT count(*) from articles_100000000 WHERE body_indexed ILIKE '%3004%';
EXPLAIN ANALYSE SELECT count(*) from articles_100000000 WHERE body ILIKE '%3004%';
