/* Retrieve day of week and pickup hour with highest avg revenue */

select
	dd.day_of_week,
	dd.pickup_hour,
    count(*) as total_trips,
    avg(ft.total_amount + ft.tip_amount) as avg_revenue
from 
	fact_table ft
join
	datetime_dimension dd on ft.date_id = dd.date_id
group by
	dd.day_of_week,
	dd.pickup_hour
order by
	avg_revenue desc;