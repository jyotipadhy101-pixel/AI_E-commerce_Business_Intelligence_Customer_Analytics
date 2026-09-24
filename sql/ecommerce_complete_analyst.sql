SELECT * FROM superstore_sales
LIMIT 1000

CREATE TABLE customer_analytics AS
SELECT
    customer_id,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    ROUND(SUM(sales) / COUNT(DISTINCT order_id), 2) AS avg_order_value,
    MAX(order_date) AS last_order_date
FROM superstore_sales
GROUP BY customer_id;

SELECT * FROM customer_analytics
LIMIT 10;

UPDATE customer_analytics
SET recency_days =
    (SELECT MAX(order_date)::DATE
     FROM superstore_sales)
    - last_order_date;

SELECT
    customer_id,
    last_order_date,
    recency_days
FROM customer_analytics
LIMIT 10;

UPDATE customer_analytics
SET recency_days =
    (SELECT MAX(order_date)::DATE
     FROM superstore_sales)
    - last_order_date;

SELECT
    customer_id,
    last_order_date,
    recency_days
FROM customer_analytics
LIMIT 10;

SELECT
    customer_id,
    total_orders,
    total_sales,
    recency_days,
    CASE
        WHEN recency_days <= 90
             AND total_orders >= 5
             AND total_sales >= 1000
            THEN 'High Value Active'

        WHEN recency_days <= 180
             AND total_orders >= 3
            THEN 'Loyal Customer'

        WHEN recency_days > 365
             AND total_orders >= 2
            THEN 'At Risk'

        WHEN recency_days > 730
            THEN 'Lost Customer'

        ELSE 'Regular Customer'
    END AS customer_segment
FROM customer_analytics;

SELECT
    CASE
        WHEN recency_days <= 90
             AND total_orders >= 5
             AND total_sales >= 1000
            THEN 'High Value Active'
        WHEN recency_days <= 180
             AND total_orders >= 3
            THEN 'Loyal Customer'
        WHEN recency_days > 365
             AND total_orders >= 2
            THEN 'At Risk'
        WHEN recency_days > 730
            THEN 'Lost Customer'
        ELSE 'Regular Customer'
    END AS customer_segment,
    COUNT(*) AS customer_count,
    ROUND(SUM(total_sales), 2) AS total_revenue
FROM customer_analytics
GROUP BY customer_segment
ORDER BY total_revenue DESC;

ALTER TABLE customer_analytics
ADD COLUMN customer_lifetime_value NUMERIC(12,2);

UPDATE customer_analytics
SET customer_lifetime_value =
    total_sales / NULLIF(total_orders, 0);

SELECT
    customer_id,
    total_orders,
    ROUND(total_sales, 2) AS total_sales,
    customer_lifetime_value,
    recency_days
FROM customer_analytics
ORDER BY customer_lifetime_value DESC
LIMIT 10;

SELECT
    CASE
        WHEN total_orders = 1 THEN 'One-Time Customer'
        WHEN total_orders BETWEEN 2 AND 4 THEN 'Repeat Customer'
        WHEN total_orders >= 5 THEN 'Loyal Customer'
    END AS purchase_type,
    COUNT(*) AS customer_count,
    ROUND(SUM(total_sales), 2) AS total_revenue,
    ROUND(AVG(total_sales), 2) AS avg_customer_revenue
FROM customer_analytics
GROUP BY purchase_type
ORDER BY customer_count DESC;

SELECT
    customer_id,
    total_orders,
    ROUND(total_sales, 2) AS total_sales,
    recency_days,
    customer_lifetime_value
FROM customer_analytics
WHERE recency_days > 365
  AND total_orders >= 2
ORDER BY total_sales DESC;

CREATE TABLE customer_rfm AS
SELECT
    customer_id,
    recency_days,
    total_orders,
    total_sales,

    NTILE(5) OVER (
        ORDER BY recency_days DESC
    ) AS recency_score,

    NTILE(5) OVER (
        ORDER BY total_orders
    ) AS frequency_score,

    NTILE(5) OVER (
        ORDER BY total_sales
    ) AS monetary_score

FROM customer_analytics;

SELECT *
FROM customer_rfm
LIMIT 10;

ALTER TABLE customer_rfm
ADD COLUMN rfm_score INTEGER;

UPDATE customer_rfm
SET rfm_score =
    recency_score
    + frequency_score
    + monetary_score;

SELECT
    customer_id,
    recency_score,
    frequency_score,
    monetary_score,
    rfm_score
FROM customer_rfm
ORDER BY rfm_score DESC
LIMIT 20;

ALTER TABLE customer_rfm
ADD COLUMN customer_segment VARCHAR(30);

UPDATE customer_rfm
SET customer_segment =
    CASE
        WHEN rfm_score >= 13 THEN 'Champions'
        WHEN rfm_score >= 10 THEN 'Loyal Customers'
        WHEN rfm_score >= 7 THEN 'Potential Loyalists'
        WHEN rfm_score >= 5 THEN 'At Risk'
        ELSE 'Lost Customers'
    END;

SELECT
    customer_segment,
    COUNT(*) AS customer_count,
    ROUND(SUM(total_sales), 2) AS total_revenue
FROM customer_rfm
GROUP BY customer_segment
ORDER BY total_revenue DESC;

SELECT
    customer_id,
    recency_days,
    total_orders,
    total_sales,
    recency_score,
    frequency_score,
    monetary_score,
    rfm_score,
    customer_segment
FROM customer_rfm
ORDER BY rfm_score DESC;

SELECT *
FROM customer_rfm
ORDER BY rfm_score DESC
LIMIT 20;