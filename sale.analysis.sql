CREATE TABLE customers (
    customer_id VARCHAR(20) PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    age INT,
    gender VARCHAR(20),
    segment VARCHAR(50)
);
CREATE TABLE products (
    product_id VARCHAR(20) PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    price NUMERIC(12,2)
);

CREATE TABLE orders (
    order_id VARCHAR(20) PRIMARY KEY,
    order_date DATE,
    customer_id VARCHAR(20),
    product_id VARCHAR(20),
    quantity INT,
    discount NUMERIC(5,2),
    sales NUMERIC(14,2),
    profit NUMERIC(14,2)
);

select *from customers;
select *from products;
select *from orders;
--1 total customers
SELECT COUNT(*) 
FROM customers;

--2 Total Products
SELECT COUNT(*)
FROM products;

--3 Total Orders
SELECT COUNT(*)
FROM orders;

--4 Duplicate Orders
SELECT order_id, COUNT(*)
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

--5 Null values
SELECT *
FROM orders
WHERE customer_id IS NULL
   OR product_id IS NULL;


-- sql joins
SELECT
    o.order_id,
    o.order_date,
    c.customer_name,
    c.city,
    c.state,
    c.segment,
    p.product_name,
    p.category,
    p.sub_category,
    o.quantity,
    o.discount,
    o.sales,
    o.profit
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
JOIN products p
    ON o.product_id = p.product_id;

-- SQL KPI Analysis
--1 Total Sales
SELECT SUM(sales) AS total_sales
FROM orders;

--2 Total Profit
SELECT SUM(profit) AS total_profit
FROM orders;

--3 Total Orders
SELECT COUNT(DISTINCT order_id) AS total_orders
FROM orders;

--4 Total Quantity
SELECT SUM(quantity) AS total_quantity
from orders;

 --5 Profit Margin
SELECT
    SUM(profit) / NULLIF(SUM(sales),0) * 100 AS profit_margin
FROM orders;

--6 AOV
SELECT
    SUM(sales) / COUNT(DISTINCT order_id) AS AOV
FROM orders;
--sql bussines analysis
--1 State-wise Sales
SELECT
    c.state,
    SUM(o.sales) AS total_sales
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.state
ORDER BY total_sales DESC;
--2 Category-wise Performance
SELECT
    p.category,
    SUM(o.sales) AS sales,
    SUM(o.profit) AS profit
FROM orders o
JOIN products p
ON o.product_id = p.product_id
GROUP BY p.category;

--3 Segment Performance
SELECT
    c.segment,
    SUM(o.sales) AS sales,
    SUM(o.profit) AS profit
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.segment;
--4 Top 10 Products
SELECT
    p.product_name,
    SUM(o.sales) AS total_sales
FROM orders o
JOIN products p
ON o.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sales DESC
LIMIT 10;

--5  Top 10 Customers
SELECT
    c.customer_name,
    SUM(o.sales) AS total_sales
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY total_sales DESC
LIMIT 10;

--1 High Profit Orders
SELECT *
FROM orders
WHERE profit > 20000;
--2 Discount > 15%
SELECT *
FROM orders
WHERE discount > 0.15;
--3 Monthly Sales
SELECT
    DATE_TRUNC('month', order_date) AS month,
    SUM(sales) AS sales
FROM orders
GROUP BY month
ORDER BY month;

--4 Category Profit Margin
SELECT
    p.category,
    SUM(o.profit) AS profit,
    SUM(o.sales) AS sales,
    ROUND(
        SUM(o.profit) / NULLIF(SUM(o.sales),0) * 100,
        2
    ) AS profit_margin
FROM orders o
JOIN products p
ON o.product_id = p.product_id
GROUP BY p.category;