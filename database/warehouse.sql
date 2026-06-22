-- SmartStore warehouse schema
-- Purpose: simple star schema optimized for analytics and Power BI datasets.
USE smartstore;

CREATE TABLE IF NOT EXISTS dim_date (
  date_key INT PRIMARY KEY,
  full_date DATE NOT NULL UNIQUE,
  day_of_week VARCHAR(10),
  month_num TINYINT,
  month_name VARCHAR(10),
  quarter_num TINYINT,
  year_num INT
);

CREATE TABLE IF NOT EXISTS dim_customer (
  customer_key BIGINT PRIMARY KEY,
  customer_id BIGINT NOT NULL,
  email VARCHAR(255),
  city VARCHAR(120),
  state VARCHAR(120),
  country VARCHAR(120),
  customer_status VARCHAR(30),
  created_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS dim_category (
  category_key INT PRIMARY KEY,
  category_id INT NOT NULL,
  category_name VARCHAR(120) NOT NULL
);

CREATE TABLE IF NOT EXISTS dim_product (
  product_key BIGINT PRIMARY KEY,
  product_id BIGINT NOT NULL,
  sku VARCHAR(64),
  product_name VARCHAR(255),
  category_key INT,
  unit_price DECIMAL(12,2),
  is_active TINYINT(1)
);

CREATE TABLE IF NOT EXISTS fact_sales (
  sales_key BIGINT PRIMARY KEY AUTO_INCREMENT,
  date_key INT NOT NULL,
  customer_key BIGINT NOT NULL,
  product_key BIGINT NOT NULL,
  order_id BIGINT NOT NULL,
  quantity INT NOT NULL,
  gross_amount DECIMAL(14,2) NOT NULL,
  discount_amount DECIMAL(14,2) NOT NULL DEFAULT 0,
  net_amount DECIMAL(14,2) NOT NULL,
  loaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY(date_key) REFERENCES dim_date(date_key),
  FOREIGN KEY(customer_key) REFERENCES dim_customer(customer_key),
  FOREIGN KEY(product_key) REFERENCES dim_product(product_key),
  INDEX idx_fact_sales_date (date_key),
  INDEX idx_fact_sales_customer (customer_key),
  INDEX idx_fact_sales_product (product_key)
);
