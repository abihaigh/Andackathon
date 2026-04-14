# UrbanDive · Oracle 26ai · SQL Load Guide

> **Everything you need to load 275,000+ rows of structured data and 235 unstructured documents into an Oracle Autonomous Database (26ai Free Tier) — using only the supplied `.sql` files. No OCI bucket, no external filesystem.**

---

## 1. What Is In This Package

| File pattern | Purpose | Count |
|---|---|---|
| `00_run_all.sql` | Master orchestration script — runs all others | 1 |
| `01_schema.sql` | DROP + CREATE for all 29 tables + DOCUMENTS + indexes | 1 |
| `02_data_<table>[_partNN].sql` | INSERT statements for each CSV dataset | 50 |
| `03_documents_partNN.sql` | PL/SQL CLOB inserts for the 235 unstructured `.txt` files | 5 |
| `HOW_TO_LOAD.md` | This document | 1 |

**Total: ~57 SQL files, ~496 MB of self-contained Oracle SQL.**

### Tables created

| Table | Source CSV | Rows |
|---|---|---|
| NEIGHBORHOODS | neighborhoods.csv | 30 |
| HOSPITALS | hospitals.csv | 10 |
| TRANSIT_ROUTES | transit_routes.csv | 16 |
| TRANSIT_STOPS | transit_stops.csv | 56 |
| TRANSIT_STOP_CONNECTIONS | transit_stop_connections.csv | 40 |
| VESSELS | vessels.csv | 500 |
| TOURISM_MONTHLY | tourism_monthly.csv | 60 |
| WATER_QUALITY | water_quality.csv | 2,088 |
| SEA_LION_CENSUS | sea_lion_census.csv | 524 |
| WILDFIRE_SMOKE_EVENTS | wildfire_smoke_events.csv | 23 |
| WEATHER_OBSERVATIONS | weather_observations.csv | 5,478 |
| PUBLIC_HEALTH_WEEKLY | public_health_weekly.csv | 5,220 |
| AIR_QUALITY | air_quality.csv | 51,128 |
| HOSPITAL_DIVERSIONS | hospital_diversions.csv | 8,000 |
| TRANSIT_RIDERSHIP | transit_ridership.csv | 29,216 |
| PORT_CALLS | port_calls.csv | 15,000 |
| VESSEL_TRAFFIC | vessel_traffic.csv | 50,000 |
| PROPERTY_ASSESSMENTS | property_assessments.csv | 80,000 |
| SFO_AIRPORT_OPERATIONS | sfo_airport_operations.csv | 60,000 |
| TRAFFIC_SENSOR_COUNTS | traffic_sensor_counts.csv | 131,472 |
| EMS_DISPATCH_CALLS | ems_dispatch_calls.csv | 120,000 |
| BIKESHARE_TRIPS | bikeshare_trips.csv | 135,243 |
| TAXI_RIDESHARE_TRIPS | taxi_rideshare_trips.csv | 200,000 |
| CONGESTION_EVENTS | congestion_events.csv | 4,500 |
| PEDESTRIAN_CYCLIST_INCIDENTS | pedestrian_cyclist_incidents.csv | 14,000 |
| ROAD_INCIDENTS | road_incidents.csv | 22,000 |
| FIRE_INCIDENTS | fire_incidents.csv | 48,000 |
| NOISE_COMPLAINTS | noise_complaints.csv | 45,000 |
| ENVIRONMENTAL_SENSORS | environmental_sensors.csv | 131,472 |
| **DOCUMENTS** | 235 × .txt files (CLOBs) | 235 |

---

## 2. Prerequisites

### 2a. Oracle Autonomous Database (26ai Free Tier)
- An ADW or ATP instance provisioned in Oracle Cloud
- Wallet downloaded (`.zip`) and extracted to a local directory
- `TNS_ADMIN` environment variable pointing to the wallet directory

### 2b. Client tool — choose one

| Tool | Best for |
|---|---|
| **SQLcl** (recommended) | Modern CLI, scripting, large files |
| **SQL*Plus** | Classic, always available |
| **Oracle SQL Developer** | GUI, progress visibility |

### 2c. Java (for SQLcl)
SQLcl requires Java 11+. Check: `java -version`

---

## 3. Setting Up SQLcl

```bash
# Download SQLcl from Oracle (free)
# https://www.oracle.com/database/sqldeveloper/technologies/sqlcl/

# Unzip and add to PATH
export PATH=/opt/sqlcl/bin:$PATH

# Point to your wallet
export TNS_ADMIN=/path/to/your/wallet
```

---

## 4. Loading: The Fast Way (run_all)

Edit `00_run_all.sql` — replace the CONNECT line with your actual credentials:

```sql
-- Change this line:
CONNECT admin/YOUR_PASSWORD@YOUR_TNS_ALIAS
-- To something like:
CONNECT admin/MyS3cur3Pwd!@urbandive_high
```

Then run from the directory containing all `.sql` files:

```bash
cd /path/to/urbandive_sql
sql /nolog @00_run_all.sql
```

SQLcl will chain through all 57 files automatically, committing every 500 rows.

---

## 5. Loading: Step by Step (manual)

If you prefer to load incrementally or troubleshoot table by table:

### Step 1 — Connect

```bash
sql admin/YOUR_PASSWORD@YOUR_TNS_ALIAS
```

Or using wallet interactively:

```bash
sql /nolog
SQL> CONNECT admin@urbandive_high
Password: ________
```

### Step 2 — Create schema (DROP + CREATE)

```sql
SQL> SET DEFINE OFF
SQL> @01_schema.sql
```

This creates all 30 tables plus the Oracle Text full-text index on DOCUMENTS.

### Step 3 — Load structured data (CSVs)

Run files in the order listed below to respect foreign key readiness.
Small tables first, large tables last:

```sql
-- Reference / dimension tables
@02_data_neighborhoods.sql
@02_data_hospitals.sql
@02_data_transit_routes.sql
@02_data_transit_stops.sql
@02_data_transit_stop_connections.sql
@02_data_vessels.sql
@02_data_tourism_monthly.sql

-- Observation / fact tables
@02_data_water_quality.sql
@02_data_sea_lion_census.sql
@02_data_wildfire_smoke_events.sql
@02_data_weather_observations.sql
@02_data_public_health_weekly.sql

-- Large fact tables (may take several minutes each)
@02_data_air_quality_part01.sql
@02_data_air_quality_part02.sql
@02_data_hospital_diversions.sql
@02_data_transit_ridership.sql
@02_data_port_calls.sql
@02_data_vessel_traffic_part01.sql
@02_data_vessel_traffic_part02.sql
@02_data_property_assessments_part01.sql
@02_data_property_assessments_part02.sql
@02_data_sfo_airport_operations_part01.sql
@02_data_sfo_airport_operations_part02.sql
@02_data_traffic_sensor_counts_part01.sql
@02_data_traffic_sensor_counts_part02.sql
@02_data_traffic_sensor_counts_part03.sql
@02_data_traffic_sensor_counts_part04.sql
@02_data_ems_dispatch_calls_part01.sql
@02_data_ems_dispatch_calls_part02.sql
@02_data_ems_dispatch_calls_part03.sql
@02_data_bikeshare_trips_part01.sql
-- ... (etc.)
@02_data_taxi_rideshare_trips_part01.sql
-- ... (etc.)
```

### Step 4 — Load unstructured documents (CLOBs)

```sql
@03_documents_part01.sql
@03_documents_part02.sql
@03_documents_part03.sql
@03_documents_part04.sql
@03_documents_part05.sql
```

Each document is inserted via a PL/SQL anonymous block that uses `DBMS_LOB.CREATETEMPORARY` + `DBMS_LOB.APPEND` to safely handle text longer than Oracle's 4,000-char SQL literal limit.

---

## 6. Verifying the Load

After loading, run these verification queries:

```sql
-- Row count per table
SELECT table_name, num_rows
FROM   user_tables
ORDER  BY table_name;

-- If num_rows shows 0 (stats not gathered), gather and recheck:
BEGIN
  DBMS_STATS.GATHER_SCHEMA_STATS(ownname => USER);
END;
/

-- Spot-check specific tables
SELECT COUNT(*) FROM TAXI_RIDESHARE_TRIPS;   -- expect 200,000
SELECT COUNT(*) FROM DOCUMENTS;              -- expect 235
SELECT COUNT(*) FROM AIR_QUALITY;            -- expect 51,128

-- Verify CLOB content is readable
SELECT doc_filename, DBMS_LOB.GETLENGTH(doc_content) AS char_len,
       SUBSTR(doc_content, 1, 100) AS preview
FROM   DOCUMENTS
WHERE  ROWNUM <= 5;

-- Full-text search on documents (Oracle Text)
SELECT doc_filename, doc_type, doc_date
FROM   DOCUMENTS
WHERE  CONTAINS(doc_content, 'ambulance') > 0
ORDER  BY doc_date;
```

---

## 7. Performance Tips

### For large-table loads

If the `02_data_*` files are taking too long, you can disable constraint checking temporarily:

```sql
-- Disable all constraints on a table
ALTER TABLE TAXI_RIDESHARE_TRIPS DISABLE ALL CONSTRAINTS;
-- ... load ...
ALTER TABLE TAXI_RIDESHARE_TRIPS ENABLE ALL CONSTRAINTS;
```

### AUTOCOMMIT vs manual COMMIT

The SQL files issue a `COMMIT` every 500 rows. If you want faster loads and are comfortable with a full rollback on error, you can set autocommit off and commit once at the end:

```sql
SET AUTOCOMMIT OFF
@02_data_fire_incidents_part01.sql
COMMIT;
```

### Parallelism (SQL Developer only)

SQL Developer allows running multiple script windows simultaneously. You can load independent tables (e.g., FIRE_INCIDENTS and BIKESHARE_TRIPS) in parallel windows to cut total load time roughly in half.

---

## 8. Column Naming Notes

Several CSV columns used Oracle reserved words and were renamed in the DDL:

| Original CSV column | Oracle column name | Reason |
|---|---|---|
| `date` | `EVENT_DATE` | Reserved word |
| `year` | `YEAR_VAL` | Reserved word |
| `month` | `MONTH_VAL` | Reserved word |
| `type` | `TYPE_VAL` | Reserved word |
| `level` | `LEVEL_VAL` | Reserved word |
| `comment` | `COMMENT_TXT` | Reserved word |

The INSERT files use the renamed column names to match the DDL.

---

## 9. Unstructured Documents — CLOB Detail

Each `.txt` file is stored in the `DOCUMENTS` table with the following structure:

| Column | Type | Content |
|---|---|---|
| `doc_id` | VARCHAR2(200) | Filename stem (e.g., `dispatch_transcript_20210120_024`) |
| `doc_filename` | VARCHAR2(500) | Full filename with `.txt` extension |
| `doc_type` | VARCHAR2(50) | Inferred category: `dispatch_transcript`, `incident_report`, `field_notes`, `inspection`, `meeting_notes` |
| `doc_date` | VARCHAR2(20) | Date extracted from filename (`YYYY-MM-DD`) |
| `doc_content` | CLOB | Full text content |

**Oracle Text index** (`idx_doc_ctx`) is created automatically, enabling:

```sql
-- CONTAINS query (much faster than LIKE on CLOBs)
SELECT doc_filename, doc_type
FROM   DOCUMENTS
WHERE  CONTAINS(doc_content, 'hospital AND diversion') > 0;

-- Fuzzy search
SELECT doc_filename
FROM   DOCUMENTS
WHERE  CONTAINS(doc_content, 'FUZZY(hazmaat, 70)') > 0;

-- Proximity search
SELECT doc_filename
FROM   DOCUMENTS
WHERE  CONTAINS(doc_content, 'engine NEAR fire') > 0;
```

---

## 10. Common Errors & Fixes

| Error | Likely cause | Fix |
|---|---|---|
| `ORA-01017: invalid username/password` | Wrong credentials | Check CONNECT line in `00_run_all.sql` |
| `ORA-12154: TNS could not resolve alias` | Wrong TNS alias or `TNS_ADMIN` not set | Verify `$TNS_ADMIN` points to wallet dir |
| `ORA-01450: maximum key length exceeded` | VARCHAR2 index too wide | Not expected with this DDL; re-run `01_schema.sql` |
| `ORA-00942: table or view does not exist` | Running data files before schema | Always run `01_schema.sql` first |
| `ORA-01722: invalid number` | Unexpected non-numeric data | Check source CSV for data quality issues |
| `ORA-04036: PGA memory used` | Very large CLOB block | Restart session; CLOBs use temp PGA |
| `SP2-0027: Input too long` | SQL*Plus 4000-char line limit | Switch to SQLcl (no line limit) or SQL Developer |
| `CTX-20000: index already exists` | Re-running schema | Safe to ignore — schema uses `EXCEPTION WHEN OTHERS THEN NULL` |

---

## 11. Oracle 26ai Feature Hooks

This dataset is designed to showcase Oracle 26ai capabilities:

### Property Graph
```sql
-- Transit network as a graph
CREATE PROPERTY GRAPH transit_graph
  VERTEX TABLES (TRANSIT_STOPS LABEL stop PROPERTIES ALL COLUMNS)
  EDGE TABLES (TRANSIT_STOP_CONNECTIONS
    SOURCE KEY (from_stop_id) REFERENCES TRANSIT_STOPS(stop_id)
    DESTINATION KEY (to_stop_id) REFERENCES TRANSIT_STOPS(stop_id)
    LABEL connection PROPERTIES ALL COLUMNS);
```

### Spatial (SDO_GEOMETRY)
```sql
-- Find EMS calls within 1km of a hospital
SELECT e.call_id, e.neighborhood, e.response_time_seconds
FROM   EMS_DISPATCH_CALLS e, HOSPITALS h
WHERE  h.name = 'UCSF Medical Center'
AND    SDO_WITHIN_DISTANCE(
         SDO_GEOMETRY(2001,8307,SDO_POINT_TYPE(e.longitude,e.latitude,NULL),NULL,NULL),
         SDO_GEOMETRY(2001,8307,SDO_POINT_TYPE(h.longitude,h.latitude,NULL),NULL,NULL),
         'distance=1 unit=KM') = 'TRUE';
```

### Oracle Text (already indexed)
```sql
SELECT doc_type, COUNT(*) FROM DOCUMENTS
WHERE  CONTAINS(doc_content, 'fire AND injury') > 0
GROUP  BY doc_type;
```

### JSON Duality View (example)
```sql
CREATE OR REPLACE JSON RELATIONAL DUALITY VIEW neighborhood_health_dv AS
  SELECT JSON {'neighborhood': n.neighborhood,
               'population': n.population_2024,
               'weekly_health': [
                 SELECT JSON {'week': p.week_start_date,
                              'respiratory': p.respiratory_er_visits,
                              'avg_aqi': p.avg_aqi_week}
                 FROM PUBLIC_HEALTH_WEEKLY p
                 WHERE p.neighborhood = n.neighborhood ]}
  FROM NEIGHBORHOODS n;
```

---

## 12. File Execution Order Reference

```
00_run_all.sql              ← start here (edits CONNECT line first)
  └─ 01_schema.sql          ← DDL: all tables + indexes
  └─ 02_data_neighborhoods.sql
  └─ 02_data_hospitals.sql
  └─ 02_data_transit_routes.sql
  └─ 02_data_transit_stops.sql
  └─ 02_data_transit_stop_connections.sql
  └─ 02_data_vessels.sql
  └─ 02_data_tourism_monthly.sql
  └─ 02_data_water_quality.sql
  └─ 02_data_sea_lion_census.sql
  └─ 02_data_wildfire_smoke_events.sql
  └─ 02_data_weather_observations.sql
  └─ 02_data_public_health_weekly.sql
  └─ 02_data_air_quality_part01.sql
  └─ 02_data_air_quality_part02.sql
  └─ 02_data_hospital_diversions.sql
  └─ 02_data_transit_ridership.sql
  └─ 02_data_port_calls.sql
  └─ 02_data_vessel_traffic_part01.sql
  └─ 02_data_vessel_traffic_part02.sql
  └─ 02_data_property_assessments_part01.sql
  └─ 02_data_property_assessments_part02.sql
  └─ 02_data_sfo_airport_operations_part01.sql
  └─ 02_data_sfo_airport_operations_part02.sql
  └─ 02_data_traffic_sensor_counts_part01.sql  (×4 parts)
  └─ 02_data_ems_dispatch_calls_part01.sql     (×3 parts)
  └─ 02_data_bikeshare_trips_part01.sql        (×4 parts)
  └─ 02_data_taxi_rideshare_trips_part01.sql   (×5 parts)
  └─ 02_data_congestion_events.sql
  └─ 02_data_pedestrian_cyclist_incidents.sql
  └─ 02_data_road_incidents.sql
  └─ 02_data_fire_incidents_part01.sql         (×2 parts)
  └─ 02_data_noise_complaints_part01.sql       (×2 parts)
  └─ 02_data_environmental_sensors_part01.sql  (×4 parts)
  └─ 03_documents_part01.sql  (×5 parts, 50 docs each)
```

---

*Generated by UrbanDive SQL Generator | Oracle 26ai Free Tier | April 2026*
