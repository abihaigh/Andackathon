-- UrbanDive  |  Oracle 26ai  |  Master Run Script
-- Usage: sql admin/PASSWORD@TNSALIAS @00_run_all.sql

CONNECT admin/YOUR_PASSWORD@YOUR_TNS_ALIAS

@01_schema.sql

-- Structured data:
@02_data_air_quality_part01.sql
@02_data_air_quality_part02.sql
@02_data_bikeshare_trips_part01.sql
@02_data_bikeshare_trips_part02.sql
@02_data_bikeshare_trips_part03.sql
@02_data_bikeshare_trips_part04.sql
@02_data_congestion_events.sql
@02_data_ems_dispatch_calls_part01.sql
@02_data_ems_dispatch_calls_part02.sql
@02_data_ems_dispatch_calls_part03.sql
@02_data_environmental_sensors_part01.sql
@02_data_environmental_sensors_part02.sql
@02_data_environmental_sensors_part03.sql
@02_data_environmental_sensors_part04.sql
@02_data_fire_incidents_part01.sql
@02_data_fire_incidents_part02.sql
@02_data_hospital_diversions.sql
@02_data_hospitals.sql
@02_data_neighborhoods.sql
@02_data_noise_complaints_part01.sql
@02_data_noise_complaints_part02.sql
@02_data_pedestrian_cyclist_incidents.sql
@02_data_port_calls.sql
@02_data_property_assessments_part01.sql
@02_data_property_assessments_part02.sql
@02_data_public_health_weekly.sql
@02_data_road_incidents.sql
@02_data_sea_lion_census.sql
@02_data_sfo_airport_operations_part01.sql
@02_data_sfo_airport_operations_part02.sql
@02_data_taxi_rideshare_trips_part01.sql
@02_data_taxi_rideshare_trips_part02.sql
@02_data_taxi_rideshare_trips_part03.sql
@02_data_taxi_rideshare_trips_part04.sql
@02_data_taxi_rideshare_trips_part05.sql
@02_data_tourism_monthly.sql
@02_data_traffic_sensor_counts_part01.sql
@02_data_traffic_sensor_counts_part02.sql
@02_data_traffic_sensor_counts_part03.sql
@02_data_traffic_sensor_counts_part04.sql
@02_data_transit_ridership.sql
@02_data_transit_routes.sql
@02_data_transit_stop_connections.sql
@02_data_transit_stops.sql
@02_data_vessel_traffic_part01.sql
@02_data_vessel_traffic_part02.sql
@02_data_vessels.sql
@02_data_water_quality.sql
@02_data_weather_observations.sql
@02_data_wildfire_smoke_events.sql

-- Unstructured documents:
@03_documents_part01.sql
@03_documents_part02.sql
@03_documents_part03.sql
@03_documents_part04.sql
@03_documents_part05.sql

-- Verify row counts:
SELECT table_name, num_rows FROM user_tables ORDER BY 1;
EXIT;