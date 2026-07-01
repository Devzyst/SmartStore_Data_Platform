# Setup Guide

## 1. Configure Environment

```bash
cp .env.example .env
```

## 2. Start the Platform

```bash
docker-compose up --build
```

## 3. Generate Demo Data

```bash
python data_generation/generate_customers.py
python data_generation/generate_products.py
python data_generation/generate_orders.py
python data_generation/generate_payments.py
```

## 4. Run ETL

```bash
python etl/pipeline.py generated_data/orders.csv
```

## 5. Run SQL Analytics

Connect to MySQL and run files from `analytics/` or query the reporting views in `database/views.sql`.
