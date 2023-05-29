-- n,id,title,publication,author,date,year,month,url,content

CREATE SCHEMA articles;
CREATE EXTENSION pg_trgm;
SET SEARCH_PATH TO articles;

SET DATESTYLE = ymd;

CREATE TABLE IF NOT EXISTS articles3_csv (
    n INTEGER,
    id INTEGER,
    title TEXT,
    publication TEXT,
    author TEXT,
    date TEXT,
    year FLOAT,
    month FLOAT,
    url TEXT,
    content TEXT
);

\copy articles3_csv(id, title, publication, author, date, year, month, url, content) FROM '/tmp/articles3.csv' DELIMITER ',' CSV HEADER;

SELECT datname as db_name, pg_size_pretty(pg_database_size(datname)) as db_usage FROM pg_database;

ALTER TABLE articles3_csv ADD COLUMN indexed tsvector;
UPDATE articles3_csv  SET indexed = T.indexed FROM (
    SELECT id, setweight(to_tsvector('english', title), 'A')  || setweight(to_tsvector('english', content), 'B') AS indexed FROM articles3_csv
) AS T WHERE articles3_csv.id = T.id;

CREATE INDEX articles3_csv_gin ON articles3_csv USING gin(indexed);

SET enable_seqscan = OFF;

EXPLAIN ANALYSE SELECT id, title, content
FROM articles3_csv WHERE indexed @@ to_tsquery('english', 'star & wars');

EXPLAIN ANALYSE SELECT id, title, content, ts_rank_cd(indexed, query) AS rank
FROM articles3_csv, to_tsquery('english', 'star & wars') query
WHERE articles3_csv.indexed IS NOT NULL AND articles3_csv.indexed @@ query
ORDER BY rank DESC LIMIT 10;

EXPLAIN ANALYSE SELECT id, title, content, ts_rank_cd(indexed, query) AS rank
FROM articles3_csv, to_tsquery('english', 'star & wars') query
WHERE articles3_csv.indexed IS NOT NULL
ORDER BY rank DESC LIMIT 10;
