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
SELECT customer_id,
       lifetime_value,
       orders_count,
       CASE value_quartile
         WHEN 1 THEN 'VIP'
         WHEN 2 THEN 'HIGH_VALUE'
         WHEN 3 THEN 'MID_VALUE'
         ELSE 'LOW_VALUE'
       END AS customer_segment
FROM customer_spend;

-- Churn-risk indicators.
SELECT customer_id,
       customer_name,
       days_since_last_order,
       lifetime_value,
       CASE WHEN days_since_last_order > 180 THEN 'HIGH_RISK'
            WHEN days_since_last_order > 90 THEN 'MEDIUM_RISK'
            ELSE 'ACTIVE'
       END AS churn_risk
FROM vw_customer_ltv;
