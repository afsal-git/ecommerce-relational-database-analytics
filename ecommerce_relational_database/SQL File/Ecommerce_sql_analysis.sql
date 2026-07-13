-- ========================================================
-- RESET & MASTER BUILD (RUN ALL AT ONCE)
-- ========================================================
USE ecommerce_analytics;

-- 1. Clean up any remnants from previous failed runs
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS users;

-- 2. Create the Users table and fix data type for Primary Key
CREATE TABLE users AS 
SELECT DISTINCT User_ID FROM ecommerce_dataset_updated;

ALTER TABLE users MODIFY COLUMN User_ID VARCHAR(50);
ALTER TABLE users ADD PRIMARY KEY (User_ID);


-- 3. Create the Products table and fix data type for Primary Key
CREATE TABLE products AS 
SELECT DISTINCT Product_ID, Category, `Price (Rs.)` AS price_rs
FROM ecommerce_dataset_updated;

ALTER TABLE products MODIFY COLUMN Product_ID VARCHAR(50);
ALTER TABLE products ADD PRIMARY KEY (Product_ID);


-- 4. Create the Orders transaction table with matching data types
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id VARCHAR(50),
    product_id VARCHAR(50),
    discount_percent INT,
    final_price_rs DECIMAL(10,2),
    payment_method VARCHAR(50),
    purchase_date VARCHAR(50), 
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- 5. Populate the Orders table from your raw staging data
INSERT INTO orders (user_id, product_id, discount_percent, final_price_rs, payment_method, purchase_date)
SELECT User_ID, Product_ID, `Discount (%)`, `Final_Price(Rs.)`, Payment_Method, Purchase_Date 
FROM ecommerce_dataset_updated;

-- ========================================================
-- STEP 2: ANALYTICAL QUERIES (RUN ONE BY ONE)
-- ========================================================

-- Query 1: Basic Filtering and Sorting (Fulfills SELECT, WHERE, ORDER BY)
-- Finds premium items in key lifestyle departments priced over 400 Rs.
SELECT product_id, category, price_rs 
FROM products 
WHERE category IN ('Sports', 'Beauty', 'Clothing') AND price_rs > 400.00
ORDER BY price_rs DESC;



-- Query 2: Segment Revenue Breakdown (Fulfills INNER JOIN, GROUP BY, Aggregates)
-- Merges relational tables to evaluate order volumes, gross revenue, and average discounts per category.
SELECT 
    p.category,
    COUNT(o.order_id) AS total_orders_placed,
    SUM(o.final_price_rs) AS gross_revenue_rs,
    ROUND(AVG(o.discount_percent), 2) AS average_discount_given
FROM orders o
INNER JOIN products p ON o.product_id = p.product_id
GROUP BY p.category -- Fixed: Added 'BY' here
ORDER BY gross_revenue_rs DESC;



-- Query 3: Identifying VIP Customers (Fulfills Subqueries)
-- Uses an inner subquery to isolate users whose spending is higher than the storewide average customer expenditure.
SELECT user_id, SUM(final_price_rs) AS customer_total_spend
FROM orders
GROUP BY user_id
HAVING customer_total_spend > (
    SELECT AVG(user_average) 
    FROM (
        SELECT SUM(final_price_rs) AS user_average 
        FROM orders 
        GROUP BY user_id
    ) AS underlying_averages
)
ORDER BY customer_total_spend DESC;



-- Query 4: Saving Business Intelligence Infrastructure (Fulfills CREATE VIEW)
-- Creates an abstracted reporting layer tracking performance broken down by payment methods.
CREATE VIEW view_payment_mode_metrics AS
SELECT 
    payment_method,
    COUNT(*) AS total_transactions,
    SUM(final_price_rs) AS aggregate_sales_volume,
    ROUND(AVG(final_price_rs), 2) AS average_basket_value
FROM orders
GROUP BY payment_method;

-- Run this line separately right after creating the view to take your 4th screenshot:
SELECT * FROM view_payment_mode_metrics;



-- Query 5: Performance Engineering Optimization (Fulfills INDEXES)
-- Optimizes table lookup processing times across relational map fields.
CREATE INDEX idx_order_product_mapping ON orders(product_id);