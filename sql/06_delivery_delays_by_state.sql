-- =====================================================
-- 06_delivery_delays_by_state.sql
-- Delivery performance by customer state
-- Delay = actual delivery date - estimated delivery date (days)
-- =====================================================

WITH delivery AS (
    SELECT
        c.customer_state,
        o.order_id,
        EXTRACT(EPOCH FROM (o.order_delivered_customer_date
                          - o.order_purchase_timestamp)) / 86400.0 AS delivery_days,
        EXTRACT(EPOCH FROM (o.order_delivered_customer_date
                          - o.order_estimated_delivery_date)) / 86400.0 AS delay_days
    FROM orders o
    JOIN customers c ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
      AND o.order_delivered_customer_date IS NOT NULL
)
SELECT
    customer_state,
    COUNT(*)                                              AS delivered_orders,
    ROUND(AVG(delivery_days)::numeric, 1)                 AS avg_delivery_days,
    COUNT(*) FILTER (WHERE delay_days > 0)                AS late_orders,
    ROUND(100.0 * COUNT(*) FILTER (WHERE delay_days > 0)
          / COUNT(*), 2)                                  AS late_order_pct,
    ROUND(AVG(delay_days) FILTER (WHERE delay_days > 0)::numeric, 1)
                                                          AS avg_days_late_when_late
FROM delivery
GROUP BY customer_state
HAVING COUNT(*) >= 100
ORDER BY late_order_pct DESC;
