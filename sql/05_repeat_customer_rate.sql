-- =====================================================
-- 05_repeat_customer_rate.sql
-- Repeat-customer rate
-- NOTE: customer_id changes with every order in Olist, so we
-- use customer_unique_id to identify the same person.
-- =====================================================

WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM orders o
    JOIN customers c ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT
    COUNT(*)                                             AS total_customers,
    COUNT(*) FILTER (WHERE order_count > 1)              AS repeat_customers,
    ROUND(100.0 * COUNT(*) FILTER (WHERE order_count > 1)
          / COUNT(*), 2)                                 AS repeat_rate_pct
FROM customer_orders;

-- Distribution of customers by number of orders
WITH customer_orders AS (
    SELECT c.customer_unique_id, COUNT(DISTINCT o.order_id) AS order_count
    FROM orders o
    JOIN customers c ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT order_count, COUNT(*) AS customers
FROM customer_orders
GROUP BY order_count
ORDER BY order_count;
