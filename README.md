# 🛒 SmartStore Data Platform

![Python](https://img.shields.io/badge/Python-3.12-blue)
![MySQL](https://img.shields.io/badge/MySQL-8.4-orange)
![Docker](https://img.shields.io/badge/Docker-Ready-2496ED)
![CI](https://img.shields.io/badge/GitHub_Actions-CI-green)

SmartStore Data Platform is a clean, recruiter-friendly data engineering portfolio project for a fictional e-commerce company. It demonstrates SQL modeling, MySQL analytics, Python ETL, synthetic data generation, Docker, CI/CD, and Power BI readiness without an overly complex enterprise folder structure.

## Table of Contents

- [Why This Project Exists](#why-this-project-exists)
- [Architecture at a Glance](#architecture-at-a-glance)
- [Repository Structure](#repository-structure)
- [Tech Stack](#tech-stack)
- [Database Design](#database-design)
- [ETL Pipeline](#etl-pipeline)
- [Analytics and BI](#analytics-and-bi)
- [Quick Start](#quick-start)
- [Development Workflow](#development-workflow)
- [Documentation](#documentation)
- [Future Improvements](#future-improvements)

## Why This Project Exists

The goal is to show practical data engineering skills in a format that is easy for recruiters, hiring managers, and technical reviewers to understand. The project keeps enterprise concepts but reduces unnecessary nesting so a new contributor can quickly find the important files.

## Architecture at a Glance

```text
Synthetic data ──▶ Python ETL ──▶ MySQL OLTP schema ──▶ Warehouse tables/views ──▶ SQL analytics + Power BI
```

Core capabilities:

- Normalized transactional database for customers, products, orders, payments, inventory, suppliers, and employees.
- Star-schema warehouse tables for BI-friendly reporting.
- Python ETL modules for extract, transform, and load stages.
- SQL procedures, triggers, views, and analytics query examples.
- Docker Compose environment with MySQL and an ETL container.
- GitHub Actions CI for dependency installation, Python compilation, tests, and SQL file validation.

## Repository Structure

Each folder is intentionally flat and has one clear purpose:

```text
smartstore-data-platform/
├── database/              # MySQL schema, warehouse, procedures, triggers, and reporting views
├── etl/                   # Python extract, transform, load, and pipeline orchestration modules
├── data_generation/       # Faker/NumPy/Pandas scripts for realistic synthetic datasets
├── analytics/             # Reusable SQL analysis files by business domain
├── dashboards/powerbi/    # Power BI workspace notes and future .pbix/dashboard exports
├── docs/                  # Architecture, database design, and setup documentation
├── tests/                 # Lightweight project structure and regression tests
├── .github/workflows/     # CI workflow for GitHub Actions
├── Dockerfile             # Python ETL container image
├── docker-compose.yml     # MySQL + ETL local development environment
├── requirements.txt       # Python dependencies
├── .env.example           # Environment variable template
├── CONTRIBUTING.md        # Beginner-friendly contribution and Git workflow guide
└── README.md              # Project overview and onboarding entry point
```

## Tech Stack

| Area | Tools |
| --- | --- |
| Database | MySQL 8.4 |
| Programming | Python 3.12+ |
| Libraries | Pandas, NumPy, Faker, SQLAlchemy, python-dotenv, PyMySQL |
| DevOps | Docker, Docker Compose, GitHub Actions |
| BI | Power BI-ready SQL views and dashboard workspace |

## Database Design

The `database/` folder contains five consolidated SQL files:

- `schema.sql` defines the normalized OLTP model, constraints, indexes, and demo seed data.
- `warehouse.sql` defines the `fact_sales` table and `dim_*` dimension tables.
- `procedures.sql` defines reusable database operations such as `create_order`, `update_inventory`, and revenue reporting.
- `triggers.sql` automates audit logging and inventory reduction.
- `views.sql` exposes dashboard-ready datasets such as `vw_monthly_sales`, `vw_customer_ltv`, `vw_product_performance`, and `vw_inventory_status`.

## ETL Pipeline

The ETL code is split into four beginner/intermediate-friendly modules:

1. `etl/extract.py` reads source datasets.
2. `etl/transform.py` cleans, normalizes, deduplicates, and validates records.
3. `etl/load.py` connects to MySQL and writes DataFrames.
4. `etl/pipeline.py` orchestrates the full order pipeline.

## Analytics and BI

The `analytics/` folder includes focused SQL files for:

- Sales performance and rolling revenue trends.
- Customer segmentation and churn-risk indicators.
- Inventory reorder monitoring and stock valuation.
- Revenue growth and sales-channel KPIs.

Power BI users can connect to MySQL and start from the reporting views documented in `dashboards/powerbi/README.md`.

## Quick Start

### 1. Configure environment

```bash
cp .env.example .env
```

### 2. Start MySQL and the ETL container

```bash
docker-compose up --build
```

### 3. Generate demo datasets

```bash
python data_generation/generate_customers.py
python data_generation/generate_products.py
python data_generation/generate_orders.py
python data_generation/generate_payments.py
```

### 4. Run the ETL pipeline

```bash
python etl/pipeline.py generated_data/orders.csv
```

### 5. Run example analytics

```sql
CALL calculate_monthly_revenue(2026);
SELECT * FROM vw_monthly_sales;
SELECT * FROM vw_inventory_status WHERE inventory_status = 'REORDER';
```

## Development Workflow

This project uses a simple Git workflow for portfolio-friendly collaboration:

1. Create a branch for one focused change.
2. Make the change and keep files easy to review.
3. Run compile/tests locally.
4. Commit with a clear message.
5. Open a pull request with summary and testing notes.

See `CONTRIBUTING.md` for the full beginner-friendly guide.

## Documentation

- `docs/architecture.md`: simple platform architecture.
- `docs/database_design.md`: OLTP and warehouse design notes.
- `docs/setup_guide.md`: local setup and run commands.

## Future Improvements

- Add incremental warehouse loading.
- Add data quality checks for generated and loaded datasets.
- Add Power BI screenshots and example `.pbix` files.
- Add richer synthetic order-item generation.
- Add query benchmark notes using `EXPLAIN ANALYZE`.

## Author

Pedro Project

## License

MIT recommended for portfolio use.
