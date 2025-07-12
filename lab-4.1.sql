select 
    count() as count,
    by,
    
from hackernews
group by by
order by count desc;
    
