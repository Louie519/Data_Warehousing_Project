/* Rollup: Total Rides and Total Revenue for Each Year*/

select
	dd.pickup_year,
    count(*) as total_rides,
    sum(ft.total_amount + ft.tip_amount) as total_revenue
from 
	fact_table ft
join
	datetime_dimension dd on ft.date_id = dd.date_id
group by
	dd.pickup_year with rollup;
    