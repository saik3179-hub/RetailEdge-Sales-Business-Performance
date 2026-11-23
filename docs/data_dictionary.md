# Data Dictionary — RetailEdge Analytics

## 1. Customers

**Table:** `customers`

| Column | Description |
|---|---|
| customer_id | Unique customer identifier |
| customer_name | Customer name |
| city | Customer city |
| region | Customer region |
| customer_segment | Customer classification |

## 2. Products

**Table:** `products`

| Column | Description |
|---|---|
| product_id | Unique product identifier |
| product_name | Product name |
| category | Product category |
| unit_cost | Product cost per unit |
| unit_price | Product selling price per unit |

## 3. Orders

**Table:** `orders`

| Column | Description |
|---|---|
| order_id | Unique order identifier |
| customer_id | Customer reference |
| order_date | Date of order |
| order_status | Delivered, Processing or Cancelled |
| sales_channel | Channel through which the order was placed |

## 4. Order Items

**Table:** `order_items`

| Column | Description |
|---|---|
| order_item_id | Unique order-line identifier |
| order_id | Related order identifier |
| product_id | Related product identifier |
| quantity | Units ordered |
| discount | Discount rate applied to the line |

## 5. Sales Targets

**Table:** `sales_targets`

| Column | Description |
|---|---|
| target_month | First day of the target month |
| region | Target region |
| target_revenue | Monthly regional revenue target |

## 6. Database Relationships

- `customers.customer_id` → `orders.customer_id`
- `orders.order_id` → `order_items.order_id`
- `products.product_id` → `order_items.product_id`
- `sales_targets` uses a composite primary key consisting of `target_month` and `region`.

## 7. Analytical View

**View:** `vw_order_line_analysis`

This view combines order, order-item, product and customer information.

It also derives:

- `gross_revenue` = quantity × unit_price
- `net_revenue` = quantity × unit_price × (1 − discount)
- `total_cost` = quantity × unit_cost
- `profit` = net_revenue − total_cost

The view has one row per order item.

**Important:** Use distinct order counts when calculating orders from this view to avoid counting an order multiple times.
