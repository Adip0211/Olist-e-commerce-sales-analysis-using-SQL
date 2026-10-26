-- =====================================================
-- 04_top_product_categories.sql
-- Top 10 categories by revenue, with share of total
-- =====================================================

WITH category_sales AS (
    SELECT
        COALESCE(t.product_category_name_english, 'unknown') AS category,
        COUNT(DISTINCT oi.order_id)                          AS orders,
        COUNT(*)                                             AS items_sold,
        SUM(oi.price)                                        AS revenue
    FROM order_items oi
    JOIN orders o             ON o.order_id = oi.order_id
    JOIN products p           ON p.product_id = oi.product_id
    LEFT JOIN category_translation t
                              ON t.product_category_name = p.product_category_name
    WHERE o.order_status = 'delivered'
    GROUP BY 1
)
SELECT
    RANK() OVER (ORDER BY revenue DESC)                  AS revenue_rank,
    category,
    orders,
    items_sold,
    ROUND(revenue, 2)                                    AS revenue,
    ROUND(100.0 * revenue / SUM(revenue) OVER (), 2)     AS revenue_share_pct
FROM category_sales
ORDER BY revenue DESC
LIMIT 10;
