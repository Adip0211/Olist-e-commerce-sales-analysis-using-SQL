-- =====================================================
-- 03_monthly_revenue_trends.sql
-- Monthly revenue, orders, average order value, MoM growth
-- Revenue = item price of delivered orders (freight excluded)
-- =====================================================

WITH monthly AS (
    SELECT
        DATE_TRUNC('month', o.order_purchase_timestamp)::date AS month,
        COUNT(DISTINCT o.order_id)                            AS total_orders,
        SUM(oi.price)                                         AS revenue
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY 1
)
SELECT
    month,
    total_orders,
    ROUND(revenue, 2)                                   AS revenue,
    ROUND(revenue / total_orders, 2)                    AS avg_order_value,
    ROUND(
        100.0 * (revenue - LAG(revenue) OVER (ORDER BY month))
        / NULLIF(LAG(revenue) OVER (ORDER BY month), 0)
    , 2)                                                AS mom_growth_pct
FROM monthly
ORDER BY month;
