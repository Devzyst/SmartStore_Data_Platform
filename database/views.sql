-- Reporting views
-- Purpose: clean datasets for dashboards, analytics notebooks, and Power BI.
USE smartstore;

CREATE OR REPLACE VIEW vw_monthly_sales AS
WITH monthly AS (
  SELECT DATE_FORMAT(order_date, '%Y-%m-01') AS month_start,
         SUM(total_amount) AS revenue,
         COUNT(*) AS total_orders
  FROM orders
  WHERE order_status NOT IN ('CANCELLED','REFUNDED')
  GROUP BY DATE_FORMAT(order_date, '%Y-%m-01')
)
SELECT month_start,
       revenue,
       total_orders,
       ROUND(revenue / NULLIF(total_orders, 0), 2) AS avg_order_value
FROM monthly;

CREATE OR REPLACE VIEW vw_customer_ltv AS
SELECT c.customer_id,
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       c.customer_status,
       COUNT(DISTINCT o.order_id) AS orders_count,
       ROUND(COALESCE(SUM(o.total_amount), 0), 2) AS lifetime_value,
       MAX(o.order_date) AS last_order_date,
       DATEDIFF(CURRENT_DATE, MAX(o.order_date)) AS days_since_last_order
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, customer_name, c.customer_status;

CREATE OR REPLACE VIEW vw_product_performance AS
SELECT p.product_id,
       p.product_name,
       cat.category_name,
       SUM(oi.quantity) AS units_sold,
       ROUND(SUM(oi.line_total), 2) AS gross_sales,
       RANK() OVER (PARTITION BY cat.category_name ORDER BY SUM(oi.line_total) DESC) AS category_rank
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN categories cat ON p.category_id = cat.category_id
GROUP BY p.product_id, p.product_name, cat.category_name;

CREATE OR REPLACE VIEW vw_inventory_status AS
SELECT p.sku,
       p.product_name,
       i.warehouse_code,
       i.quantity_on_hand,
       i.reorder_level,
       CASE WHEN i.quantity_on_hand <= i.reorder_level THEN 'REORDER' ELSE 'HEALTHY' END AS inventory_status
FROM inventory i
JOIN products p ON i.product_id = p.product_id;
