-- =====================================================
-- 02_data_quality_checks.sql
-- Basic validation before analysis
-- =====================================================

-- 1. Row counts per table
SELECT 'customers' AS tbl, COUNT(*) AS row_count FROM customers
UNION ALL SELECT 'orders',         COUNT(*) FROM orders
UNION ALL SELECT 'order_items',    COUNT(*) FROM order_items
UNION ALL SELECT 'order_payments', COUNT(*) FROM order_payments
UNION ALL SELECT 'products',       COUNT(*) FROM products;

-- 2. Order status distribution
SELECT order_status, COUNT(*) AS orders
FROM orders
GROUP BY order_status
ORDER BY orders DESC;

-- 3. Delivered orders with a missing delivery date
SELECT COUNT(*) AS delivered_without_date
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NULL;

-- 4. Orders that have no items
SELECT COUNT(*) AS orders_without_items
FROM orders o
LEFT JOIN order_items oi ON oi.order_id = o.order_id
WHERE oi.order_id IS NULL;

-- 5. Products with no category
SELECT COUNT(*) AS products_without_category
FROM products
WHERE product_category_name IS NULL;

-- 6. Delivery date earlier than purchase date (invalid)
SELECT COUNT(*) AS invalid_delivery_dates
FROM orders
WHERE order_delivered_customer_date < order_purchase_timestamp;

-- 7. Date range covered by the data
SELECT MIN(order_purchase_timestamp) AS first_order,
       MAX(order_purchase_timestamp) AS last_order
FROM orders;
