-- ----------------------------------------------------------------------
-- UrbanDive | Oracle 26ai Free Tier
-- 01_SCHEMA.SQL — Create all UrbanDive tables
-- ----------------------------------------------------------------------

SET DEFINE OFF;
SET ECHO ON;

BEGIN EXECUTE IMMEDIATE 'DROP TABLE DOCUMENTS PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE NEIGHBORHOODS PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE HOSPITALS PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE TRANSIT_ROUTES PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE TRANSIT_STOPS PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE TRANSIT_STOP_CONNECTIONS PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE VESSELS PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE TOURISM_MONTHLY PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE WATER_QUALITY PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE SEA_LION_CENSUS PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE WILDFIRE_SMOKE_EVENTS PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE WEATHER_OBSERVATIONS PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE PUBLIC_HEALTH_WEEKLY PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE AIR_QUALITY PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE HOSPITAL_DIVERSIONS PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE TRANSIT_RIDERSHIP PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE PORT_CALLS PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE VESSEL_TRAFFIC PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE PROPERTY_ASSESSMENTS PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE SFO_AIRPORT_OPERATIONS PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE TRAFFIC_SENSOR_COUNTS PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE EMS_DISPATCH_CALLS PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE BIKESHARE_TRIPS PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE TAXI_RIDESHARE_TRIPS PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE CONGESTION_EVENTS PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE PEDESTRIAN_CYCLIST_INCIDENTS PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE ROAD_INCIDENTS PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE FIRE_INCIDENTS PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE NOISE_COMPLAINTS PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE ENVIRONMENTAL_SENSORS PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- ── DOCUMENTS (unstructured CLOBs) ───────────────────────────────
CREATE TABLE DOCUMENTS (
  doc_id          VARCHAR2(200)   NOT NULL,
  doc_filename    VARCHAR2(500)   NOT NULL,
  doc_type        VARCHAR2(50),
  doc_date        VARCHAR2(20),
  doc_content     CLOB,
  CONSTRAINT pk_documents PRIMARY KEY (doc_id)
);
/

-- Oracle Text full-text index
BEGIN
  EXECUTE IMMEDIATE q'[CREATE INDEX idx_doc_ctx ON DOCUMENTS(doc_content)
    INDEXTYPE IS CTXSYS.CONTEXT PARAMETERS ('SYNC (ON COMMIT)')]';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

-- ── NEIGHBORHOODS ─────────────────────────────────────────
CREATE TABLE NEIGHBORHOODS (
  NEIGHBORHOOD                              VARCHAR2(50),
  CENTER_LATITUDE                           NUMBER(12,4),
  CENTER_LONGITUDE                          NUMBER(12,4),
  SUPERVISOR_DISTRICT                       NUMBER(10),
  POPULATION_2024                           NUMBER(10),
  AREA_SQ_MILES                             NUMBER(12,4)
);
/

-- ── HOSPITALS ─────────────────────────────────────────
CREATE TABLE HOSPITALS (
  HOSPITAL_ID                               VARCHAR2(50),
  NAME                                      VARCHAR2(100),
  LATITUDE                                  NUMBER(12,4),
  LONGITUDE                                 NUMBER(12,4),
  TYPE_VAL                                  VARCHAR2(50)  -- was 'type',
  BED_COUNT                                 NUMBER(6)
);
/

-- ── TRANSIT_ROUTES ─────────────────────────────────────────
CREATE TABLE TRANSIT_ROUTES (
  ROUTE_ID                                  VARCHAR2(50),
  ROUTE_NAME                                VARCHAR2(50),
  ROUTE_TYPE                                VARCHAR2(50),
  NUM_STOPS                                 NUMBER(10)
);
/

-- ── TRANSIT_STOPS ─────────────────────────────────────────
CREATE TABLE TRANSIT_STOPS (
  STOP_ID                                   VARCHAR2(50),
  STOP_NAME                                 VARCHAR2(50),
  ROUTE_ID                                  VARCHAR2(50),
  LATITUDE                                  NUMBER(12,4),
  LONGITUDE                                 NUMBER(12,4),
  STOP_SEQUENCE                             NUMBER(10)
);
/

-- ── TRANSIT_STOP_CONNECTIONS ─────────────────────────────────────────
CREATE TABLE TRANSIT_STOP_CONNECTIONS (
  FROM_STOP_ID                              VARCHAR2(50),
  TO_STOP_ID                                VARCHAR2(50),
  ROUTE_ID                                  VARCHAR2(50),
  DIRECTION                                 VARCHAR2(50),
  AVG_TRAVEL_TIME_MIN                       NUMBER(12,4)
);
/

-- ── VESSELS ─────────────────────────────────────────
CREATE TABLE VESSELS (
  MMSI                                      NUMBER(12),
  VESSEL_NAME                               VARCHAR2(50),
  VESSEL_TYPE                               VARCHAR2(50),
  FLAG                                      VARCHAR2(50),
  LENGTH_M                                  NUMBER(6)
);
/

-- ── TOURISM_MONTHLY ─────────────────────────────────────────
CREATE TABLE TOURISM_MONTHLY (
  YEAR_VAL                                  NUMBER(10)  -- was 'year',
  MONTH_VAL                                 NUMBER(10)  -- was 'month',
  MONTH_NAME                                VARCHAR2(50),
  ESTIMATED_VISITORS                        NUMBER(10),
  ESTIMATED_SPENDING_MILLIONS               NUMBER(12,4),
  HOTEL_OCCUPANCY_PCT                       NUMBER(12,4),
  AVG_DAILY_ROOM_RATE                       NUMBER(12,4),
  CONVENTION_EVENTS                         NUMBER(10)
);
/

-- ── WATER_QUALITY ─────────────────────────────────────────
CREATE TABLE WATER_QUALITY (
  SAMPLE_ID                                 VARCHAR2(50),
  STATION_ID                                VARCHAR2(50),
  STATION_NAME                              VARCHAR2(50),
  SAMPLE_DATE                               DATE,
  LATITUDE                                  NUMBER(12,4),
  LONGITUDE                                 NUMBER(12,4),
  WATER_TEMP_C                              NUMBER(12,4),
  SALINITY_PPT                              NUMBER(12,4),
  DISSOLVED_OXYGEN_MG_L                     NUMBER(12,4),
  PH                                        NUMBER(12,4),
  TURBIDITY_NTU                             NUMBER(12,4),
  CHLOROPHYLL_UG_L                          NUMBER(12,4),
  E_COLI_MPN_100ML                          NUMBER(12,4),
  DEPTH_M                                   NUMBER(12,4)
);
/

-- ── SEA_LION_CENSUS ─────────────────────────────────────────
CREATE TABLE SEA_LION_CENSUS (
  CENSUS_ID                                 VARCHAR2(50),
  CENSUS_DATE                               DATE,
  SITE_ID                                   VARCHAR2(50),
  SITE_NAME                                 VARCHAR2(50),
  LATITUDE                                  NUMBER(12,4),
  LONGITUDE                                 NUMBER(12,4),
  ADULT_COUNT                               NUMBER(10),
  PUP_COUNT                                 NUMBER(10),
  OBSERVER                                  VARCHAR2(50),
  WEATHER_CONDITIONS                        VARCHAR2(500),
  NOTES                                     VARCHAR2(4000)
);
/

-- ── WILDFIRE_SMOKE_EVENTS ─────────────────────────────────────────
CREATE TABLE WILDFIRE_SMOKE_EVENTS (
  EVENT_ID                                  VARCHAR2(50),
  FIRE_NAME                                 VARCHAR2(50),
  START_DATE                                DATE,
  END_DATE                                  DATE,
  DURATION_DAYS                             NUMBER(10),
  PEAK_AQI_SF                               NUMBER(10),
  AVG_AQI_SF_DURING_EVENT                   NUMBER(12,4),
  AQI_CATEGORY                              VARCHAR2(100),
  PM25_PEAK_UG_M3                           NUMBER(12,4),
  AFFECTED_BAY_AREAS                        VARCHAR2(2000),
  HEALTH_ADVISORY_ISSUED                    NUMBER(10),
  SCHOOLS_CLOSED                            NUMBER(10),
  OUTDOOR_EVENTS_CANCELLED                  NUMBER(10),
  ESTIMATED_SF_ER_VISITS_INCREASE_PCT       NUMBER(12,4),
  SOURCE_FIRE_COUNTY                        VARCHAR2(50)
);
/

-- ── WEATHER_OBSERVATIONS ─────────────────────────────────────────
CREATE TABLE WEATHER_OBSERVATIONS (
  OBS_ID                                    VARCHAR2(50),
  STATION_ID                                VARCHAR2(50),
  STATION_NAME                              VARCHAR2(50),
  OBS_DATE                                  DATE,
  LATITUDE                                  NUMBER(12,4),
  LONGITUDE                                 NUMBER(12,4),
  TEMP_MAX_C                                NUMBER(12,4),
  TEMP_MIN_C                                NUMBER(12,4),
  TEMP_AVG_C                                NUMBER(12,4),
  PRECIPITATION_MM                          NUMBER(12,4),
  WIND_SPEED_MPH                            NUMBER(12,4),
  WIND_DIRECTION                            VARCHAR2(50),
  FOG_HOURS                                 NUMBER(10),
  VISIBILITY_MILES                          NUMBER(12,4),
  HUMIDITY_PCT                              NUMBER(12,4),
  PRESSURE_MB                               NUMBER(12,4),
  FIRE_WEATHER_INDEX                        VARCHAR2(50),
  DIABLO_WIND_EVENT                         NUMBER(10)
);
/

-- ── PUBLIC_HEALTH_WEEKLY ─────────────────────────────────────────
CREATE TABLE PUBLIC_HEALTH_WEEKLY (
  WEEK_ID                                   VARCHAR2(50),
  WEEK_START_DATE                           DATE,
  WEEK_END_DATE                             DATE,
  YEAR_VAL                                  NUMBER(10),
  WEEK_OF_YEAR                              NUMBER(10),
  NEIGHBORHOOD                              VARCHAR2(50),
  RESPIRATORY_ER_VISITS                     NUMBER(10),
  CARDIAC_ER_VISITS                         NUMBER(10),
  MENTAL_HEALTH_CRISIS_CALLS                NUMBER(10),
  HEAT_ILLNESS_CASES                        NUMBER(10),
  FLU_LIKE_ILLNESS_CASES                    NUMBER(10),
  ASTHMA_ATTACKS_REPORTED                   NUMBER(10),
  AMBULANCE_TRANSPORTS                      NUMBER(10),
  HOSPITAL_DIVERSIONS_COUNT                 NUMBER(10),
  AVG_AQI_WEEK                              NUMBER(10),
  SMOKE_EVENT_WEEK                          NUMBER(10),
  HIGH_HEAT_WEEK                            NUMBER(10)
);
/

-- ── AIR_QUALITY ─────────────────────────────────────────
CREATE TABLE AIR_QUALITY (
  STATION_ID                                VARCHAR2(50),
  STATION_NAME                              VARCHAR2(50),
  READING_DATETIME                          TIMESTAMP,
  LATITUDE                                  NUMBER(12,4),
  LONGITUDE                                 NUMBER(12,4),
  PM25_UG_M3                                NUMBER(12,4),
  PM10_UG_M3                                NUMBER(12,4),
  OZONE_PPB                                 NUMBER(12,4),
  NO2_PPB                                   NUMBER(12,4),
  CO_PPM                                    NUMBER(12,4),
  AQI                                       NUMBER(10),
  AQI_CATEGORY                              VARCHAR2(100)
);
/

-- ── HOSPITAL_DIVERSIONS ─────────────────────────────────────────
CREATE TABLE HOSPITAL_DIVERSIONS (
  DIVERSION_ID                              VARCHAR2(50),
  HOSPITAL_ID                               VARCHAR2(50),
  HOSPITAL_NAME                             VARCHAR2(100),
  START_DATETIME                            TIMESTAMP,
  END_DATETIME                              TIMESTAMP,
  DURATION_HOURS                            NUMBER(12,4),
  REASON                                    VARCHAR2(50)
);
/

-- ── TRANSIT_RIDERSHIP ─────────────────────────────────────────
CREATE TABLE TRANSIT_RIDERSHIP (
  EVENT_DATE                                DATE  -- was 'date',
  ROUTE_ID                                  VARCHAR2(50),
  ROUTE_NAME                                VARCHAR2(50),
  RIDERSHIP                                 NUMBER(10),
  AVG_LOAD_PCT                              NUMBER(12,4)
);
/

-- ── PORT_CALLS ─────────────────────────────────────────
CREATE TABLE PORT_CALLS (
  CALL_ID                                   VARCHAR2(50),
  MMSI                                      NUMBER(12),
  VESSEL_NAME                               VARCHAR2(50),
  ARRIVAL_DATETIME                          TIMESTAMP,
  DEPARTURE_DATETIME                        TIMESTAMP,
  BERTH                                     VARCHAR2(50),
  CARGO_TYPE                                VARCHAR2(500)
);
/

-- ── VESSEL_TRAFFIC ─────────────────────────────────────────
CREATE TABLE VESSEL_TRAFFIC (
  TRANSIT_ID                                VARCHAR2(50),
  TIMESTAMP                                 VARCHAR2(50),
  MMSI                                      NUMBER(12),
  VESSEL_NAME                               VARCHAR2(50),
  VESSEL_TYPE                               VARCHAR2(50),
  WAYPOINT_NAME                             VARCHAR2(50),
  LATITUDE                                  NUMBER(12,4),
  LONGITUDE                                 NUMBER(12,4),
  SPEED_KNOTS                               NUMBER(12,4),
  HEADING_DEG                               NUMBER(12,4),
  DRAFT_M                                   NUMBER(12,4)
);
/

-- ── PROPERTY_ASSESSMENTS ─────────────────────────────────────────
CREATE TABLE PROPERTY_ASSESSMENTS (
  PARCEL_ID                                 VARCHAR2(50),
  ASSESSMENT_YEAR                           NUMBER(10),
  NEIGHBORHOOD                              VARCHAR2(50),
  PROPERTY_TYPE                             VARCHAR2(50),
  ASSESSED_LAND_VALUE                       NUMBER(12),
  ASSESSED_IMPROVEMENT_VALUE                NUMBER(12),
  TOTAL_ASSESSED_VALUE                      NUMBER(12),
  YEAR_BUILT                                NUMBER(10),
  SQFT                                      NUMBER(10),
  BEDROOMS                                  NUMBER(10),
  LATITUDE                                  NUMBER(12,4),
  LONGITUDE                                 NUMBER(12,4)
);
/

-- ── SFO_AIRPORT_OPERATIONS ─────────────────────────────────────────
CREATE TABLE SFO_AIRPORT_OPERATIONS (
  FLIGHT_ID                                 VARCHAR2(50),
  OPERATION_DATE                            DATE,
  SCHEDULED_DATETIME                        TIMESTAMP,
  ACTUAL_DATETIME                           TIMESTAMP,
  OPERATION_TYPE                            VARCHAR2(50),
  AIRLINE                                   VARCHAR2(50),
  ORIGIN_DESTINATION                        VARCHAR2(50),
  TERMINAL                                  VARCHAR2(50),
  GATE                                      VARCHAR2(50),
  AIRCRAFT_TYPE                             VARCHAR2(50),
  PASSENGER_COUNT                           NUMBER(6),
  DELAY_MINUTES                             NUMBER(10),
  DELAY_REASON                              VARCHAR2(1000),
  RUNWAY                                    VARCHAR2(50)
);
/

-- ── TRAFFIC_SENSOR_COUNTS ─────────────────────────────────────────
CREATE TABLE TRAFFIC_SENSOR_COUNTS (
  SENSOR_ID                                 VARCHAR2(50),
  SENSOR_NAME                               VARCHAR2(50),
  READING_DATETIME                          TIMESTAMP,
  LATITUDE                                  NUMBER(12,4),
  LONGITUDE                                 NUMBER(12,4),
  SENSOR_TYPE                               VARCHAR2(50),
  VEHICLE_COUNT                             NUMBER(10),
  AVG_SPEED_MPH                             NUMBER(12,4),
  OCCUPANCY_PCT                             NUMBER(12,4)
);
/

-- ── EMS_DISPATCH_CALLS ─────────────────────────────────────────
CREATE TABLE EMS_DISPATCH_CALLS (
  CALL_ID                                   VARCHAR2(50),
  CALL_DATETIME                             TIMESTAMP,
  CALL_TYPE                                 VARCHAR2(50),
  PRIORITY                                  VARCHAR2(100),
  NEIGHBORHOOD                              VARCHAR2(50),
  LATITUDE                                  NUMBER(12,4),
  LONGITUDE                                 NUMBER(12,4),
  RESPONSE_TIME_SECONDS                     NUMBER(10),
  TRANSPORT_TO_HOSPITAL                     VARCHAR2(50),
  UNIT_TYPE                                 VARCHAR2(50),
  NUM_UNITS_DISPATCHED                      NUMBER(10),
  DISPOSITION                               VARCHAR2(50)
);
/

-- ── BIKESHARE_TRIPS ─────────────────────────────────────────
CREATE TABLE BIKESHARE_TRIPS (
  RIDE_ID                                   VARCHAR2(50),
  START_DATETIME                            TIMESTAMP,
  END_DATETIME                              TIMESTAMP,
  START_STATION_ID                          VARCHAR2(50),
  START_STATION_NAME                        VARCHAR2(50),
  END_STATION_ID                            VARCHAR2(50),
  END_STATION_NAME                          VARCHAR2(50),
  START_LATITUDE                            NUMBER(12,4),
  START_LONGITUDE                           NUMBER(12,4),
  END_LATITUDE                              NUMBER(12,4),
  END_LONGITUDE                             NUMBER(12,4),
  BIKE_TYPE                                 VARCHAR2(50),
  DURATION_MINUTES                          NUMBER(12,4),
  MEMBER_TYPE                               VARCHAR2(50)
);
/

-- ── TAXI_RIDESHARE_TRIPS ─────────────────────────────────────────
CREATE TABLE TAXI_RIDESHARE_TRIPS (
  TRIP_ID                                   VARCHAR2(50),
  TRIP_TYPE                                 VARCHAR2(50),
  PICKUP_DATETIME                           TIMESTAMP,
  DROPOFF_DATETIME                          TIMESTAMP,
  PICKUP_NEIGHBORHOOD                       VARCHAR2(50),
  DROPOFF_NEIGHBORHOOD                      VARCHAR2(50),
  PICKUP_LATITUDE                           NUMBER(12,4),
  PICKUP_LONGITUDE                          NUMBER(12,4),
  DROPOFF_LATITUDE                          NUMBER(12,4),
  DROPOFF_LONGITUDE                         NUMBER(12,4),
  DISTANCE_MILES                            NUMBER(12,4),
  FARE_AMOUNT                               NUMBER(12,4),
  TIP_AMOUNT                                NUMBER(12,4),
  PAYMENT_TYPE                              VARCHAR2(50),
  PASSENGER_COUNT                           NUMBER(6)
);
/

-- ── CONGESTION_EVENTS ─────────────────────────────────────────
CREATE TABLE CONGESTION_EVENTS (
  CONGESTION_ID                             VARCHAR2(50),
  START_DATETIME                            TIMESTAMP,
  END_DATETIME                              TIMESTAMP,
  EVENT_DATE                                DATE,
  YEAR_VAL                                  NUMBER(10),
  HOUR_OF_DAY                               NUMBER(10),
  DAY_OF_WEEK                               VARCHAR2(50),
  CORRIDOR_ID                               VARCHAR2(50),
  CORRIDOR_NAME                             VARCHAR2(50),
  CORRIDOR_TYPE                             VARCHAR2(50),
  NEIGHBORHOOD                              VARCHAR2(50),
  PRIMARY_CAUSE                             VARCHAR2(50),
  SPECIAL_EVENT_NAME                        VARCHAR2(100),
  DURATION_HOURS                            NUMBER(12,4),
  AVG_DELAY_MIN                             NUMBER(10),
  SEVERITY                                  VARCHAR2(50),
  SPEED_PCT_OF_NORMAL                       NUMBER(12,4),
  ESTIMATED_VEHICLES_AFFECTED               NUMBER(10),
  LINKED_INCIDENT_ID                        VARCHAR2(50),
  TRANSIT_IMPACT                            VARCHAR2(50),
  IS_RUSH_HOUR                              NUMBER(10)
);
/

-- ── PEDESTRIAN_CYCLIST_INCIDENTS ─────────────────────────────────────────
CREATE TABLE PEDESTRIAN_CYCLIST_INCIDENTS (
  INCIDENT_ID                               VARCHAR2(50),
  INCIDENT_DATETIME                         TIMESTAMP,
  INCIDENT_DATE                             DATE,
  YEAR_VAL                                  NUMBER(10),
  HOUR_OF_DAY                               NUMBER(10),
  DAY_OF_WEEK                               VARCHAR2(50),
  LOCATION_NAME                             VARCHAR2(50),
  LATITUDE                                  NUMBER(12,4),
  LONGITUDE                                 NUMBER(12,4),
  NEIGHBORHOOD                              VARCHAR2(50),
  VICTIM_TYPE                               VARCHAR2(50),
  PRIMARY_CAUSE                             VARCHAR2(50),
  SEVERITY                                  VARCHAR2(50),
  VEHICLE_INVOLVED                          VARCHAR2(50),
  VEHICLE_TYPE                              VARCHAR2(50),
  HIT_AND_RUN                               NUMBER(10),
  DUI_INVOLVED                              NUMBER(10),
  AT_CROSSWALK                              NUMBER(10),
  SIGNAL_PRESENT                            NUMBER(10),
  POOR_LIGHTING                             NUMBER(10),
  WET_ROAD                                  NUMBER(10),
  EMS_DISPATCHED                            NUMBER(10),
  TRANSPORTED_TO_HOSPITAL                   NUMBER(10)
);
/

-- ── ROAD_INCIDENTS ─────────────────────────────────────────
CREATE TABLE ROAD_INCIDENTS (
  INCIDENT_ID                               VARCHAR2(50),
  INCIDENT_DATETIME                         TIMESTAMP,
  INCIDENT_DATE                             DATE,
  INCIDENT_YEAR                             NUMBER(10),
  INCIDENT_HOUR                             NUMBER(10),
  DAY_OF_WEEK                               VARCHAR2(50),
  LOCATION_NAME                             VARCHAR2(50),
  LATITUDE                                  NUMBER(12,4),
  LONGITUDE                                 NUMBER(12,4),
  ROAD_TYPE                                 VARCHAR2(50),
  INCIDENT_TYPE                             VARCHAR2(50),
  SEVERITY                                  VARCHAR2(50),
  DURATION_HOURS                            NUMBER(12,4),
  LANES_BLOCKED                             NUMBER(10),
  IS_RUSH_HOUR                              NUMBER(10),
  IS_WEEKEND                                NUMBER(10),
  RAIN_RELATED                              NUMBER(10),
  UNITS_RESPONDED                           NUMBER(10),
  CONGESTION_DELAY_MIN                      NUMBER(10),
  CLOSURE_TYPE                              VARCHAR2(50)
);
/

-- ── FIRE_INCIDENTS ─────────────────────────────────────────
CREATE TABLE FIRE_INCIDENTS (
  INCIDENT_ID                               VARCHAR2(50),
  INCIDENT_DATETIME                         TIMESTAMP,
  INCIDENT_DATE                             DATE,
  INCIDENT_YEAR                             NUMBER(10),
  INCIDENT_MONTH                            NUMBER(10),
  INCIDENT_HOUR                             NUMBER(10),
  DAY_OF_WEEK                               VARCHAR2(50),
  INCIDENT_TYPE                             VARCHAR2(50),
  PRIORITY_CODE                             VARCHAR2(50),
  NEIGHBORHOOD                              VARCHAR2(50),
  LATITUDE                                  NUMBER(12,4),
  LONGITUDE                                 NUMBER(12,4),
  NUM_UNITS_DISPATCHED                      NUMBER(10),
  PRIMARY_UNIT_TYPE                         VARCHAR2(50),
  RESPONSE_TIME_SECONDS                     NUMBER(10),
  ON_SCENE_DURATION_MIN                     NUMBER(12,4),
  CIVILIAN_INJURIES                         NUMBER(10),
  CIVILIAN_FATALITIES                       NUMBER(10),
  FIREFIGHTER_INJURIES                      NUMBER(10),
  ESTIMATED_PROPERTY_LOSS_USD               NUMBER(14),
  FIRE_CONTAINED                            VARCHAR2(50),
  ARSON_SUSPECTED                           NUMBER(10)
);
/

-- ── NOISE_COMPLAINTS ─────────────────────────────────────────
CREATE TABLE NOISE_COMPLAINTS (
  COMPLAINT_ID                              VARCHAR2(50),
  COMPLAINT_DATETIME                        TIMESTAMP,
  COMPLAINT_DATE                            DATE,
  YEAR_VAL                                  NUMBER(10),
  MONTH_VAL                                 NUMBER(10),
  HOUR_OF_DAY                               NUMBER(10),
  DAY_OF_WEEK                               VARCHAR2(50),
  NEIGHBORHOOD                              VARCHAR2(50),
  LATITUDE                                  NUMBER(12,4),
  LONGITUDE                                 NUMBER(12,4),
  NOISE_TYPE                                VARCHAR2(100),
  DECIBEL_ESTIMATE_DB                       NUMBER(12,4),
  REPORTED_VIA                              VARCHAR2(50),
  IS_REPEAT_LOCATION                        NUMBER(10),
  OFFICER_DISPATCHED                        NUMBER(10),
  RESPONSE_TIME_MIN                         NUMBER(12,4),
  OUTCOME                                   VARCHAR2(50),
  TRAFFIC_ADJACENT                          NUMBER(10),
  NIGHTTIME                                 NUMBER(10)
);
/

-- ── ENVIRONMENTAL_SENSORS ─────────────────────────────────────────
CREATE TABLE ENVIRONMENTAL_SENSORS (
  READING_ID                                VARCHAR2(50),
  SENSOR_ID                                 VARCHAR2(50),
  SENSOR_NAME                               VARCHAR2(50),
  READING_DATETIME                          TIMESTAMP,
  LATITUDE                                  NUMBER(12,4),
  LONGITUDE                                 NUMBER(12,4),
  ZONE_TYPE                                 VARCHAR2(50),
  NOISE_DB                                  NUMBER(12,4),
  UV_INDEX                                  NUMBER(12,4),
  PM25_STREET_UG_M3                         NUMBER(12,4),
  CO_STREET_PPM                             NUMBER(12,4),
  VIBRATION_MG                              NUMBER(12,4),
  IS_RUSH_HOUR                              NUMBER(10),
  IS_NIGHTTIME                              NUMBER(10)
);
/

CREATE INDEX idx_air_quality_reading_da ON AIR_QUALITY(READING_DATETIME);
/
CREATE INDEX idx_ems_dispatch_call_datet ON EMS_DISPATCH_CALLS(CALL_DATETIME);
/
CREATE INDEX idx_ems_dispatch_neighborho ON EMS_DISPATCH_CALLS(NEIGHBORHOOD);
/
CREATE INDEX idx_fire_inciden_incident_d ON FIRE_INCIDENTS(INCIDENT_DATETIME);
/
CREATE INDEX idx_noise_compla_neighborho ON NOISE_COMPLAINTS(NEIGHBORHOOD);
/
CREATE INDEX idx_traffic_sens_reading_da ON TRAFFIC_SENSOR_COUNTS(READING_DATETIME);
/
CREATE INDEX idx_taxi_ridesha_pickup_dat ON TAXI_RIDESHARE_TRIPS(PICKUP_DATETIME);
/
CREATE INDEX idx_property_ass_neighborho ON PROPERTY_ASSESSMENTS(NEIGHBORHOOD);
/
CREATE INDEX idx_vessel_traff_mmsi ON VESSEL_TRAFFIC(MMSI);
/
CREATE INDEX idx_water_qualit_station_id ON WATER_QUALITY(STATION_ID);
/
CREATE INDEX idx_hospital_div_hospital_i ON HOSPITAL_DIVERSIONS(HOSPITAL_ID);
/
CREATE INDEX idx_public_healt_neighborho ON PUBLIC_HEALTH_WEEKLY(NEIGHBORHOOD);
/

COMMIT;