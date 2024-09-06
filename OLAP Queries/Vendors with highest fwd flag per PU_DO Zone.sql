/* Zones with highest num of store and forward flags, and the vendor name */

SELECT
    dl.pickup_zone,
    dl.dropoff_zone,
    COUNT(*) AS total_trips,
    SUM(CASE WHEN ft.store_and_fwd_flag = 'Y' THEN 1 ELSE 0 END) AS store_fwd_flag_yes_count,
    (SUM(CASE WHEN ft.store_and_fwd_flag = 'Y' THEN 1 ELSE 0 END) / COUNT(*))AS store_fwd_flag_yes_percentage
FROM
    fact_table ft
JOIN
    vendor_dimension dv ON ft.vendor_id = dv.vendor_id
JOIN
    location_dimension dl ON ft.location_id = dl.location_id
GROUP BY
    dl.pickup_zone,
    dl.dropoff_zone
ORDER BY
    store_fwd_flag_yes_count DESC;
