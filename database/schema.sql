-- SmartStore OLTP schema
-- Purpose: normalized transactional tables for an e-commerce business.
CREATE DATABASE IF NOT EXISTS smartstore;
USE smartstore:
  
CREATE TABLE customers (
  customer_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  email VARCHAR(255) NOT NULL UNIQUE,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  phone VARCHAR(30),
  city VARCHAR(120),
  state VARCHAR(120),
  country VARCHAR(120) DEFAULT 'USA',
  customer_status ENUM('ACTIVE','INACTIVE','CHURN_RISK') DEFAULT 'ACTIVE',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE categories (
  category_id INT PRIMARY KEY AUTO_INCREMENT,
  category_name VARCHAR(120) NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE suppliers (
  supplier_id INT PRIMARY KEY AUTO_INCREMENT,
  supplier_name VARCHAR(255) NOT NULL,
  contact_email VARCHAR(255),
  country VARCHAR(120),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE products (
  product_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  sku VARCHAR(64) NOT NULL UNIQUE,
  product_name VARCHAR(255) NOT NULL,
  category_id INT NOT NULL,
  supplier_id INT,
  unit_price DECIMAL(12,2) NOT NULL,
  cost_price DECIMAL(12,2) NOT NULL,
  is_active TINYINT(1) DEFAULT 1,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_products_category FOREIGN KEY (category_id) REFERENCES categories(category_id),
  CONSTRAINT fk_products_supplier FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id),
  CONSTRAINT chk_product_prices CHECK (unit_price >= 0 AND cost_price >= 0)
);

CREATE TABLE inventory (
  inventory_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  product_id BIGINT NOT NULL,
  warehouse_code VARCHAR(30) NOT NULL,
  quantity_on_hand INT NOT NULL DEFAULT 0,
  reorder_level INT NOT NULL DEFAULT 25,
  last_restocked_at TIMESTAMP NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uq_inventory_product_warehouse (product_id, warehouse_code),
  CONSTRAINT fk_inventory_product FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
  CONSTRAINT chk_inventory_quantity CHECK (quantity_on_hand >= 0)
);

CREATE TABLE employees (
  employee_id INT PRIMARY KEY AUTO_INCREMENT,
  employee_name VARCHAR(255) NOT NULL,
  department VARCHAR(100) NOT NULL,
  role_title VARCHAR(100) NOT NULL,
  hired_date DATE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE orders (
  order_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  customer_id BIGINT NOT NULL,
  order_date DATETIME NOT NULL,
  order_status ENUM('PLACED','PAID','SHIPPED','DELIVERED','CANCELLED','REFUNDED') NOT NULL DEFAULT 'PLACED',
  sales_channel ENUM('WEB','MOBILE','MARKETPLACE','SUPPORT') NOT NULL DEFAULT 'WEB',
  employee_id INT,
  subtotal DECIMAL(14,2) NOT NULL,
  shipping_amount DECIMAL(14,2) NOT NULL DEFAULT 0,
  tax_amount DECIMAL(14,2) NOT NULL DEFAULT 0,
  discount_amount DECIMAL(14,2) NOT NULL DEFAULT 0,
  total_amount DECIMAL(14,2) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  CONSTRAINT fk_orders_employee FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
  CONSTRAINT chk_order_amounts CHECK (subtotal >= 0 AND total_amount >= 0)
);

CREATE TABLE order_items (
  order_item_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  order_id BIGINT NOT NULL,
  product_id BIGINT NOT NULL,
  quantity INT NOT NULL,
  unit_price DECIMAL(12,2) NOT NULL,
  line_total DECIMAL(14,2) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_items_order FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
  CONSTRAINT fk_items_product FOREIGN KEY (product_id) REFERENCES products(product_id),
  CONSTRAINT chk_order_item_quantity CHECK (quantity > 0)
);

CREATE TABLE payments (
  payment_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  order_id BIGINT NOT NULL,
  payment_date DATETIME NOT NULL,
  payment_method ENUM('CARD','PAYPAL','APPLE_PAY','BANK_TRANSFER') NOT NULL,
  payment_status ENUM('PENDING','SUCCESS','FAILED','REFUNDED') NOT NULL,
  amount DECIMAL(14,2) NOT NULL,
  transaction_reference VARCHAR(100) UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_payments_order FOREIGN KEY (order_id) REFERENCES orders(order_id),
  CONSTRAINT chk_payment_amount CHECK (amount >= 0)
);

CREATE TABLE audit_log (
  audit_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  entity_name VARCHAR(60) NOT NULL,
  entity_id BIGINT NOT NULL,
  action_name VARCHAR(60) NOT NULL,
  action_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  action_by VARCHAR(100) DEFAULT 'system',
  payload JSON
);

-- Seed reference data for local demos and integration tests.
INSERT INTO categories(category_name) VALUES ('Electronics'),('Home'),('Beauty'),('Sports')
ON DUPLICATE KEY UPDATE category_name = VALUES(category_name);

INSERT INTO suppliers(supplier_name, contact_email, country) VALUES
('Nexa Supply','ops@nexa.example','USA'),
('Global Goods','contact@global.example','Canada');

INSERT INTO employees(employee_name, department, role_title, hired_date) VALUES
('Alicia Brown','Sales','Sales Manager','2021-03-01'),
('Kian Patel','Operations','Inventory Analyst','2022-09-14');

-- Query performance indexes are kept close to the tables they support.
CREATE INDEX idx_orders_date_status ON orders(order_date, order_status);
CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_order_items_product ON order_items(product_id);
CREATE INDEX idx_payments_status_date ON payments(payment_status, payment_date);
CREATE INDEX idx_inventory_reorder ON inventory(quantity_on_hand, reorder_level);
CREATE INDEX idx_products_category ON products(category_id);
