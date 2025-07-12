show tables in system

select * 
from s3('https://datasets-documentation.s3.eu-west-3.amazonaws.com/pypi/2023/pypi_0_0_0.snappy.parquet') 
limit 100

describe s3('https://datasets-documentation.s3.eu-west-3.amazonaws.com/pypi/2023/pypi_0_0_0.snappy.parquet') 

select PROJECT, count() as c
from s3('https://datasets-documentation.s3.eu-west-3.amazonaws.com/pypi/2023/pypi_0_0_0.snappy.parquet') 
group by PROJECT order by c desc

select 
    toStartOfMonth(TIMESTAMP) AS month,
    PROJECT,
    count()
from s3('https://datasets-documentation.s3.eu-west-3.amazonaws.com/pypi/2023/pypi_0_0_0.snappy.parquet') 
group by month, PROJECT
order by 3 desc



CREATE DATABASE uk;

CREATE TABLE uk.uk_price_paid
(
    price UInt32,
    date Date,
    postcode1 LowCardinality(String),
    postcode2 LowCardinality(String),
    type Enum8('terraced' = 1, 'semi-detached' = 2, 'detached' = 3, 'flat' = 4, 'other' = 0),
    is_new UInt8,
    duration Enum8('freehold' = 1, 'leasehold' = 2, 'unknown' = 0),
    addr1 String,
    addr2 String,
    street LowCardinality(String),
    locality LowCardinality(String),
    town LowCardinality(String),
    district LowCardinality(String),
    county LowCardinality(String)
)
ENGINE = MergeTree
ORDER BY (postcode1, postcode2, addr1, addr2);




INSERT INTO uk.uk_price_paid
SELECT
    toUInt32(price_string) AS price,
    parseDateTimeBestEffortUS(time) AS date,
    splitByChar(' ', postcode)[1] AS postcode1,
    splitByChar(' ', postcode)[2] AS postcode2,
    transform(a, ['T', 'S', 'D', 'F', 'O'], ['terraced', 'semi-detached', 'detached', 'flat', 'other']) AS type,
    b = 'Y' AS is_new,
    transform(c, ['F', 'L', 'U'], ['freehold', 'leasehold', 'unknown']) AS duration,
    addr1,
    addr2,
    street,
    locality,
    town,
    district,
    county
FROM url(
    'http://prod1.publicdata.landregistry.gov.uk.s3-website-eu-west-1.amazonaws.com/pp-complete.csv',
    'CSV',
    'uuid_string String,
    price_string String,
    time String,
    postcode String,
    a String,
    b String,
    c String,
    addr1 String,
    addr2 String,
    street String,
    locality String,
    town String,
    district String,
    county String,
    d String,
    e String'
) SETTINGS max_http_get_redirects=10;


select formatReadableQuantity(count()) from uk.uk_price_paid;

select * from uk.uk_price_paid  order by date desc limit 100

select avg(price), count(), town from uk.uk_price_paid group by town order by 1 desc
