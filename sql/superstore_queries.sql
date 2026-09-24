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

SELECT
    DATE_TRUNC('month', TO_DATE(order_date, 'MM/DD/YYYY')) AS month,
    ROUND(SUM(sales)::numeric, 2) AS monthly_sales,
    ROUND(SUM(profit)::numeric, 2) AS monthly_profit
FROM superstore_sales
GROUP BY DATE_TRUNC('month', TO_DATE(order_date, 'MM/DD/YYYY'))
ORDER BY month;

WITH monthly_sales AS (
    SELECT
        DATE_TRUNC(
            'month',
            TO_DATE(order_date, 'MM/DD/YYYY')
        ) AS month,
        SUM(sales) AS total_sales
    FROM superstore_sales
    GROUP BY DATE_TRUNC(
        'month',
        TO_DATE(order_date, 'MM/DD/YYYY')
    )
),
sales_growth AS (
    SELECT
        month,
        total_sales,
        LAG(total_sales) OVER (ORDER BY month) AS previous_month_sales
    FROM monthly_sales
)
SELECT
    month,
    ROUND(total_sales::numeric, 2) AS total_sales,
    ROUND(previous_month_sales::numeric, 2) AS previous_month_sales,
    ROUND(
        (
            (total_sales - previous_month_sales)
            / NULLIF(previous_month_sales, 0)
        )::numeric * 100,
        2
    ) AS mom_growth_percentage
FROM sales_growth
ORDER BY month;

SELECT
    category,
    sub_category,
    ROUND(SUM(sales)::numeric, 2) AS total_sales,
    ROUND(SUM(profit)::numeric, 2) AS total_profit
FROM superstore_sales
GROUP BY category, sub_category
ORDER BY total_profit DESC;

SELECT
    category,
    ROUND(SUM(sales)::numeric, 2) AS total_sales,
    ROUND(SUM(profit)::numeric, 2) AS total_profit,
    ROUND(
        (SUM(profit) / NULLIF(SUM(sales), 0))::numeric * 100,
        2
    ) AS profit_margin_percentage
FROM superstore_sales
GROUP BY category
ORDER BY profit_margin_percentage DESC;


WITH customer_sales AS (
    SELECT
        customer_name,
        SUM(sales) AS total_sales
    FROM superstore_sales
    GROUP BY customer_name
)
SELECT
    customer_name,
    ROUND(total_sales::numeric, 2) AS total_sales,
    DENSE_RANK() OVER (
        ORDER BY total_sales DESC
    ) AS sales_rank
FROM customer_sales
ORDER BY sales_rank;


SELECT
    product_name,
    ROUND(SUM(sales)::numeric, 2) AS total_sales,
    ROUND(SUM(profit)::numeric, 2) AS total_profit
FROM superstore_sales
GROUP BY product_name
HAVING SUM(profit) < 0
ORDER BY total_profit ASC;


SELECT
    CASE
        WHEN discount = 0 THEN 'No Discount'
        WHEN discount <= 0.20 THEN 'Low Discount'
        WHEN discount <= 0.40 THEN 'Medium Discount'
        ELSE 'High Discount'
    END AS discount_category,
    ROUND(SUM(sales)::numeric, 2) AS total_sales,
    ROUND(SUM(profit)::numeric, 2) AS total_profit,
    ROUND(AVG(discount)::numeric * 100, 2) AS avg_discount_percentage
FROM superstore_sales
GROUP BY
    CASE
        WHEN discount = 0 THEN 'No Discount'
        WHEN discount <= 0.20 THEN 'Low Discount'
        WHEN discount <= 0.40 THEN 'Medium Discount'
        ELSE 'High Discount'
    END
ORDER BY avg_discount_percentage;


WITH monthly_sales AS (
    SELECT
        DATE_TRUNC(
            'month',
            TO_DATE(order_date, 'MM/DD/YYYY')
        ) AS month,
        SUM(sales) AS monthly_sales
    FROM superstore_sales
    GROUP BY DATE_TRUNC(
        'month',
        TO_DATE(order_date, 'MM/DD/YYYY')
    )
)
SELECT
    month,
    ROUND(monthly_sales::numeric, 2) AS monthly_sales,
    ROUND(
        SUM(monthly_sales) OVER (
            ORDER BY month
        )::numeric,
        2
    ) AS cumulative_sales
FROM monthly_sales
ORDER BY month;


SELECT
    sub_category,
    ROUND(SUM(sales)::numeric, 2) AS total_sales,
    ROUND(SUM(profit)::numeric, 2) AS total_profit,
    ROUND(
        (SUM(profit) / NULLIF(SUM(sales), 0))::numeric * 100,
        2
    ) AS profit_margin_percentage
FROM superstore_sales
GROUP BY sub_category
ORDER BY total_profit DESC;


SELECT
    segment,
    ROUND(SUM(sales)::numeric, 2) AS total_sales,
    ROUND(SUM(profit)::numeric, 2) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders
FROM superstore_sales
GROUP BY segment
ORDER BY total_sales DESC;