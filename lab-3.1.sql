DESCRIBE uk.pypi;

select uniqExact(COUNTRY_CODE) FROM uk.pypi

select uniqExact(PROJECT) FROM uk.pypi

select uniqExact(URL) FROM uk.pypi

select uniqExact(PROJECT, URL) FROM uk.pypi

show create table pypi2



create table pypi3
(
    TIMESTAMP DateTime,
    COUNTRY_CODE LowCardinality(String),
    URL String,
    PROJECT LowCardinality(String)
)
ENGINE = MergeTree
PRIMARY KEY (PROJECT, TIMESTAMP)

INSERT INTO pypi3
    SELECT *
    FROM pypi2;

SELECT
    table,
    formatReadableSize(sum(data_compressed_bytes)) AS compressed_size,
    formatReadableSize(sum(data_uncompressed_bytes)) AS uncompressed_size,
    count() AS num_of_active_parts
FROM system.parts
WHERE (active = 1) AND (table LIKE 'pypi%')
GROUP BY table;

select
    toStartOfMonth(TIMESTAMP) as month,
    count() as count
from pypi2
where COUNTRY_CODE='US'
group by month
order by 
    month asc,
    count desc

select
    toStartOfMonth(TIMESTAMP) as month,
    count() as count
from pypi3
where COUNTRY_CODE='US'
group by month
order by 
    month asc,
    count desc
