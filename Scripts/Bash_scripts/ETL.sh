#!/bin/bash

# Define the variables (file URL, file directory, and file name)
FILE_URL="https://www.stats.govt.nz/assets/Uploads/Annual-enterprise-survey/Annual-enterprise-survey-2023-financial-year-provisional/Download-data/annual-enterprise-survey-2023-financial-year-provisional.csv"
FILE_DIR="$HOME/CDE/Assignment/raw"
FILE_NAME=$(basename "$FILE_URL")       # Extract the base filename from the transformed file's full path
FULL_PATH="$FILE_DIR/$FILE_NAME"

# Create the directory if it doesn't existls
mkdir -p "$FILE_DIR"
echo "$FILE_DIR has been created"

# Download the file using wget
echo "Downloading $FILE_NAME to $FILE_DIR..."
wget -q "$FILE_URL" -O "$FULL_PATH"                 # Download the file from the FILE_URL silently (-q) and save it (-O) to the FULL_PATH

# Confirm the file has been downloaded and saved
# The '$?' variable holds the exit status of the last command. 0 means success.
if [ $? -eq 0 ]; then
  echo "Download successful!!! $FILE_NAME has been downloaded and saved as $FULL_PATH"
else
  echo "Download failed!"
  exit 1
fi

# Renaming the file to make it shorter
NEW_FILE_NAME="survey_data_2023.csv"
NEW_FULL_PATH="$FILE_DIR/$NEW_FILE_NAME"

mv "$FULL_PATH" "$NEW_FULL_PATH"       # Renaming the file NEW_FULL_PATH to make it shorter
echo "$FILE_NAME has been renamed to $NEW_FILE_NAME"

# Update variables to use the new file name
FILE_NAME="$NEW_FILE_NAME"
FULL_PATH="$NEW_FULL_PATH"

# Check if the file exists and is a regular file (-f returns true if the file exists and it is a regular file)
if [ -f "$FULL_PATH" ]; then
  echo "File operation successful! File saved as $FULL_PATH"
  echo "File details:"
  ls -lh "$FULL_PATH"     # List file details in a human-readable, long format
else
  echo "File not found at $FULL_PATH"
  exit 1     # Exit with error status if file not found
fi

# Extracts and displays original column headers from the first line of the file
echo "Showing the original columns header"
columns=$(head -n 1 "$FULL_PATH")
echo "Original Columns: $columns"

# Checks if the column "Variable_code" exists using grep.
# The "-q" flag makes grep silent, returning a status code instead of printing
if echo "$columns" | grep -q "Variable_code"; then
  echo "Found 'Variable_code' column, renaming it to 'variable_code' ..."

  # Uses sed to perform an in-place (-i) replacement on the first line (1s).
  # It finds the old column name and replaces it with the new one globally (/g)
  sed -i '1s/Variable_code/variable_code/g' "$FULL_PATH"

  # Verifies the change by re-reading the first line of the file
  new_columns=$(head -n 1 "$FULL_PATH")
  echo "Updated columns: $new_columns"
  echo "Column renamed successfully!"
else
  echo "No 'Variable_code' column found - no changes needed"
fi

# --- Data Transformation: Extract Columns with awk ---
#
# This section prepares for and executes a data transformation step.
# It uses the `awk` command to parse an existing CSV file, identify specific
# columns by their headers, and output only those columns to a new, "transformed" CSV file.
#
# Process:
# 1. Define variables for the new file's name and directory.
# 2. Create the destination directory if it does not exist.
# 3. Use `awk` to:
#    - Set the field and output separators to a comma.
#    - In the header row (NR==1), loop through all fields to find the column numbers
#      corresponding to "year", "Value", "Units", and "variable_code".
#    - Print a standardized header for the transformed file.
#    - For all subsequent rows, print only the data from the identified columns.
# 4. Check that the new file was created successfully.
#
# ----------------------------------------------------

# Define variables for the transformed file's location
TRANS_FILE_NAME="2023_year_finance.csv"
TRANS_FILE_DIR="$HOME/CDE/Assignment/Transformed"
TRANS_FULL_PATH="$TRANS_FILE_DIR/$TRANS_FILE_NAME"

# Create the destination directory if it doesn't exist.
mkdir -p "$TRANS_FILE_DIR"
echo "$TRANS_FILE_DIR has been created"

echo "Extracting [year, Value, Units, variable_code] columns..."

# Use awk to process the CSV file
awk '
  BEGIN { FS=OFS="," }
  NR==1{
    for (i=1; i<=NF; i++) {
      if($i == "year") year_col = i
      if($i == "Value") value_col = i
      if($i == "Units") units_col = i
      if($i == "variable_code") varcode_col = i
    }
    # Print the columns
    print "year, Value, Units, variable_code"
    next
  }
  {
    print $year_col, $value_col, $units_col, $varcode_col
  }
' "$FULL_PATH" > "$TRANS_FULL_PATH"

# --- Verification ---
# Confirm the transformed file was successfully created in the target directory (-f returns true if the file exists and it is a regular file)
if [ -f "$TRANS_FULL_PATH" ]; then
  echo "Success!!! File was loaded into $TRANS_FILE_DIR"
  echo "File details:"
  ls -lh "$TRANS_FULL_PATH"   # Display file details for confirmation
else
  echo "Loading of the file failed, file not found at $TRANS_FULL_PATH"
  exit 1 # Exit with an error code if the file is missing
fi


# --- Data Load: Move Transformed File to Gold Folder ---
#
# This section of the script handles the final "load" stage of the data pipeline.
# It copies the CSV file containing the cleaned and transformed data into a
# designated "Gold" directory.
#
# Process:
# 1.  Define the path for the Gold data layer.
# 2.  Use 'basename' to safely extract just the filename from the transformed
#     file's full path.
# 3.  Create the Gold directory, along with any parent directories, using the
#     `-p` option.
# 4.  Copy the transformed file to the Gold directory using the `cp` command.
# 5.  Perform a final verification check to ensure the file exists in its
#     new location before proceeding, providing a clear success or failure message.
#
# ----------------------------------------------------

# Define the destination directory for the "Gold" data layer
LOAD_FILE_DIR="$HOME/CDE/Assignment/Gold"

# Extract the base filename from the transformed file's full path
# Example: from '/path/to/Transformed/2023_year_finance.csv' to '2023_year_finance.csv
TRANSFORMED_FILE=$(basename "$TRANS_FULL_PATH")

# Construct the full path for the file in the Gold directory
FULL_LOAD_PATH="$LOAD_FILE_DIR/$TRANSFORMED_FILE"

# Create the destination directory recursively (`-p`) if it doesn't already exist
mkdir -p "$LOAD_FILE_DIR"    # Create directory if it doesn't exist
echo "$LOAD_FILE_DIR has been created"

echo "Loading $TRANSFORMED_FILE into $LOAD_FILE_DIR"
cp "$TRANS_FULL_PATH" "$LOAD_FILE_DIR"   # copy the file from the Transformed folder to the Gold folder
echo "$FULL_LOAD_PATH loaded successfully"

# Confirm the loading is successful (-f returns true if the file exists and it is a regular file)
if [ -f "$FULL_LOAD_PATH" ]; then
  echo "Load successful! File loaded as $FULL_LOAD_PATH"
  echo "File details:"
  ls -lh "$FULL_LOAD_PATH"  # Display file details for confirmation
else
  echo "File not found at $FULL_LOAD_PATH"
  exit 1  # Exit with an error code if the file is missing
fi





echo "Script completed successfully!"
