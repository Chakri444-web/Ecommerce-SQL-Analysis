CREATE DATABASE ecommerce_analysis;

USE ecommerce_analysis;
SELECT DATABASE();
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    city VARCHAR(50),
    country VARCHAR(50)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2),
    stock INT
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    status VARCHAR(30),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
SHOW TABLES;

INSERT INTO customers VALUES
(1, 'Rahul', 'rahul@gmail.com', 'Hyderabad', 'India'),
(2, 'Priya', 'priya@gmail.com', 'Chennai', 'India'),
(3, 'Arjun', 'arjun@gmail.com', 'Bangalore', 'India'),
(4, 'Sneha', 'sneha@gmail.com', 'Mumbai', 'India'),
(5, 'Kiran', 'kiran@gmail.com', 'Delhi', 'India'),
(6, 'Ananya', 'ananya@gmail.com', 'Pune', 'India');

INSERT INTO products VALUES
(101, 'Laptop', 'Electronics', 60000, 20),
(102, 'Phone', 'Electronics', 30000, 50),
(103, 'Headphones', 'Electronics', 3000, 100),
(104, 'Keyboard', 'Accessories', 2000, 80),
(105, 'Mouse', 'Accessories', 1000, 120),
(106, 'Backpack', 'Fashion', 2500, 60);

INSERT INTO orders VALUES
(1001, 1, '2026-01-10', 63000, 'Completed'),
(1002, 2, '2026-01-15', 30000, 'Completed'),
(1003, 3, '2026-02-05', 5000, 'Completed'),
(1004, 1, '2026-02-20', 30000, 'Completed'),
(1005, 4, '2026-03-01', 2500, 'Pending'),
(1006, 5, '2026-03-10', 60000, 'Completed'),
(1007, 2, '2026-03-15', 4000, 'Completed');

INSERT INTO order_items VALUES
(1, 1001, 101, 1, 60000),
(2, 1001, 103, 1, 3000),
(3, 1002, 102, 1, 30000),
(4, 1003, 104, 1, 2000),
(5, 1003, 105, 3, 1000),
(6, 1004, 102, 1, 30000),
(7, 1005, 106, 1, 2500),
(8, 1006, 101, 1, 60000),
(9, 1007, 104, 2, 2000);

SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM order_items;

SELECT product_name, category, price
FROM products
WHERE price > 2000
ORDER BY price DESC;

SELECT category,
       COUNT(*) AS total_products,
       AVG(price) AS average_price,
       SUM(stock) AS total_stock
FROM products
GROUP BY category;


SELECT c.customer_name,
       o.order_id,
       o.order_date,
       o.total_amount
FROM customers c
INNER JOIN orders o
ON c.customer_id = o.customer_id;

SELECT c.customer_name,
       o.order_id,
       o.total_amount
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id;


SELECT c.customer_name,
       o.order_id,
       o.total_amount
FROM customers c
RIGHT JOIN orders o
ON c.customer_id = o.customer_id;

SELECT customer_name
FROM customers
WHERE customer_id IN (
    SELECT customer_id
    FROM orders
    WHERE total_amount > (
        SELECT AVG(total_amount)
        FROM orders
    )
);


CREATE VIEW customer_sales AS
SELECT c.customer_id,
       c.customer_name,
       SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;


SELECT *
FROM customer_sales
ORDER BY total_spent DESC;

CREATE INDEX idx_orders_customer
ON orders(customer_id);

EXPLAIN
SELECT *
FROM orders
WHERE customer_id = 1;

