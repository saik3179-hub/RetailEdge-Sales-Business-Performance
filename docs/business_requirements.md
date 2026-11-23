# Business Requirements — RetailEdge Sales & Business Performance Analytics

## 1. Business Background

RetailEdge Distribution Pvt. Ltd. is a fictional Indian retail and distribution company operating across five regions: East, West, North, South and Central.

The company sells products across multiple categories and serves different customer segments through several sales channels.

The purpose of this project is to develop an end-to-end analytics solution to monitor business performance and support management decision-making.

## 2. Project Objectives

- Monitor overall sales and profitability.
- Analyse monthly and yearly business performance.
- Compare regional and city-level sales.
- Identify high-performing and low-performing products.
- Evaluate category-level revenue and profit contribution.
- Analyse customer and sales channel performance.
- Measure the impact of discounts.
- Monitor actual revenue against monthly regional targets.

## 3. Business Scope

| Area | Description |
|---|---|
| Business | Retail and distribution |
| Geography | Five Indian regions |
| Period | January 2024 – December 2025 |
| Currency | Indian Rupee (INR) |
| Product categories | Electronics, Home & Kitchen, Office Supplies, Furniture, Accessories |
| Customer segments | Consumer, Small Business, Corporate |
| Sales channels | Online, Retail Store, Distributor, Direct Sales |

## 4. Key Business Questions

### Overall Performance
- What is the total net revenue and profit?
- What is the overall profit margin?
- How many delivered orders and customers does the company have?
- What is the average order value?

### Sales Trends
- How does revenue change month over month?
- How does performance compare between 2024 and 2025?
- Which months generate the highest and lowest revenue?

### Regional Performance
- Which region generates the highest revenue?
- Which region has the highest profitability?
- Which cities contribute the most revenue?
- Which regions achieve their sales targets?

### Product & Category Performance
- Which categories contribute the most revenue?
- Which products generate the highest profit?
- Which products have lower profit margins?
- How much revenue is lost through discounts?

### Customer & Channel Performance
- Which customer segments contribute the most revenue?
- Which sales channels perform best?
- How do orders and customers vary across channels?

## 5. KPI Definitions

| KPI | Definition |
|---|---|
| Net Revenue | Quantity × Unit Price × (1 − Discount) |
| Total Cost | Quantity × Unit Cost |
| Total Profit | Net Revenue − Total Cost |
| Profit Margin | Total Profit ÷ Net Revenue × 100 |
| Average Order Value | Net Revenue ÷ Distinct Delivered Orders |
| Target Achievement | Actual Revenue ÷ Target Revenue × 100 |
| Discount Amount | Gross Revenue − Net Revenue |

## 6. Business Rules

1. Only delivered orders are included in realised sales, cost and profit KPIs.
2. Processing and cancelled orders are excluded from realised sales calculations.
3. Profit margin is calculated using total profit divided by total net revenue, not the average of individual line margins.
4. Average order value is calculated using distinct delivered orders.
5. Sales targets are stored at Region + Month level.
6. Actual sales must be aggregated to Region + Month level before being joined to sales targets.

## 7. Expected Deliverables

- Synthetic business datasets.
- MySQL relational database.
- SQL analysis scripts and analytical views.
- Power BI data model and DAX measures.
- Four-page interactive Power BI dashboard.
- Final validation and business insights.
- GitHub project documentation.
