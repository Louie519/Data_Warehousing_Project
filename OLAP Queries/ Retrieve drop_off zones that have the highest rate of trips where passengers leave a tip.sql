/* Retrieve drop_off zones that have the highest rate of trips where passengers leave a tip*/ 

select 
	lt.dropoff_zone,
    count(ft.trip_id) as total_trips,
    count(case when ft.tip_amount > 0 then 1 else null end) as tipping_instances,
    (count(case when ft.tip_amount > 0 then 1 else null end)/count(ft.trip_id)) as tipping_rate
from
	fact_table ft
join
	location_dimension lt on lt.location_id = ft.location_id
group by
	dropoff_zone
order by
	tipping_rate desc;