select count(), avg(price) from uk_price_paid where toYear(date) = 2020;

select toYear(date) as year, count(), avg(price) from uk_price_paid group by year

describe uk_price_paid

create table prices_by_year_dest
(
    date Date,
    price UInt32,
    addr1 String, 
    addr2 String, 
    street LowCardinality(String), 
    town LowCardinality(String), 
    district LowCardinality(String),
    county LowCardinality(String)
)
ENGINE MergeTree
PRIMARY KEY (town, date)
PARTITION BY toYear(date)

create materialized view prices_by_year_view
to prices_by_year_dest
as
select 
    date,
    price,
    addr1,
    addr2,
    street,
    town,
    district,
    county
    from uk_price_paid
