-- Sales analytics queries
-- Purpose: examples for interview discussion, BI exploration, and query practice.
USE smartstore;

-- Top products by revenue using ranking window functions.
SELECT product_name,
       category_name,
       gross_sales,
       RANK() OVER (ORDER BY gross_sales DESC) AS revenue_rank
FROM vw_product_performance
ORDER BY revenue_rank
LIMIT 25;

-- Rolling 30-day revenue trend.
WITH daily_sales AS (
  SELECT DATE(order_date) AS sales_date,
         SUM(total_amount) AS revenue
  FROM orders
  WHERE order_status NOT IN ('CANCELLED','REFUNDED')
  GROUP BY DATE(order_date)
)
SELECT sales_date,
       revenue,
       AVG(revenue) OVER (ORDER BY sales_date ROWS BETWEEN 29 PRECEDING AND CURRENT ROW) AS rolling_30_day_revenue
FROM daily_sales;
