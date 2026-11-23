
USE retail_edge_analytics;

-- 1. Category performance

SELECT
    category,

    COUNT(DISTINCT product_id) AS total_products,
    SUM(quantity) AS units_sold,
    COUNT(DISTINCT order_id) AS total_orders,

    ROUND(SUM(net_revenue), 2) AS revenue,
    ROUND(SUM(total_cost), 2) AS total_cost,
    ROUND(SUM(profit), 2) AS profit,

    ROUND(
        SUM(profit) / NULLIF(SUM(net_revenue), 0) * 100,
        2
    ) AS profit_margin_percentage

FROM vw_order_line_analysis

WHERE order_status = 'Delivered'

GROUP BY category

ORDER BY revenue DESC;




-- 2. Product-level performance

SELECT
    product_id,
    product_name,
    category,

    SUM(quantity) AS units_sold,

    COUNT(DISTINCT order_id) AS total_orders,

    ROUND(SUM(net_revenue), 2) AS revenue,
    ROUND(SUM(total_cost), 2) AS total_cost,
    ROUND(SUM(profit), 2) AS profit,

    ROUND(
        SUM(profit) / NULLIF(SUM(net_revenue), 0) * 100,
        2
    ) AS profit_margin_percentage

FROM vw_order_line_analysis

WHERE order_status = 'Delivered'

GROUP BY product_id, product_name, category

ORDER BY revenue DESC;




-- 3. Top 10 products by revenue

SELECT
    product_id,
    product_name,
    category,

    SUM(quantity) AS units_sold,

    ROUND(SUM(net_revenue), 2) AS revenue,
    ROUND(SUM(profit), 2) AS profit

FROM vw_order_line_analysis

WHERE order_status = 'Delivered'

GROUP BY product_id, product_name, category

ORDER BY revenue DESC

LIMIT 10;




-- 4. Top 10 products by profit

SELECT
    product_id,
    product_name,
    category,

    SUM(quantity) AS units_sold,

    ROUND(SUM(net_revenue), 2) AS revenue,
    ROUND(SUM(profit), 2) AS profit,

    ROUND(
        SUM(profit) / NULLIF(SUM(net_revenue), 0) * 100,
        2
    ) AS profit_margin_percentage

FROM vw_order_line_analysis

WHERE order_status = 'Delivered'

GROUP BY product_id, product_name, category

ORDER BY profit DESC

LIMIT 10;




-- 5. Bottom 10 products by profit margin

SELECT
    product_id,
    product_name,
    category,

    SUM(quantity) AS units_sold,

    ROUND(SUM(net_revenue), 2) AS revenue,
    ROUND(SUM(profit), 2) AS profit,

    ROUND(
        SUM(profit) / NULLIF(SUM(net_revenue), 0) * 100,
        2
    ) AS profit_margin_percentage

FROM vw_order_line_analysis

WHERE order_status = 'Delivered'

GROUP BY product_id, product_name, category

HAVING SUM(net_revenue) > 0

ORDER BY profit_margin_percentage ASC

LIMIT 10;




-- 6. Top 3 products within each category

WITH product_sales AS (

    SELECT
        product_id,
        product_name,
        category,

        SUM(quantity) AS units_sold,
        SUM(net_revenue) AS revenue,
        SUM(profit) AS profit

    FROM vw_order_line_analysis

    WHERE order_status = 'Delivered'

    GROUP BY product_id, product_name, category
),

ranked_products AS (

    SELECT
        *,

        DENSE_RANK() OVER (
            PARTITION BY category
            ORDER BY revenue DESC
        ) AS category_rank

    FROM product_sales
)

SELECT
    product_id,
    product_name,
    category,
    units_sold,

    ROUND(revenue, 2) AS revenue,
    ROUND(profit, 2) AS profit,

    category_rank

FROM ranked_products

WHERE category_rank <= 3

ORDER BY category, category_rank;




-- 7. Discount impact by product category

SELECT
    category,

    ROUND(SUM(gross_revenue), 2) AS gross_revenue,

    ROUND(SUM(net_revenue), 2) AS net_revenue,

    ROUND(
        SUM(gross_revenue) - SUM(net_revenue),
        2
    ) AS total_discount_amount,

    ROUND(
        (SUM(gross_revenue) - SUM(net_revenue))
        / NULLIF(SUM(gross_revenue), 0) * 100,
        2
    ) AS discount_impact_percentage,

    ROUND(SUM(profit), 2) AS profit

FROM vw_order_line_analysis

WHERE order_status = 'Delivered'

GROUP BY category

ORDER BY total_discount_amount DESC;
