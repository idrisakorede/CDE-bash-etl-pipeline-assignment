#!/bin/bash


# --- Move and Organize File Types ---
#
# This script moves specific file types (`.csv` and `.json`) from a source
# directory to a new, dedicated destination directory. It handles cases where
# no files of a certain type are found by redirecting errors and providing
# informative feedback.
#
# Process:
# 1.  Define the source and destination paths using variables.
# 2.  Create the destination directory, including any parent directories,
#     using `mkdir -p`.
# 3.  Perform the move operation for CSV files.
# 4.  Check the exit status of the `mv` command (`$?`) to confirm success.
# 5.  Repeat the process for JSON files.
#
# Error Handling:
# - `2>/dev/null`: This part of the `mv` command redirects standard error
#   (channel 2) to `/dev/null`, suppressing the "No such file or
#   directory" error that `mv` would generate if no files matching the
#   wildcard pattern exist.
# - The `if [ $? -eq 0 ]` check then verifies if the `mv` command ran
#   successfully, indicating that at least one file was moved.
#
# ----------------------------------------------------

# Define the paths for the source data folder and the destination
SOURCE="$HOME/CDE/assignment/data"
DESTINATION="$HOME/CDE/assignment/json_and_csv"

echo "Creating file destination..."
# Create the destination directory recursively (`-p`) if it doesn't already exist
mkdir -p "$DESTINATION"
echo "File destination created: $DESTINATION"

# --- Move all CSV files ---
echo "Moving all csv files from $SOURCE to $DESTINATION"
mv "$SOURCE"/*.csv "$DESTINATION"/ 2>/dev/null
if [ $? -eq 0 ]; then
  echo "CSV files moved successfully!"
  echo "File details:"
  # List the moved CSV files for confirmation
  ls -lah "$DESTINATION"/*.csv
else
  echo "Error: No CSV file found at $SOURCE"
fi

# --- Move all JSON files ---
echo "Moving all json files from $SOURCE to $DESTINATION"
mv "$SOURCE"/*.json "$DESTINATION"/ 2>/dev/null
if [ $? -eq 0 ]; then
  echo "JSON files moved successfully!"
  echo "File details:"
  # List the moved JSON files for confirmation
  ls -lah "$DESTINATION"/*.json
else
  echo "Error: No JSON file found at $SOURCE"
fi
