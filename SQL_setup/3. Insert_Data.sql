USE bi_and_dw;

INSERT INTO bi_and_dw.vendor_dimension (vendorID,vendor_name)
SELECT DISTINCT VendorID,vendor_name
FROM bi_and_dw.source_table
WHERE VendorID NOT IN (SELECT vendorID FROM vendor_dimension);

SELECT COUNT(*) FROM vendor_dimension;

INSERT INTO bi_and_dw.datetime_dimension (pickup_datetime, dropoff_datetime, pickup_time, dropoff_time, pickup_hour, dropoff_hour, pickup_year, dropoff_year, pickup_month, dropoff_month, day_of_week, is_holiday)
SELECT DISTINCT pickup_datetime, dropoff_datetime, pickup_time, dropoff_time, pickup_hour, dropoff_hour, pickup_year, dropoff_year, pickup_month, dropoff_month, day_of_week, is_holiday
FROM bi_and_dw.source_table
WHERE CONCAT(pickup_datetime, dropoff_datetime) NOT IN (SELECT CONCAT(pickup_datetime, dropoff_datetime) FROM datetime_dimension);

SELECT COUNT(*) FROM datetime_dimension;

INSERT INTO bi_and_dw.location_dimension (pu_location_id, do_location_id, pickup_zone, dropoff_zone, pickup_borough, dropoff_borough)
SELECT DISTINCT PULocationID, DOLocationID, pickup_zone, dropoff_zone, pickup_borough, dropoff_borough
FROM bi_and_dw.source_table
WHERE CONCAT(PULocationID,DOLocationID) NOT IN (SELECT CONCAT(pu_location_id,do_location_id) FROM location_dimension);

SELECT COUNT(*) FROM location_dimension;

INSERT INTO bi_and_dw.rate_dimension (rate_code_id,rate_code_name)
SELECT DISTINCT RatecodeID,rate_code_name
FROM bi_and_dw.source_table
WHERE RatecodeID NOT IN (SELECT rate_code_id FROM rate_dimension);

SELECT count(*) FROM rate_dimension;

INSERT INTO bi_and_dw.paymenttype_Dimension (payment_type,payment_type_name)
SELECT DISTINCT payment_type,payment_type_name
FROM bi_and_dw.source_table
WHERE payment_type NOT IN (SELECT payment_type FROM paymenttype_Dimension);

SELECT count(*) FROM paymenttype_Dimension;

INSERT INTO fact_table  (vendor_id, date_id, location_id, rate_id, payment_id, passenger_count, trip_distance, 
trip_time_minutes, fare_amount, extra, mta_tax, tip_amount,tip_percentage, tolls_amount, improvement_surcharge, total_amount, 
congestion_surcharge, airport_fee, avg_mph, fare_per_minute, tip_per_minute,store_and_fwd_flag)
SELECT distinct
    vd.vendor_id, 
    dd.date_id, 
    ld.location_id, 
    rd.rate_id, 
    pd.payment_id, 
    st.passenger_count, 
    st.trip_distance, 
    st.trip_time_minutes, 
    st.fare_amount, 
    st.extra, 
    st.mta_tax, 
    st.tip_amount, 
    st.tip_percentage,
    st.tolls_amount, 
    st.improvement_surcharge, 
    st.total_amount, 
    st.congestion_surcharge,
    st.airport_fee,
    st.avg_mph, 
    st.fare_per_minute, 
    st.tip_per_minute,
    st.store_and_fwd_flag
FROM bi_and_dw.source_table st
JOIN vendor_dimension vd ON st.VendorID = vd.VendorID 
JOIN datetime_dimension dd ON st.pickup_datetime = dd.pickup_datetime AND st.dropoff_datetime = dd.dropoff_datetime
JOIN location_dimension ld ON st.PULocationID = ld.pu_location_id AND st.DOLocationID = ld.do_location_id
JOIN rate_dimension rd ON st.RatecodeID = rd.rate_code_id
JOIN paymenttype_dimension pd ON st.payment_type = pd.payment_type;

SELECT COUNT(*) FROM fact_table;
/*SELECT distinct * FROM fact_table;
select * from bi_and_dw;*/