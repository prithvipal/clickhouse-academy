DESCRIBE s3('https://learnclickhouse.s3.us-east-2.amazonaws.com/datasets/crypto_prices.parquet');

create table crypto_prices
(
    trade_date Date,
    crypto_name LowCardinality(String),
    volume Float32,
    price Float32,
    market_cap Float32,
    change_1_day Float32
)
ENGINE = MergeTree
PRIMARY KEY (crypto_name, trade_date)

insert into crypto_prices 
select 
    trade_date, crypto_name, volume, price, market_cap, change_1_day
from url('https://learnclickhouse.s3.us-east-2.amazonaws.com/datasets/crypto_prices.parquet');

select count() from crypto_prices

select count() from crypto_prices where volume>=1000_000

select avg(price) from crypto_prices where crypto_name='Bitcoin'

