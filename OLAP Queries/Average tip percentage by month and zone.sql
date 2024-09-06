use taxi_data;

SELECT 
    ld.pickup_zone,
    dt.pickup_month,
    AVG(LEAST(ft.tip_percentage, 2)) AS avg_tip_percentage,
    COUNT(ft.trip_id) AS total_trips
FROM 
    taxi_data.fact_table ft
JOIN 
    taxi_data.location_dimension ld ON ft.location_id = ld.location_id
JOIN 
    taxi_data.datetime_dimension dt ON ft.date_id = dt.date_id
GROUP BY 
    ld.pickup_zone, dt.pickup_month
ORDER BY 
    ld.pickup_zone, dt.pickup_month, avg_tip_percentage DESC;
