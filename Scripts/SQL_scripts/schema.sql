--- schema.sql ---


/*
 * Schema for CSV Data Ingest
 *
 * This SQL file defines the database tables and their structure for the data
 * ingested via the `csv_ingest_script.sh` bash script.
 * The script reads from a collection of raw CSV files, creates these tables
 * if they don't exist, and copies the data into them.
 *
 * The schema is designed to match the format of the incoming CSV files.
 *
 */

--- accounts.csv ---
--- Table: accounts ---
--- Information about the accounts ---

CREATE TABLE accounts (
  id INT PRIMARY KEY,
  name TEXT,
  website TEXT,
  lat NUMERIC,
  long NUMERIC,
  primary_poc TEXT,
  sales_rep_id INT
);



--- orders.csv ---
--- Table: orders ---
--- Information about the orders ---

CREATE TABLE orders (
  id INT PRIMARY KEY,
  account_id INT,
  occured_at TIMESTAMP,
  standard_qty INT,
  gloss_qty INT,
  poster_qty INT,
  total INT,
  standard_amt_used NUMERIC,
  gloss_amt_used NUMERIC,
  poster_amt_used NUMERIC,
  total_amt_used NUMERIC
);



--- region.csv ---
--- Table: region ---
--- Information about the regions ---

CREATE TABLE region (
  id INT PRIMARY KEY,
  name TEXT
);



--- sales_reps.csv ---
--- Table: sales_reps ---
--- Information about the sales reps ---

CREATE TABLE sales_reps (
  id INT PRIMARY KEY,
  name TEXT,
  region_id INT
);



--- web_events.csv ---
--- Table: web_events ---
--- Information about the web events ---

CREATE TABLE web_events (
  id INT PRIMARY KEY,
  account_id INT,
  occured_at TIMESTAMP,
  channel TEXT
);