
-- =====================================================
-- MODULE 4.1: DATABASE EXPLORATION
-- =====================================================

USE retail_edge_analytics;

-- 1. Check current database
SELECT DATABASE();

-- 2. Check all tables
SHOW TABLES;

-- 3. Total records in all five tables
SELECT 'Customers' AS table_name, COUNT(*) AS total_records
FROM customers
UNION ALL
SELECT 'Products', COUNT(*) FROM products
UNION ALL
SELECT 'Orders', COUNT(*) FROM orders
UNION ALL
SELECT 'Order Items', COUNT(*) FROM order_items
UNION ALL
SELECT 'Sales Targets', COUNT(*) FROM sales_targets;



-- 4. Order date range
SELECT
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    COUNT(DISTINCT MONTH(order_date)) AS distinct_month_numbers
FROM orders;


-- 5. Order status distribution
SELECT
    order_status,
    COUNT(*) AS total_orders,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM orders), 2
    ) AS percentage
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;


-- 6. Customer distribution by region
SELECT
    region,
    COUNT(*) AS total_customers
FROM customers
GROUP BY region
ORDER BY total_customers DESC;


-- 7. Product distribution by category
SELECT
    category,
    COUNT(*) AS total_products
FROM products
GROUP BY category
ORDER BY total_products DESC;


-- 8. Sales channel distribution
SELECT
    sales_channel,
    COUNT(*) AS total_orders
FROM orders
GROUP BY sales_channel
ORDER BY total_orders DESC;


-- 9. Product price and cost overview
SELECT
    category,
    ROUND(AVG(unit_cost), 2) AS average_unit_cost,
    ROUND(AVG(unit_price), 2) AS average_unit_price,
    ROUND(AVG(unit_price - unit_cost), 2) AS average_unit_profit
FROM products
GROUP BY category;
