# RetailEdge — Sales & Business Performance Analytics

An end-to-end Data Analytics and Business Intelligence project using **MySQL, SQL and Microsoft Power BI** to analyse sales performance, profitability, product contribution, regional performance and sales target achievement for a fictional Indian retail and distribution company.

> **Disclaimer:** RetailEdge Distribution Pvt. Ltd. is a fictional company. All datasets and business results in this project are synthetically generated for educational and portfolio purposes.

## 1. Project Overview

RetailEdge Distribution Pvt. Ltd. operates across five regions in India, selling products across multiple categories, customer segments and sales channels.

The objective of this project is to develop an end-to-end analytics solution that transforms raw business data into meaningful insights to support management decision-making.

The project covers the complete analytics workflow, from synthetic data generation and relational database development to SQL analysis, Power BI dashboards and business insights.

## 2. Business Objectives

- Monitor revenue, cost, profit and profitability.
- Analyse monthly and yearly sales trends.
- Compare regional and city-level performance.
- Identify high-performing and low-performing products.
- Evaluate product category contribution.
- Analyse sales channel performance.
- Monitor discount impact on revenue.
- Compare actual revenue against sales targets.
- Provide management with interactive business performance dashboards.

## 3. Technology Stack

| Technology | Purpose |
|---|---|
| MySQL Community Server | Relational database |
| MySQL Workbench | Database management and SQL execution |
| SQL | Data exploration, transformation and analysis |
| Microsoft Power BI Desktop | Business intelligence and dashboards |
| Power Query | Data cleaning and transformation |
| DAX | Measures, KPIs and calculations |
| CSV | Synthetic source datasets |
| Git & GitHub | Version control and project publication |

## 4. Dataset Overview

The project uses five synthetic datasets covering January 2024 to December 2025.

| Dataset | Records | Description |
|---|---:|---|
| Customers | 500 | Customer details, city, region and segment |
| Products | 100 | Product details, category, cost and selling price |
| Orders | 5,000 | Order dates, customer references, status and sales channel |
| Order Items | 10,000 | Product-level quantities and discounts |
| Sales Targets | 120 | Monthly revenue targets across five regions |

**Total records: 15,720 across five datasets.**

All monetary calculations use decimal-based values to maintain financial accuracy.

## 5. Database Design

The MySQL database is named `retail_edge_analytics`.

It contains five relational tables:

- `customers`
- `products`
- `orders`
- `order_items`
- `sales_targets`

Primary keys, foreign keys, unique constraints, check constraints and indexes are used to maintain data integrity.

A SQL analytical view, `vw_order_line_analysis`, combines order, product and customer information and calculates:

- Gross Revenue
- Net Revenue
- Total Cost
- Profit

## 6. SQL Data Analysis

SQL analysis covers the following areas:

1. Database exploration and data profiling.
2. Overall business performance.
3. Monthly sales trends.
4. Regional performance.
5. Product and category performance.
6. Customer analysis.
7. Sales channel analysis.
8. Sales target achievement.
9. Advanced business analysis.
10. Final SQL validation.

## 7. Power BI Dashboard

The final Power BI report contains four interactive pages.

### Page 1 — Executive Overview

Provides a high-level summary of business performance through revenue, profit, margin, order volume, average order value and target achievement KPIs.

### Page 2 — Sales Trends & Performance

Analyses monthly revenue and profit trends, delivered order volume, sales channel contribution and year-over-year performance.

### Page 3 — Product & Category Performance

Highlights category contribution, product profitability, top-performing products, discount impact and detailed product-level performance.

### Page 4 — Regional Performance Analysis

Compares regional revenue, profitability, city-wise sales and actual revenue against targets, with a regional performance matrix.

## 8. Key Performance Indicators

| KPI | Calculation |
|---|---|
| Net Revenue | Quantity × Unit Price × (1 − Discount) |
| Total Cost | Quantity × Unit Cost |
| Total Profit | Net Revenue − Total Cost |
| Profit Margin | Total Profit ÷ Net Revenue × 100 |
| Average Order Value | Net Revenue ÷ Distinct Delivered Orders |
| Units Sold | Sum of delivered quantities |
| Target Achievement | Actual Revenue ÷ Target Revenue × 100 |
| Discount Amount | Gross Revenue − Net Revenue |

**Business rule:** Realised sales KPIs include delivered orders only. Processing and cancelled orders are excluded from realised revenue, cost and profit calculations.

## 9. Key Business Findings

The analysis of the synthetic dataset produced the following observations:

- Total net revenue was approximately **₹7.40 crore**, with total profit of approximately **₹1.74 crore**.
- Overall profit margin was approximately **23.56%**.
- Revenue increased by approximately **9.96%** from 2024 to 2025.
- The West region was the highest revenue-generating region.
- North and West exceeded their annual revenue targets.
- Electronics contributed approximately **39.37%** of total revenue.
- Furniture contributed approximately **25.42%** of total revenue.
- The 43-inch 4K Smart TV was the leading product in the displayed revenue and profit rankings.
- Total discounts amounted to approximately **₹52.6 lakh**.
- Overall sales target achievement was approximately **97.71%**.

All findings refer to the fictional synthetic business dataset.

## 10. Data Model & Validation

The Power BI model uses related customer, product, order, date, region and month dimensions to support analytical filtering.

DAX measures were validated against independent MySQL queries.

Final validation covered:

- Overall business KPIs.
- Year-wise performance.
- Regional target achievement.
- Product-level performance.
- Sales channel performance.

**Validation result:** All five final SQL validation queries matched the corresponding Power BI results, with no KPI discrepancies identified.

## 11. Project Outcomes

This project demonstrates practical experience in:

- Relational database design and management.
- SQL querying, joins, CTEs, aggregations and window functions.
- Data cleaning and transformation.
- Data modelling and relationship management.
- DAX calculations and KPI development.
- Interactive business intelligence dashboard development.
- Financial and operational performance analysis.
- Data validation and business insight generation.

## 12. Disclaimer

This is an independent portfolio project developed using synthetic data. RetailEdge Distribution Pvt. Ltd. and all associated business figures are fictional and do not represent an actual organisation or commercial performance.

---

**Project:** RetailEdge — Sales & Business Performance Analytics  
**Tools:** MySQL | SQL | Power BI | Power Query | DAX  
**Data Coverage:** January 2024 – December 2025
