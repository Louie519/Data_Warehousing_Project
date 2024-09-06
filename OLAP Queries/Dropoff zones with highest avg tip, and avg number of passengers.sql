/* Dropoff zones with highest avg tip, and avg number of passengers*/

SELECT
    lt.dropoff_zone,
    AVG(ft.tip_amount) AS avg_tip_amount,
    avg(ft.passenger_count) as avg_passenger_count
FROM
    fact_table ft
JOIN
    location_dimension lt ON lt.location_id = ft.location_id
GROUP BY
    lt.dropoff_zone
ORDER BY
    avg_tip_amount DESC;