#!/bin/bash



# --- PostgreSQL Database Setup and Data Ingestion ---
#
# This script automates the process of setting up a PostgreSQL database,
# creating its schema, and populating it with data from a collection of CSV files.
# It is designed to be idempotent for the initial setup, meaning it can be run
# multiple times without causing errors, as it first drops the database if it
# already exists.
#
# Process:
# 1.  Define key variables for database connection and file paths.
# 2.  Attempt to drop and then create the database, exiting on failure.
# 3.  Execute the schema definition SQL script to create tables.
# 4.  Loop through every CSV file in the specified data directory.
# 5.  For each CSV, determine the corresponding table name from the filename.
# 6.  Use the `psql \copy` command to import the CSV data into the table.
# 7.  The `CSV HEADER` option tells PostgreSQL to treat the first row of
#     the CSV as a header and not as data to be inserted.
# 8.  Include error handling for each step to ensure the script
#     stops if a command fails.
#
# Prerequisites:
# -   PostgreSQL must be installed and accessible.
# -   The `DB_USER` environment variable must be set with the username.
# -   A `schema.sql` file must exist and be correctly defined.
# -   CSV files must be located in the specified `CSV_DIR`.
# -   CSV filenames must match the desired table names (e.g., `products.csv` -> `products` table).
#
# ----------------------------------------------------

# --- Configuration Variables ---
DB_NAME="posey"
DB_USER="$DB_USER"
DB_HOST="localhost"
DB_PORT="5432"
SQL_SCHEMA_FILE="$HOME/CDE/Assignment/Scripts/SQL_scripts/schema.sql"
CSV_DIR="$HOME/CDE/Assignment/data"

# --- Database Setup ---
# Check if the DB_USER environment variable is set
# (The `-z` test operator checks if the length of the string stored in the variable `$DB_USER` is zero. This evaluates to true if the variable is either unset or explicitly set to an empty string.)
if [ -z "$DB_USER" ]; then
  echo "Error: DB_USER environment variable is not set. Exiting."
  exit 1  # Exit with a non-zero status code to indicate an error
fi
echo "Creating database: $DB_NAME"
# Drop the database if it already exists, using the --if-exists flag to prevent errors
dropdb -U "$DB_USER" --if-exists "$DB_NAME"
# Create a new, clean database. Exit if the command fails.
createdb -U "$DB_USER" "$DB_NAME" || { echo "Failed to create database. Exiting..."; exit 1; }

# --- Schema Creation ---
# Check if the SQL schema file exists (The '-f' tests if the path is a regular file. '!' The logical negation operator, which inverts the result of the `-f` test)
if [ ! -f "$SQL_SCHEMA_FILE" ]; then
  echo "Error: Schema file '$SQL_SCHEMA_FILE' not found. Exiting..."
  exit 1  # Exit with a non-zero status code to indicate an error
fi
echo "Creating schema..."
# Execute the SQL schema file using psql on the newly created database. Exit if it fails.
psql -U "$DB_USER" -d "$DB_NAME" -f "$SQL_SCHEMA_FILE" || { echo "Schema creation failed. Exiting..."; exit 1; }

# --- Data Ingestion ---
echo "Loading CSV files..."
# Loop through all files ending with .csv in the specified directory
for file in "$CSV_DIR"/*.csv; do
# Extract the base filename (e.g., 'table_name') to use as the table name
  table=$(basename "$file" .csv)
  echo "Importing $file into $table..."
  # Use psql with the `\copy` command to import data.
  # The `CSV HEADER` option handles the header row in the CSV file.
  # Exit the script if the import of any file fails.
  psql -U "$DB_USER" -d "$DB_NAME" -c "\copy $table FROM '$file' CSV HEADER" || { echo "Failed to import $file. Exiting..."; exit 1; }
done

echo "Loaded successfully!"
