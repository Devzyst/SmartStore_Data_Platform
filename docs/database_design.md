# Database Design
## OLTP Model

The transactional model is normalized around core e-commerce entities:

- `customers`
- `orders`
- `order_items`
- `payments`
- `products`
- `categories`
- `suppliers`
- `inventory`
- `employees`
- `audit_log`

The schema demonstrates primary keys, foreign keys, cascade rules, check constraints, indexes, timestamps, and audit-friendly JSON payloads.

## Warehouse Model

The warehouse uses a simple star schema:

- Fact table: `fact_sales`
- Dimension tables: `dim_date`, `dim_customer`, `dim_product`, `dim_category`

This keeps dashboard workloads separated from operational tables and demonstrates analytics engineering fundamentals.

## Performance Notes

Indexes are included for high-use filters and joins:

- order date/status queries
- customer order history
- product sales analysis
- payment status monitoring
- inventory reorder reporting
