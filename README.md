# CDE-bash-etl-pipeline-assignment


```markdown

This repository contains solutions to the CoreDataEngineers Data Engineering assignments. It includes Bash scripts for a file-based ETL pipeline, cron job scheduling, and file management, as well as SQL scripts for analyzing parch and posey database from a PostgreSQL database.


## Overview
This repository contains the solution for the data engineering assignments given by CoreDataEngineers. The project focuses on building and orchestrating data pipelines using Bash scripting, SQL, and PostgreSQL. It demonstrates skills in data extraction, transformation, and loading (ETL), as well as database querying and project documentation.

## Individual Assignment

### 1. Simple ETL with Bash
A Bash script (ETL.sh) was developed to perform a three-stage ETL process:
*   **Extract:** Downloads a CSV file from a specified URL into the `raw` directory.
*   **Transform:** Renames a column (`Variable_code` to `variable_code`), selects specific columns, and saves the result to a `2023_year_finance.csv` file in the `Transformed` directory.
*   **Load:** Moves the transformed CSV into the final `Gold` directory.

### 2. ETL Automation with Cron
*   The Bash ETL script (cron_job.txt) is scheduled to run daily at midnight using a `cron` job.

### 3. File Management Script
*   A Bash script (move_csv_json.sh) is included to organize `.csv` and `.json` files by moving them into a dedicated `json_and_CSV` folder.

### 4. Competitor Analysis with PostgreSQL
*   **Data Ingestion:** A Bash script (csv_files_ingest.sh) iterates and copies CSV data from the competitor "Parch and Posey" into a PostgreSQL database named `posey`.
*   **SQL Analysis:** SQL scripts (queries.sql) are provided to answer specific business questions related to sales, including:
    *   Identifying orders with high quantities of `gloss_qty` or `poster_qty`.
    *   Finding orders where `standard_qty` is zero and other products exceed a certain threshold.
    *   Filtering company names based on specific initial letters and contact person names.
    *   Joining tables to provide a summary of regions, sales reps, and accounts.

### Architectural Diagram
*   An architectural diagram (ETL-architecture.md) illustrating the ETL pipeline can be found in the project's documentation.



## Repository Structure
├── Scripts/
│ ├── Bash_scripts/
| | ├── cron_job.txt
│ │ ├── csv_files_ingest.sh
│ │ ├── ETL.sh
│ │ └── move_csv_json.sh
│ └── SQL_scripts/
│ ├── queries.sql
│ └── schema.sql
├── ETL-architecture.md
├── Gold/
│ └── 2023_year_finance.csv
├── raw/
│ └── annual-enterprise-survey-2023-financial-year-provisional.csv
├── Transformed/
│ └── 2023_year_finance.csv
├── README.md

```