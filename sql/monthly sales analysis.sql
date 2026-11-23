
USE retail_edge_analytics;

-- 1. Monthly sales and profit performance

SELECT
    YEAR(order_date) AS sales_year,
    MONTH(order_date) AS month_number,
    DATE_FORMAT(order_date, '%b') AS month_name,

    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity) AS units_sold,

    ROUND(SUM(net_revenue), 2) AS revenue,
    ROUND(SUM(total_cost), 2) AS total_cost,
    ROUND(SUM(profit), 2) AS profit,

    ROUND(
        SUM(profit) / NULLIF(SUM(net_revenue), 0) * 100,
        2
    ) AS profit_margin_percentage

FROM vw_order_line_analysis

WHERE order_status = 'Delivered'

GROUP BY
    YEAR(order_date),
    MONTH(order_date),
    DATE_FORMAT(order_date, '%b')

ORDER BY sales_year, month_number;



-- 2. Top 10 revenue-generating months

SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS sales_month,

    COUNT(DISTINCT order_id) AS total_orders,

    ROUND(SUM(net_revenue), 2) AS revenue,

    ROUND(SUM(profit), 2) AS profit

FROM vw_order_line_analysis

WHERE order_status = 'Delivered'

GROUP BY DATE_FORMAT(order_date, '%Y-%m')

ORDER BY revenue DESC

LIMIT 10;




-- 3. Year-over-year performance

WITH yearly_sales AS (

    SELECT
        YEAR(order_date) AS sales_year,

        SUM(net_revenue) AS revenue,
        SUM(profit) AS profit,
        COUNT(DISTINCT order_id) AS total_orders

    FROM vw_order_line_analysis

    WHERE order_status = 'Delivered'

    GROUP BY YEAR(order_date)
)

SELECT
    sales_year,

    ROUND(revenue, 2) AS revenue,
    ROUND(profit, 2) AS profit,
    total_orders,

    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY sales_year))
        / NULLIF(
            LAG(revenue) OVER (ORDER BY sales_year), 0
        ) * 100,
        2
    ) AS revenue_growth_percentage,

    ROUND(
        (profit - LAG(profit) OVER (ORDER BY sales_year))
        / NULLIF(
            LAG(profit) OVER (ORDER BY sales_year), 0
        ) * 100,
        2
    ) AS profit_growth_percentage

FROM yearly_sales

ORDER BY sales_year;




-- 4. Month-over-month revenue growth

WITH monthly_sales AS (

    SELECT
        DATE_FORMAT(order_date, '%Y-%m') AS sales_month,
        SUM(net_revenue) AS revenue

    FROM vw_order_line_analysis

    WHERE order_status = 'Delivered'

    GROUP BY DATE_FORMAT(order_date, '%Y-%m')
),

monthly_comparison AS (

    SELECT
        sales_month,
        revenue,

        LAG(revenue) OVER (
            ORDER BY sales_month
        ) AS previous_month_revenue

    FROM monthly_sales
)

SELECT
    sales_month,

    ROUND(revenue, 2) AS current_month_revenue,

    ROUND(previous_month_revenue, 2) AS previous_month_revenue,

    ROUND(
        (revenue - previous_month_revenue)
        / NULLIF(previous_month_revenue, 0) * 100,
        2
    ) AS mom_growth_percentage

FROM monthly_comparison

ORDER BY sales_month;




-- 5. Monthly profitability analysis

SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS sales_month,

    ROUND(SUM(net_revenue), 2) AS revenue,
    ROUND(SUM(profit), 2) AS profit,

    ROUND(
        SUM(profit) / NULLIF(SUM(net_revenue), 0) * 100,
        2
    ) AS profit_margin_percentage

FROM vw_order_line_analysis

WHERE order_status = 'Delivered'

GROUP BY DATE_FORMAT(order_date, '%Y-%m')

HAVING SUM(net_revenue) > 0

ORDER BY profit_margin_percentage ASC

LIMIT 10;
