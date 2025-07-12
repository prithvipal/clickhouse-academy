select * from s3('https://learnclickhouse.s3.us-east-2.amazonaws.com/datasets/crypto_prices.parquet') limit 10

select formatReadableQuantity(count(*)) from s3('https://learnclickhouse.s3.us-east-2.amazonaws.com/datasets/crypto_prices.parquet') limit 10


select 
crypto_name, avg(volume) 
from s3('https://learnclickhouse.s3.us-east-2.amazonaws.com/datasets/crypto_prices.parquet') 
where crypto_name='Bitcoin'
group by crypto_name
order by crypto_name

select 
trim(crypto_name) as name , count() 
from s3('https://learnclickhouse.s3.us-east-2.amazonaws.com/datasets/crypto_prices.parquet') 
group by name 
order by name

select 
*
from s3('https://learnclickhouse.s3.us-east-2.amazonaws.com/datasets/crypto_prices.parquet') 
where crypto_name=''

