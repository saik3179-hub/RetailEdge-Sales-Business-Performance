
USE retail_edge_analytics;

-- 1. Final row counts across all five source tables
SELECT 'customers' AS table_name, COUNT(*) AS total_rows
FROM customers
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'sales_targets', COUNT(*) FROM sales_targets;


-- 2. Check for missing foreign-key relationships
-- Every result should be zero.
SELECT
    'Orders without matching customers' AS validation_check,
    COUNT(*) AS issue_count
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL

UNION ALL

SELECT
    'Order items without matching orders',
    COUNT(*)
FROM order_items oi
LEFT JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL

UNION ALL

SELECT
    'Order items without matching products',
    COUNT(*)
FROM order_items oi
LEFT JOIN products p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;


-- 3. Check invalid or unexpected business values
SELECT
    'Invalid order status' AS validation_check,
    COUNT(*) AS issue_count
FROM orders
WHERE order_status NOT IN ('Delivered', 'Processing', 'Cancelled')

UNION ALL

SELECT
    'Invalid sales channel',
    COUNT(*)
FROM orders
WHERE sales_channel NOT IN (
    'Online', 'Retail Store', 'Distributor', 'Direct Sales'
)

UNION ALL

SELECT
    'Invalid discount',
    COUNT(*)
FROM order_items
WHERE discount < 0 OR discount > 1

UNION ALL

SELECT
    'Invalid quantity',
    COUNT(*)
FROM order_items
WHERE quantity <= 0

UNION ALL

SELECT
    'Products with unit price not greater than unit cost',
    COUNT(*)
FROM products
WHERE unit_price <= unit_cost;


-- 4. Reconcile order-item view with source tables
SELECT
    (SELECT COUNT(*) FROM order_items) AS source_order_item_rows,
    (SELECT COUNT(*) FROM vw_order_line_analysis) AS view_rows,
    (SELECT COUNT(*) FROM order_items)
      - (SELECT COUNT(*) FROM vw_order_line_analysis)
        AS row_difference;


-- 5. Reconcile overall delivered sales KPIs
WITH source_kpis AS (
    SELECT
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.quantity * p.unit_price * (1 - oi.discount))
            AS revenue,
        SUM(oi.quantity * p.unit_cost) AS total_cost,
        SUM(
            oi.quantity * p.unit_price * (1 - oi.discount)
            - oi.quantity * p.unit_cost
        ) AS profit
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    WHERE o.order_status = 'Delivered'
),
view_kpis AS (
    SELECT
        COUNT(DISTINCT order_id) AS total_orders,
        SUM(net_revenue) AS revenue,
        SUM(total_cost) AS total_cost,
        SUM(profit) AS profit
    FROM vw_order_line_analysis
    WHERE order_status = 'Delivered'
)
SELECT
    s.total_orders AS source_orders,
    v.total_orders AS view_orders,
    ROUND(s.revenue, 2) AS source_revenue,
    ROUND(v.revenue, 2) AS view_revenue,
    ROUND(s.revenue - v.revenue, 2) AS revenue_difference,
    ROUND(s.total_cost, 2) AS source_cost,
    ROUND(v.total_cost, 2) AS view_cost,
    ROUND(s.profit, 2) AS source_profit,
    ROUND(v.profit, 2) AS view_profit,
    ROUND(s.profit - v.profit, 2) AS profit_difference
FROM source_kpis s
CROSS JOIN view_kpis v;


-- 6. Validate monthly sales coverage
SELECT
    COUNT(*) AS months_with_delivered_sales,
    MIN(sales_month) AS first_sales_month,
    MAX(sales_month) AS last_sales_month
FROM (
    SELECT DISTINCT
        DATE_FORMAT(order_date, '%Y-%m') AS sales_month
    FROM vw_order_line_analysis
    WHERE order_status = 'Delivered'
) monthly_data;


-- 7. Validate sales target coverage
SELECT
    COUNT(*) AS total_target_records,
    COUNT(DISTINCT target_month) AS target_months,
    COUNT(DISTINCT region) AS target_regions,
    MIN(target_month) AS first_target_month,
    MAX(target_month) AS last_target_month
FROM sales_targets;


-- 8. Check month-region combinations without matching target records
WITH monthly_region_sales AS (
    SELECT
        DATE_SUB(
            order_date,
            INTERVAL DAYOFMONTH(order_date) - 1 DAY
        ) AS sales_month,
        region,
        SUM(net_revenue) AS actual_revenue
    FROM vw_order_line_analysis
    WHERE order_status = 'Delivered'
    GROUP BY
        DATE_SUB(
            order_date,
            INTERVAL DAYOFMONTH(order_date) - 1 DAY
        ),
        region
)
SELECT
    COUNT(*) AS sales_month_region_combinations_without_targets
FROM monthly_region_sales s
LEFT JOIN sales_targets t
    ON s.sales_month = t.target_month
    AND s.region = t.region
WHERE t.target_month IS NULL;


-- 9. Reconcile total delivered revenue with monthly regional sales
WITH monthly_region_sales AS (
    SELECT
        DATE_SUB(
            order_date,
            INTERVAL DAYOFMONTH(order_date) - 1 DAY
        ) AS sales_month,
        region,
        SUM(net_revenue) AS actual_revenue
    FROM vw_order_line_analysis
    WHERE order_status = 'Delivered'
    GROUP BY
        DATE_SUB(
            order_date,
            INTERVAL DAYOFMONTH(order_date) - 1 DAY
        ),
        region
)
SELECT
    ROUND(
        (SELECT SUM(net_revenue)
         FROM vw_order_line_analysis
         WHERE order_status = 'Delivered'), 2
    ) AS overall_delivered_revenue,
    ROUND(SUM(actual_revenue), 2) AS monthly_regional_revenue,
    ROUND(
        (SELECT SUM(net_revenue)
         FROM vw_order_line_analysis
         WHERE order_status = 'Delivered')
        - SUM(actual_revenue), 2
    ) AS revenue_difference
FROM monthly_region_sales;


-- 10. Final business KPI summary
SELECT
    COUNT(DISTINCT order_id) AS delivered_orders,
    COUNT(DISTINCT customer_id) AS delivered_customers,
    SUM(quantity) AS units_sold,
    ROUND(SUM(net_revenue), 2) AS total_revenue,
    ROUND(SUM(total_cost), 2) AS total_cost,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        SUM(profit) / NULLIF(SUM(net_revenue), 0) * 100, 2
    ) AS profit_margin_pct,
    ROUND(
        SUM(net_revenue) /
        NULLIF(COUNT(DISTINCT order_id), 0), 2
    ) AS average_order_value
FROM vw_order_line_analysis
WHERE order_status = 'Delivered';
