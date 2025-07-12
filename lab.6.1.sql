create view london_properties_view
as 
    select 
        date,
        price,
        addr1,
        addr2,
        street
    from uk_price_paid
    where town='LONDON'

select avg(price) from london_properties_view



SELECT count() 
FROM uk_price_paid
WHERE town = 'LONDON';

explain select count() from london_properties_view

explain SELECT count() 
FROM uk_price_paid
WHERE town = 'LONDON';

SELECT *
FROM london_properties_view
WHERE town = 'MANCHESTER'; 


create view properties_by_town_view
as 
    select 
        date,
        price,
        addr1,
        addr2,
        street
    from uk_price_paid
    where town = {town_filter:String}

