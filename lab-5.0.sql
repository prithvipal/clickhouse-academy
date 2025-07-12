select count()
from uk_price_paid;

select town, count() as c
from uk_price_paid
group by town
order by c desc
limit 10
format vertical


select town, count() as c
from uk_price_paid
group by town
order by c desc
limit 10
format JSON

select town, count() as c
from uk_price_paid
group by town
order by c desc
limit 10
format JSONEachRow

select town, count() as c
from uk_price_paid
group by town
order by c desc
limit 10
format CSVWithNames

with
    'LONDON' as my_town
select
    avg(price)
from uk_price_paid
where town=my_town


with
    most_expensive as (
        select * from uk_price_paid
        order by price DESC
        limit 10
    )
select
    avg(price)
from most_expensive

with
    most_expensive as (
        select * from uk_price_paid
        order by price DESC
        limit 10
    )
select
    *
from most_expensive


select town, any(district),count() as c
from uk_price_paid
group by town
order by c desc
limit 10

select 
    avg(price) over (partition by postcode1),
    *
from uk_price_paid
where type='terraced'
and postcode1 != ''
limit 100

select formatReadableQuantity(sum(price))
from uk_price_paid

select count()
from uk_price_paid 
where position(street, 'KING') >1

select count()
from uk_price_paid 
where multiFuzzyMatchAny(street, 1, ['KING'])

select DISTINCT 
    street,
    multiSearchAllPositionsCaseInsensitive(
        street, ['abbey', 'road']
    ) as position
from uk_price_paid 
where not has(position, 0)


select 
    max(price),
    toStartOfDay(date) as day
from uk_price_paid
group by day
order by day desc

select now()

with now() as today
select today - interval 1 day


with now() as today
select today - interval 1 day,
today,
today -1

select 
    town,
    max(price),
    argMax(street, price),
    argMax(date, price),
from uk_price_paid
group by town

select * from system.functions where origin = 'System'


select
quantile(0.9)(price)
from uk_price_paid
where toYear(date) >=2020

select
quantiles(0.10, 0.50, 0.90)(price)
from uk_price_paid
where toYear(date) >=2020

select uniq(street)
from uk_price_paid

select topK(10)(street) from uk_price_paid

select topKIf(10)(street, street !='') from uk_price_paid

select  splitByChar(' ', street) from uk_price_paid limit 10

select  arrayJoin(splitByChar(' ', street)) from uk_price_paid limit 10
