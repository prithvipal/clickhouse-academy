DESCRIBE s3('https://datasets-documentation.s3.eu-west-3.amazonaws.com/pypi/2023/pypi_0_7_34.snappy.parquet');

select * from s3('https://datasets-documentation.s3.eu-west-3.amazonaws.com/pypi/2023/pypi_0_7_34.snappy.parquet') limit 10;

select count() from s3('https://datasets-documentation.s3.eu-west-3.amazonaws.com/pypi/2023/pypi_0_7_34.snappy.parquet') ;

CREATE TABLE pypi(
    TIMESTAMP DateTime64(3, 'UTC'),
    COUNTRY_CODE String,
    URL String,
    PROJECT String
)
ENGINE = MergeTree
primary key TIMESTAMP;

drop table pypi

DESCRIBE pypi

INSERT INTO pypi
SELECT 
    TIMESTAMP, 
    COUNTRY_CODE, 
    URL, 
    PROJECT
FROM url(
    'https://datasets-documentation.s3.eu-west-3.amazonaws.com/pypi/2023/pypi_0_7_34.snappy.parquet',
    'Parquet',
    'TIMESTAMP DateTime64(3, \'UTC\'), COUNTRY_CODE String, URL String, PROJECT String'
)

select toStartOfMonth(TIMESTAMP) from pypi limit 10

SELECT PROJECT, count() count from pypi where toStartOfMonth(TIMESTAMP) = '2023-04-01' group by PROJECT order by count desc limit 100

SELECT 
    PROJECT,
    count() c 
from pypi 
    where PROJECT like 'boto%'
GROUP BY PROJECT
ORDER BY c DESC;

CREATE TABLE pypi2 (
    TIMESTAMP DateTime,
    COUNTRY_CODE String,
    URL String,
    PROJECT String 
)
ENGINE = MergeTree
PRIMARY KEY (TIMESTAMP, PROJECT);

describe pypi2

INSERT INTO pypi2
    SELECT *
    FROM pypi;

SELECT 
    PROJECT,
    count() AS c
FROM pypi2
WHERE PROJECT LIKE 'boto%'
GROUP BY PROJECT
ORDER BY c DESC;

CREATE OR REPLACE TABLE pypi2 (
    TIMESTAMP DateTime,
    COUNTRY_CODE String,
    URL String,
    PROJECT String 
)
ENGINE = MergeTree
PRIMARY KEY (PROJECT, TIMESTAMP);

INSERT INTO pypi2
    SELECT *
    FROM pypi;

SELECT 
    PROJECT,
    count() AS c
FROM pypi2
WHERE PROJECT LIKE 'boto%'
GROUP BY PROJECT
ORDER BY c DESC;
