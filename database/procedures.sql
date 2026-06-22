-- Stored procedures
-- Purpose: reusable database operations that simulate backend data services.
USE smartstore;
DELIMITER $$
  
CREATE PROCEDURE create_order(
  IN p_customer_id BIGINT,
  IN p_order_date DATETIME,
  IN p_sales_channel VARCHAR(40),
  IN p_subtotal DECIMAL(14,2),
  IN p_shipping DECIMAL(14,2),
  IN p_tax DECIMAL(14,2),
  IN p_discount DECIMAL(14,2),
  IN p_employee_id INT
)
BEGIN
  INSERT INTO orders(customer_id, order_date, order_status, sales_channel, employee_id, subtotal, shipping_amount, tax_amount, discount_amount, total_amount)
  VALUES (p_customer_id, p_order_date, 'PLACED', p_sales_channel, p_employee_id, p_subtotal, p_shipping, p_tax, p_discount, p_subtotal + p_shipping + p_tax - p_discount);
END$$

CREATE PROCEDURE update_inventory(
  IN p_product_id BIGINT,
  IN p_warehouse_code VARCHAR(30),
  IN p_delta INT
)
BEGIN
  UPDATE inventory
  SET quantity_on_hand = quantity_on_hand + p_delta,
      last_restocked_at = IF(p_delta > 0, NOW(), last_restocked_at)
  WHERE product_id = p_product_id
    AND warehouse_code = p_warehouse_code;
END$$

CREATE PROCEDURE calculate_monthly_revenue(IN p_year INT)
BEGIN
  SELECT MONTH(order_date) AS month_num,
         ROUND(SUM(total_amount), 2) AS monthly_revenue,
         COUNT(*) AS order_count,
         ROUND(AVG(total_amount), 2) AS avg_order_value
  FROM orders
  WHERE YEAR(order_date) = p_year
    AND order_status NOT IN ('CANCELLED','REFUNDED')
  GROUP BY MONTH(order_date)
  ORDER BY month_num;
END$$

CREATE PROCEDURE generate_sales_report(IN p_start DATE, IN p_end DATE)
BEGIN
  SELECT DATE(order_date) AS sales_date,
         sales_channel,
         SUM(total_amount) AS revenue,
         COUNT(*) AS orders_count
  FROM orders
  WHERE DATE(order_date) BETWEEN p_start AND p_end
    AND order_status NOT IN ('CANCELLED','REFUNDED')
  GROUP BY DATE(order_date), sales_channel
  ORDER BY sales_date, sales_channel;
END$$

DELIMITER ;
