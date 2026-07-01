# Architecture

SmartStore is intentionally organized as a compact portfolio data platform. The goal is to show enterprise data engineering concepts without burying the reader in too many folders.

## Layers

1. **Database layer** (`database/`)
   - OLTP schema for transactional e-commerce data.
   - Warehouse schema for analytics and Power BI.
   - Stored procedures, triggers, and reporting views in single-purpose SQL files.

2. **ETL layer** (`etl/`)
   - `extract.py`: reads source datasets.
   - `transform.py`: cleans and validates records.
   - `load.py`: writes processed datasets into MySQL.
   - `pipeline.py`: orchestrates the end-to-end job.

3. **Data generation layer** (`data_generation/`)
   - Creates realistic synthetic datasets with Faker, Pandas, and NumPy.
   - Keeps the project demo-friendly without requiring private company data.

4. **Analytics layer** (`analytics/`)
   - Stores reusable SQL examples for sales, customer, inventory, and revenue analysis.

5. **BI layer** (`dashboards/powerbi/`)
   - Holds dashboard files and Power BI notes.
