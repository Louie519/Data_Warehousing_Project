USE bi_and_dw;
CREATE TABLE IF NOT EXISTS bi_and_dw.vendor_dimension (
    vendor_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    vendorID BIGINT,
    vendor_name VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS bi_and_dw.datetime_dimension (
    date_id INT AUTO_INCREMENT PRIMARY KEY,
    pickup_datetime DATETIME,
    dropoff_datetime DATETIME,
    pickup_time TIME,
    dropoff_time TIME,
    pickup_hour INT,
    dropoff_hour INT,
    pickup_year YEAR,
    dropoff_year YEAR,
    pickup_month INT,
    dropoff_month INT,
    day_of_week VARCHAR(9),
    is_holiday BOOLEAN
);

CREATE TABLE IF NOT EXISTS bi_and_dw.location_dimension (
    location_id INT AUTO_INCREMENT PRIMARY KEY,
    pu_location_id BIGINT,
    do_location_id BIGINT,
    pickup_zone VARCHAR(255),
    dropoff_zone VARCHAR(255),
    pickup_borough VARCHAR(255),	
    dropoff_borough VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS bi_and_dw.rate_dimension (
    rate_id INT AUTO_INCREMENT PRIMARY KEY,
    rate_code_id DOUBLE,
    rate_code_name VARCHAR(255)
);


CREATE TABLE IF NOT EXISTS bi_and_dw.paymenttype_dimension (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    payment_type BIGINT,
    payment_type_name VARCHAR(255)
);



