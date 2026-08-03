CREATE TABLE superstore_sales (
    row_id INT,
    order_id VARCHAR(50),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(50),
    customer_id VARCHAR(50),
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    country VARCHAR(100),
    city VARCHAR(100),
    state VARCHAR(100),
    postal_code INT,
    region VARCHAR(50),
    product_id VARCHAR(50),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name TEXT,
    sales NUMERIC,
    quantity INT,
    discount NUMERIC,
    profit NUMERIC
);

SELECT COUNT(*) AS total_records
FROM superstore_sales;
SELECT SUM(sales) AS total_sales
FROM superstore_sales;

SELECT SUM(profit) AS total_profit
FROM superstore_sales;

SELECT COUNT(DISTINCT order_id) AS total_orders
FROM superstore_sales;

SELECT category, SUM(sales) AS total_sales
FROM superstore_sales
GROUP BY category
ORDER BY total_sales DESC;

SELECT region, SUM(sales) AS total_sales
FROM superstore_sales
GROUP BY region
ORDER BY total_sales DESC;

SELECT customer_name, SUM(sales) AS total_sales
FROM superstore_sales
GROUP BY customer_name
ORDER BY total_sales DESC
LIMIT 10;

SELECT product_name, SUM(sales) AS total_sales
FROM superstore_sales
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 10;

SELECT category, SUM(profit) AS total_profit
FROM superstore_sales
GROUP BY category
ORDER BY total_profit DESC;

SELECT region, SUM(profit) AS total_profit
FROM superstore_sales
GROUP BY region
ORDER BY total_profit DESC;

SELECT sub_category, SUM(profit) AS total_profit
FROM superstore_sales
GROUP BY sub_category
ORDER BY total_profit DESC;

SELECT customer_name, SUM(profit) AS total_profit
FROM superstore_sales
GROUP BY customer_name
ORDER BY total_profit DESC
LIMIT 10;

SELECT product_name, SUM(profit) AS total_profit
FROM superstore_sales
GROUP BY product_name
ORDER BY total_profit DESC
LIMIT 10;