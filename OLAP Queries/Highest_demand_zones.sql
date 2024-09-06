
/*highest demand zones*/
SELECT 
    Zone, 
    SUM(TripCount) AS TotalTrips
FROM (
    SELECT 
        pickup_zone AS Zone, 
        COUNT(*) AS TripCount
    FROM 
        fact_table ft
    JOIN 
        location_dimension ld ON ft.location_id = ld.location_id
    GROUP BY 
        pickup_zone

    UNION ALL

    SELECT 
        dropoff_zone AS Zone, 
        COUNT(*) AS TripCount
    FROM 
        fact_table ft
    JOIN 
        location_dimension ld ON ft.location_id = ld.location_id
    GROUP BY 
        dropoff_zone
) AS CombinedZones
GROUP BY 
    Zone
ORDER BY 
    TotalTrips DESC
LIMIT 10;
