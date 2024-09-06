# Taxi Service Data Warehouse Project

## Introduction
This project aims to build a data warehouse for efficieent analysis of taxi service data. The primary goal is to understand taxi service usage patterns, including high-demand zones, peak times throughout the year, and factors affecting total revenue like tip amounts. This analysis will enable taxi drivers to optimize their services, improve customer satisfaction, and increase profitability.

This document provides an overview of the dataset we worked with and guidelines to set up the project in your local environment.

## Data Description
Below is a description of the transformed dataset used to populate our SQL database:

| Field Name             | Description |
| ---------------------- | ----------- |
| `VendorID`             | A code indicating the TPEP provider. 1 = Creative Mobile Technologies LLC; 2 = VeriFone Inc. |
| `vendor_name`          | Categorical name of the vendor. |
| `Pickup_datetime`      | The date and time when the meter was engaged. |
| `Dropoff_datetime`     | The date and time when the meter was disengaged. |
| `passenger_count`      | The number of passengers in the vehicle. This is a driver-entered value. |
| `trip_distance`        | The elapsed trip distance in miles reported by the taximeter. |
| `PULocationID`         | TLC Taxi Zone where the taximeter was engaged. |
| `DOLocationID`         | TLC Taxi Zone where the taximeter was disengaged. |
| `RateCodeID`           | The final rate code in effect at the end of the trip. 1 = Standard rate, 2 = JFK, 3 = Newark, etc. |
| `rate_code_name`       | Categorical name of the `RateCodeID`. |
| `store_and_fwd_flag`   | Indicates whether the trip record was held in vehicle memory before sending to the vendor (Y = Yes, N = No). |
| `payment_type`         | A numeric code signifying how the passenger paid for the trip (1 = Credit card, 2 = Cash, etc.). |
| `payment_name`         | Categorical name of the `payment_type`. |
| `fare_amount`          | The time-and-distance fare calculated by the meter. |
| `extra`                | Miscellaneous extras and surcharges, including rush hour and overnight charges. |
| `mta_tax`              | $0.50 MTA tax automatically triggered based on the metered rate in use. |
| `improvement_surcharge`| $0.30 surcharge added at the flag drop, introduced in 2015. |
| `tip_amount`           | Tip amount, automatically populated for credit card tips (cash tips are not included). |
| `tolls_amount`         | Total amount of all tolls paid during the trip. |
| `total_amount`         | The total amount charged to passengers, excluding cash tips. |
| `congestion_surcharge` | Total amount collected for NYS congestion surcharge. |
| `airport_fee`          | $1.25 surcharge for pickups at LaGuardia and JFK airports. |
| `trip_time`            | Total duration of the trip. |
| `trip_time_minutes`    | Total duration of the trip in minutes. |
| `avg_mph`              | Average speed of the trip. |
| `fare_per_minute`      | Per-minute charges for the trip. |
| `tip_per_minute`       | Per-minute tip for the trip. |
| `tip_percentage`       | Tip amount as a percentage of the total fare. |
| `dropoff_zone`         | Dropoff location's zone. |
| `dropoff_borough`      | Dropoff location's borough. |
| `pickup_zone`          | Pickup location's zone. |
| `pickup_borough`       | Pickup location's borough. |
| `dropoff_time`         | Dropoff time of the trip in `hh:mm:ss` (24-hour format). |
| `dropoff_hour`         | Dropoff hour (24-hour format). |
| `dropoff_month`        | Dropoff month (1 = January, 2 = February, etc.). |
| `dropoff_year`         | Dropoff year (`yyyy` format). |
| `pickup_time`          | Pickup time of the trip in `hh:mm:ss` (24-hour format). |
| `pickup_hour`          | Pickup hour (24-hour format). |
| `pickup_month`         | Pickup month (1 = January, 2 = February, etc.). |
| `pickup_year`          | Pickup year (`yyyy` format). |
| `day_of_week`          | Day of the week (1 = Monday, 2 = Tuesday, etc.). |
| `is_holiday`           | Boolean indicating if the day is a federal holiday (based on the `USFederalHolidayCalendar` library). |

We used Yellow Taxi trip data for the years 2020-2023 collected from the [NYC Taxi & Limousine Comission website](https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page). 

## ETL Process

### Extract and Transform
Data cleaning was performed to eliminate records with negative values for trip distance, trip time, and fare amount, along with those not matching the data dictionary definitions. Records outside the years 2020-2023 containing NaN values or having a '0' trip distance were removed.

**Feature Engineering**:
- New measures: trip time in minutes, fare per minute, tip per minute, tip percentage, and average mph were calculated.
- Categorical dimensions were enriched (geographic details, i.e. burough) by merging with the `taxi_zones.csv` file from [NYC Taxi Zones Data](https://data.cityofnewyork.us/Transportation/NYC-Taxi-Zones/d3c5-ddgc). 

### Load Data to Data Warehouse
To load data into the data warehouse, set the following variables:
- Use `SQLAlchemy` to connect to the `bi_and_dw` database. If the database does not exist, it will be created.

Data is loaded into the `source_table` in batches of 1000 records.

## Star Schema

### Fact Table
The fact table stores quantitative data about each trip, such as `passenger_count`, `trip_distance`, `fare_amount`, and derived metrics like `fare_per_minute` and `avg_mph`. This structure supports fast aggregation and complex calculations across multiple dimensions.

### Dimension Tables
1. **Vendor Dimension**: Analysis by vendor.
2. **Datetime Dimension**: Time-based analysis (e.g., peak demand periods, holidays).
3. **Location Dimension**: Geographical analysis (e.g., high-demand areas, route optimization).
4. **Rate Dimension**: Pricing conditions (e.g., airport trips, peak hours).
5. **Payment Type Dimension**: Payment trends and tip analysis.

## BI Queries and Presentations
A list of SQL queries was developed to analyze taxi service data:
1. **Zones of Highest Demand**: Aggregates trip volume by pickup and dropoff zones.
2. **Total Rides and Revenue by Year**: Summarizes rides and revenue from 2020-2023.
3. **Store and Forward Analysis**: Analyzes pickup and dropoff zones for store and forward trips.
4. **Hourly Demand and Revenue**: Identifies peak hours for trips and revenue.
5. **Tip Analysis by Month**: Calculates tip percentage by month, excluding outliers above 200%.

## Setup Instructions
1. Unzip the `CabCapitalConsulting` folder.
2. Open the `Yellow_Taxi_ETL.ipynb` file in Jupyter Notebook.
3. Update the following fields with respect to your local environment:
   - `save_dir`: Local path for downloading the taxi data.
   - MySQL instance variables: `username`, `password`, `hostname`.
4. Run the `Yellow_Taxi_ETL.ipynb` script. This will create the `bi_and_dw` schema and the `source_table` with imported records (~12.2 million).
5. Run the `Create_Dimension_Tables.sql` and `Create_Fact_Table.sql` scripts to create dimension and fact tables.
6. Run the `Insert_Data.sql` script to insert data into the tables.
7. Run the BI queries in the OLAP queries folder.

---

**Note**: The ETL and BI processes in this project provide insights into optimizing taxi service operations, focusing on high-demand zones, fare analysis, and customer behavior patterns.

