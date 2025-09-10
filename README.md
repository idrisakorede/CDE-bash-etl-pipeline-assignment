# CDE-bash-etl-pipeline-assignment



```markdown
# CoreDataEngineers Data Engineering Project

## Table of Contents
- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Assignment Solutions](#assignment-solutions)
  - [1. ETL Pipeline with Bash](#1-etl-pipeline-with-bash)
  - [2. Cron Job Scheduling](#2-cron-job-scheduling)
  - [3. File Management Script](#3-file-management-script)
  - [4. Competitor Analysis with PostgreSQL](#4-competitor-analysis-with-postgresql)
- [Installation & Setup](#installation--setup)
- [Usage Instructions](#usage-instructions)
- [Architecture](#architecture)
- [Contributing](#contributing)
- [License](#license)

## Overview

This repository contains comprehensive solutions to the CoreDataEngineers Data Engineering assignments. The project demonstrates proficiency in building robust data pipelines using Bash scripting, PostgreSQL database management, and automated task scheduling. It showcases end-to-end data engineering skills including data extraction, transformation, loading (ETL), database querying, and project documentation best practices.

**Key Technologies Used:**
- Bash Scripting
- PostgreSQL
- Cron Jobs
- SQL
- CSV/JSON Data Processing
- Linux Command Line Tools

## Prerequisites

Before running the scripts in this repository, ensure you have the following installed:

- **Linux/Unix Operating System** (Ubuntu, CentOS, macOS, etc.)
- **Bash Shell** (version 4.0+)
- **PostgreSQL** (version 12+)
- **curl** or **wget** for downloading files
- **awk**, **sed**, and **cut** utilities
- **cron** service for job scheduling
- Basic command line tools: `mkdir`, `cp`, `mv`, `find`

## Project Structure

```
CoreDataEngineers-Project/
├── Scripts/
│   ├── Bash_scripts/
│   │   ├── ETL.sh                    # Main ETL pipeline script
│   │   ├── move_csv_json.sh          # File organization script
│   │   ├── csv_files_ingest.sh       # PostgreSQL data ingestion script
│   │   └── cron_job.txt              # Cron job configuration
│   └── SQL_scripts/
│       ├── queries.sql               # Business analysis queries
│       └── schema.sql                # Database schema definitions
├── Data_Directories/
│   ├── raw/                          # Raw downloaded files
│   ├── Transformed/                  # Processed data files
│   ├── Gold/                         # Final production-ready data
│   └── json_and_CSV/                 # Organized file storage
├── Documentation/
│   ├── ETL-architecture.md           # System architecture documentation
│   └── setup-guide.md               # Detailed setup instructions
├── README.md                        # This file
└── .gitignore                       # Git ignore rules
```

## Assignment Solutions

### 1. ETL Pipeline with Bash

**File:** `Scripts/Bash_scripts/ETL.sh`

This script implements a complete ETL pipeline that:

#### Extract Phase
- Downloads CSV data from a configurable URL using environment variables
- Validates successful download and file integrity
- Stores raw data in the `raw/` directory
- Provides comprehensive logging and error handling

#### Transform Phase
- Renames the `Variable_code` column to `variable_code` for consistency
- Filters and selects specific columns: `year`, `Value`, `Units`, `variable_code`
- Validates data transformation accuracy
- Saves processed data as `2023_year_finance.csv` in the `Transformed/` directory

#### Load Phase
- Moves the final transformed dataset to the `Gold/` directory
- Confirms successful data placement
- Maintains data lineage and audit trail

**Key Features:**
- Environment variable configuration for flexibility
- Comprehensive error handling and validation
- Detailed logging for each pipeline stage
- Automatic directory creation if they don't exist
- Data integrity checks throughout the process

### 2. Cron Job Scheduling

**File:** `Scripts/Bash_scripts/cron_job.txt`

Automated scheduling configuration that:
- Executes the ETL pipeline daily at midnight (00:00)
- Includes proper logging and error capture
- Handles system resources efficiently
- Provides notification mechanisms for job failures

**Cron Expression:** `0 0 * * *`

**Installation Command:**
```bash
crontab Scripts/Bash_scripts/cron_job.txt
```

### 3. File Management Script

**File:** `Scripts/Bash_scripts/move_csv_json.sh`

A versatile file organization utility that:
- Recursively searches for CSV and JSON files
- Moves files to a centralized `json_and_CSV/` directory
- Maintains original file structure when needed
- Prevents file overwrites with intelligent naming
- Supports batch processing of multiple file types
- Provides detailed operation reports

**Supported Operations:**
- Single file moves
- Bulk file operations
- Directory traversal
- File type validation
- Duplicate handling

### 4. Competitor Analysis with PostgreSQL

#### Data Ingestion Script
**File:** `Scripts/Bash_scripts/csv_files_ingest.sh`

Automates the process of loading Parch and Posey competitor data:
- Creates PostgreSQL database `posey` if it doesn't exist
- Generates appropriate table schemas based on CSV headers
- Handles data type inference and conversion
- Implements bulk data loading for performance
- Provides data validation and quality checks

#### SQL Analysis Queries
**File:** `Scripts/SQL_scripts/queries.sql`

Contains comprehensive business intelligence queries addressing:

**Query 1: High-Volume Orders Analysis**
```sql
-- Find orders with gloss_qty or poster_qty > 4000
-- Returns only order IDs for focused analysis
```

**Query 2: Product Mix Analysis**
```sql
-- Identify orders with zero standard_qty but high specialty product quantities
-- Useful for understanding customer preferences
```

**Query 3: Customer Segmentation**
```sql
-- Filter companies starting with 'C' or 'W'
-- Primary contacts containing 'ana' but not 'eana'
-- Enables targeted marketing campaigns
```

**Query 4: Sales Territory Mapping**
```sql
-- Comprehensive view of regions, sales reps, and accounts
-- Alphabetically sorted for easy reference
-- Supports territory management and planning
```

## Installation & Setup

### 1. Clone the Repository
```bash
git clone https://github.com/yourusername/CoreDataEngineers-Project.git
cd CoreDataEngineers-Project
```

### 2. Set Up Environment Variables
```bash
export DATA_URL="https://your-data-source-url.com/file.csv"
export DB_NAME="posey"
export DB_USER="your_username"
export DB_PASSWORD="your_password"
```

### 3. Make Scripts Executable
```bash
chmod +x Scripts/Bash_scripts/*.sh
```

### 4. Initialize PostgreSQL Database
```bash
createdb posey
psql -d posey -f Scripts/SQL_scripts/schema.sql
```

### 5. Create Required Directories
```bash
mkdir -p {raw,Transformed,Gold,json_and_CSV}
```

## Usage Instructions

### Running the ETL Pipeline
```bash
# Single execution
./Scripts/Bash_scripts/ETL.sh

# With custom environment variables
DATA_URL="your_url_here" ./Scripts/Bash_scripts/ETL.sh
```

### Setting Up Automated Scheduling
```bash
# Add to crontab
crontab Scripts/Bash_scripts/cron_job.txt

# Verify installation
crontab -l
```

### File Organization
```bash
# Move CSV and JSON files
./Scripts/Bash_scripts/move_csv_json.sh /path/to/source/directory

# Process current directory
./Scripts/Bash_scripts/move_csv_json.sh .
```

### Database Operations
```bash
# Load data into PostgreSQL
./Scripts/Bash_scripts/csv_files_ingest.sh

# Run analysis queries
psql -d posey -f Scripts/SQL_scripts/queries.sql
```

## Architecture

The project follows a layered architecture approach:

1. **Data Ingestion Layer**: Raw data extraction from external sources
2. **Processing Layer**: Data transformation and validation
3. **Storage Layer**: Structured data storage in multiple formats
4. **Analysis Layer**: SQL-based business intelligence queries
5. **Automation Layer**: Cron-based scheduling and monitoring

For detailed architecture diagrams and data flow documentation, see `Documentation/ETL-architecture.md`.

## Key Features & Benefits

- **Scalability**: Modular design allows easy extension and modification
- **Reliability**: Comprehensive error handling and data validation
- **Maintainability**: Well-documented code with clear separation of concerns
- **Automation**: Scheduled execution reduces manual intervention
- **Flexibility**: Environment variable configuration for different deployment scenarios
- **Monitoring**: Built-in logging and status reporting

## Troubleshooting

### Common Issues

1. **Permission Denied**: Ensure scripts have execute permissions
2. **Database Connection**: Verify PostgreSQL service is running and credentials are correct
3. **Missing Dependencies**: Install required utilities using your package manager
4. **Cron Job Not Running**: Check cron service status and log files

### Debug Mode
Run scripts with debug output:
```bash
bash -x Scripts/Bash_scripts/ETL.sh
```

## Performance Considerations

- **Memory Usage**: Scripts are optimized for large file processing
- **Network Efficiency**: Implements retry mechanisms for downloads
- **Database Performance**: Uses bulk insert operations for faster loading
- **Disk Space**: Includes cleanup routines to manage storage

## Security Best Practices

- Environment variables for sensitive configuration
- Input validation to prevent injection attacks
- Proper file permissions and access controls
- Secure database connection practices

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Contact

**Project Maintainer**: [Idris Akorede Ibrahim]
**Email**: [idrisakoredeibrahim@gmail.com]

---

**CoreDataEngineers** - Building robust data infrastructure with modern engineering practices.
```