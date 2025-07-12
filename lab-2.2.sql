select 
    table,
    formatReadableSize(sum(data_compressed_bytes)) AS compressed_size,
    formatReadableSize(sum(data_uncompressed_bytes)) AS uncompressed_size,
    count() AS num_of_active_parts
from system.parts
where (active=1) and (table like '%pypi%')
group by table

CREATE TABLE test_pypi (
    TIMESTAMP DateTime,
    COUNTRY_CODE String,
    URL String,
    PROJECT String 
)

ENGINE = MergeTree
PRIMARY KEY (PROJECT, COUNTRY_CODE ,TIMESTAMP);

INSERT INTO test_pypi
    SELECT *
    FROM pypi2;


SELECT
  table,
  round(sum(data_uncompressed_bytes) / sum(data_compressed_bytes), 2) AS compression_ratio
FROM system.parts
WHERE active
GROUP BY table order by 
