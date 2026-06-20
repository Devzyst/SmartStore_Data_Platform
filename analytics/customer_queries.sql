-- Customer analytics queries
-- Purpose: customer segmentation, retention, and churn-risk analysis.
USE smartstore;

-- Customer value segments.
WITH customer_spend AS (
  SELECT customer_id,
         lifetime_value,
         orders_count,
         NTILE(4) OVER (ORDER BY lifetime_value DESC) AS value_quartile
  FROM vw_customer_ltv
)
