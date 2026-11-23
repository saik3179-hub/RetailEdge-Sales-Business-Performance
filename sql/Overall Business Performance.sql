
-- =====================================================
-- MODULE 4.2: CREATE ANALYTICAL VIEW
-- =====================================================

USE retail_edge_analytics;

CREATE OR REPLACE VIEW vw_order_line_analysis AS

SELECT
    o.order_id,
    oi.order_item_id,
    o.order_date,
    o.order_status,
    o.sales_channel,

    c.customer_id,
    c.customer_name,
    c.city,
    c.region,
    c.customer_segment,

    p.product_id,
    p.product_name,
    p.category,

    oi.quantity,
    p.unit_cost,
    p.unit_price,
    oi.discount,

    -- Gross sales before discount
    ROUND(
        oi.quantity * p.unit_price, 2
    ) AS gross_revenue,

    -- Revenue after discount
    ROUND(
        oi.quantity * p.unit_price * (1 - oi.discount), 2
    ) AS net_revenue,

    -- Product cost
    ROUND(
        oi.quantity * p.unit_cost, 2
    ) AS total_cost,

    -- Profit after discount
    ROUND(
        (oi.quantity * p.unit_price * (1 - oi.discount))
        - (oi.quantity * p.unit_cost), 2
    ) AS profit

FROM orders o

INNER JOIN order_items oi
    ON o.order_id = oi.order_id

INNER JOIN products p
    ON oi.product_id = p.product_id

INNER JOIN customers c
    ON o.customer_id = c.customer_id;



SELECT *
FROM vw_order_line_analysis
LIMIT 10;




-- =====================================================
-- OVERALL BUSINESS PERFORMANCE
-- =====================================================

SELECT

    COUNT(DISTINCT order_id) AS total_delivered_orders,

    SUM(net_revenue) AS total_revenue,

    SUM(total_cost) AS total_cost,

    SUM(profit) AS total_profit,

    ROUND(
        SUM(profit) / NULLIF(SUM(net_revenue), 0) * 100,
        2
    ) AS profit_margin_percentage,

    ROUND(
        SUM(net_revenue) /
        NULLIF(COUNT(DISTINCT order_id), 0),
        2
    ) AS average_order_value,

    SUM(quantity) AS total_quantity_sold

FROM vw_order_line_analysis

WHERE order_status = 'Delivered';


-- ============================================
-- Calculate overall performance by year
-- ============================================
SELECT
    YEAR(order_date) AS sales_year,

    COUNT(DISTINCT order_id) AS total_orders,

    ROUND(SUM(net_revenue), 2) AS revenue,

    ROUND(SUM(profit), 2) AS profit,

    ROUND(
        SUM(profit) / NULLIF(SUM(net_revenue), 0) * 100,
        2
    ) AS profit_margin_percentage

FROM vw_order_line_analysis

WHERE order_status = 'Delivered'

GROUP BY YEAR(order_date)

ORDER BY sales_year;