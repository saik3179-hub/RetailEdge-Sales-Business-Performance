
USE retail_edge_analytics;

-- 1. Overall regional performance

SELECT
    region,

    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS unique_customers,
    SUM(quantity) AS units_sold,

    ROUND(SUM(net_revenue), 2) AS revenue,
    ROUND(SUM(total_cost), 2) AS total_cost,
    ROUND(SUM(profit), 2) AS profit,

    ROUND(
        SUM(profit) / NULLIF(SUM(net_revenue), 0) * 100,
        2
    ) AS profit_margin_percentage,

    ROUND(
        SUM(net_revenue) /
        NULLIF(COUNT(DISTINCT order_id), 0),
        2
    ) AS average_order_value

FROM vw_order_line_analysis

WHERE order_status = 'Delivered'

GROUP BY region

ORDER BY revenue DESC;




-- 2. Regional revenue contribution

WITH regional_sales AS (

    SELECT
        region,
        SUM(net_revenue) AS revenue

    FROM vw_order_line_analysis

    WHERE order_status = 'Delivered'

    GROUP BY region
)

SELECT
    region,

    ROUND(revenue, 2) AS revenue,

    ROUND(
        revenue / NULLIF(SUM(revenue) OVER (), 0) * 100,
        2
    ) AS revenue_contribution_percentage,

    RANK() OVER (
        ORDER BY revenue DESC
    ) AS revenue_rank

FROM regional_sales

ORDER BY revenue DESC;




-- 3. City-level performance

SELECT
    region,
    city,

    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS unique_customers,

    SUM(quantity) AS units_sold,

    ROUND(SUM(net_revenue), 2) AS revenue,
    ROUND(SUM(profit), 2) AS profit,

    ROUND(
        SUM(profit) / NULLIF(SUM(net_revenue), 0) * 100,
        2
    ) AS profit_margin_percentage

FROM vw_order_line_analysis

WHERE order_status = 'Delivered'

GROUP BY region, city

ORDER BY revenue DESC;




-- 4. Regional profitability ranking

WITH regional_profit AS (

    SELECT
        region,

        SUM(net_revenue) AS revenue,
        SUM(profit) AS profit,

        SUM(profit) /
        NULLIF(SUM(net_revenue), 0) * 100
        AS profit_margin

    FROM vw_order_line_analysis

    WHERE order_status = 'Delivered'

    GROUP BY region
)

SELECT
    region,

    ROUND(revenue, 2) AS revenue,
    ROUND(profit, 2) AS profit,
    ROUND(profit_margin, 2) AS profit_margin_percentage,

    RANK() OVER (
        ORDER BY profit DESC
    ) AS profit_rank,

    DENSE_RANK() OVER (
        ORDER BY profit_margin DESC
    ) AS margin_rank

FROM regional_profit

ORDER BY profit_rank;




-- 5. Regional performance by year

SELECT
    YEAR(order_date) AS sales_year,
    region,

    COUNT(DISTINCT order_id) AS total_orders,

    ROUND(SUM(net_revenue), 2) AS revenue,
    ROUND(SUM(profit), 2) AS profit,

    ROUND(
        SUM(profit) / NULLIF(SUM(net_revenue), 0) * 100,
        2
    ) AS profit_margin_percentage

FROM vw_order_line_analysis

WHERE order_status = 'Delivered'

GROUP BY YEAR(order_date), region

ORDER BY sales_year, revenue DESC;
