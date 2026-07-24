-- Triggers
-- Purpose: small database automations for operational integrity and auditing.
USE smartstore;
DELIMITER $$
  
CREATE TRIGGER trg_reduce_inventory_after_order_item
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
  UPDATE inventory
  SET quantity_on_hand = quantity_on_hand - NEW.quantity
  WHERE product_id = NEW.product_id;
END$$
  
CREATE TRIGGER trg_audit_order_insert
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
  INSERT INTO audit_log(entity_name, entity_id, action_name, payload)
  VALUES('orders', NEW.order_id, 'INSERT', JSON_OBJECT('total_amount', NEW.total_amount, 'status', NEW.order_status));
END$$

CREATE TRIGGER trg_audit_payment_insert
AFTER INSERT ON payments
FOR EACH ROW
BEGIN
  INSERT INTO audit_log(entity_name, entity_id, action_name, payload)
  VALUES('payments', NEW.payment_id, 'INSERT', JSON_OBJECT('order_id', NEW.order_id, 'status', NEW.payment_status, 'amount', NEW.amount));
END$$

DELIMITER ;
