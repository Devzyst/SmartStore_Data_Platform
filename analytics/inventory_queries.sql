-- Revenue analytics queries
-- Purpose: executive-level KPIs and trend analysis.
USE smartstore;
-- Monthly revenue with month-over-month growth.
WITH monthly AS (
  SELECT month_start,
         revenue,
         LAG(revenue) OVER (ORDER BY month_start) AS previous_month_revenue
  FROM vw_monthly_sales
)
SELECT month_start,
       revenue,
       previous_month_revenue,
       ROUND((revenue - previous_month_revenue) / NULLIF(previous_month_revenue, 0) * 100, 2) AS mom_growth_pct
FROM monthly;

-- Revenue by sales channel.
SELECT sales_channel,
       COUNT(*) AS orders_count,
       ROUND(SUM(total_amount), 2) AS revenue,
       ROUND(AVG(total_amount), 2) AS avg_order_value
FROM orders
WHERE order_status NOT IN ('CANCELLED','REFUNDED')
GROUP BY sales_channel
ORDER BY revenue DESC;

