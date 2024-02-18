USE portfolioprojects;
create table customers (
 customer_id int not null primary key,
 customer_name varchar(50) not null,
 email varchar(50),
 shipping_address varchar(80)
);
create table product(
product_id int not null primary key,
product_name varchar(50) not null,
description varchar(80),
price decimal not null,
stock_quantity int
);
create table orders(
order_id int not null primary key,
customer_id int not null,
order_date date not null,
total_amount decimal not null
);
create table order_details(
order_detail_id int not null primary key,
order_id int not null,
product_id int not null,
quantity int not null,
unit_price decimal not null
);

-- Insert sample data into Customers table
INSERT INTO customers (customer_id, customer_name, email, shipping_address)
VALUES
  (1, 'John Smith', 'john.smith@example.com', '123 Main St, Anytown'),
  (2, 'Jane Doe', 'jane.doe@example.com', '456 Elm St, AnotherTown'),
  (3, 'Michael Johnson', 'michael.johnson@example.com', '789 Oak St, Somewhere'),
  (4, 'Emily Wilson', 'emily.wilson@example.com', '567 Pine St, Nowhere'),
  (5, 'David Brown', 'david.brown@example.com', '321 Maple St, Anywhere');

 

-- Insert sample data into Products table
INSERT INTO product (product_id, product_name, description, price, stock_quantity)
VALUES
  (1, 'iPhone X', 'Apple iPhone X, 64GB', 999, 10),
  (2, 'Galaxy S9', 'Samsung Galaxy S9, 128GB', 899, 5),
  (3, 'iPad Pro', 'Apple iPad Pro, 11-inch', 799, 8),
  (4, 'Pixel 4a', 'Google Pixel 4a, 128GB', 499, 12),
  (5, 'MacBook Air', 'Apple MacBook Air, 13-inch', 1099, 3);

 
-- Insert sample data into Orders table
INSERT INTO orders (order_id, customer_id, order_date, total_amount)
VALUES
(1, 1, '2023-01-01', 0),
(2, 2, '2023-02-15', 0),
(3, 3, '2023-03-10', 0),
(4, 4, '2023-04-05', 0),
(5, 5, '2023-05-20', 0);

 

-- Insert sample data into OrderDetails table
INSERT INTO order_details (order_detail_id, order_id, product_id, quantity, unit_price)
VALUES
  (1, 1, 1, 1, 999),
  (2, 2, 2, 1, 899),
  (3, 3, 3, 2, 799),
  (4, 3, 1, 1, 999),
  (5, 4, 4, 1, 499),
  (6, 4, 4, 1, 499),
  (7, 5, 5, 1, 1099),
  (8, 5, 1, 1, 999),
  (9, 5, 3, 1, 799);

 

-- Update total_amount in Orders table
UPDATE orders
JOIN order_details ON order_details.order_id = orders.order_id
SET total_amount = (
  SELECT SUM(quantity * unit_price)
);

USE portfolioprojects;
SELECT orders.order_id,customers.customer_id,customers.customer_name,orders.total_amount
FROM orders
JOIN customers ON orders.customer_id=customers.customer_id
WHERE total_amount>1000;

-- Retrieve the total quantity of each product sold
SELECT od.product_id,p.product_name,SUM(od.quantity) AS total_qty_sold
FROM order_details od
JOIN product p ON od.product_id=p.product_id
GROUP BY od.product_id;

 -- Retrieve the order details for orders with a quantity greater than the average quantity of all orders.
SELECT order_id,product_name,quantity
FROM order_details od
JOIN product p ON od.product_id=p.product_id
WHERE quantity> (SELECT AVG(quantity)
FROM  order_details);

-- Retrieve the order IDs and the number of unique products included in each order.
SELECT order_id,COUNT(DISTINCT(product_id)) AS unique_products
FROM order_details
GROUP BY order_id;

SELECT EXTRACT(MONTH FROM order_date) AS month, SUM(quantity) AS total_products_sold
FROM orders o
JOIN order_details od ON od.order_id=o.order_id
WHERE EXTRACT(YEAR FROM order_date) = 2023 
GROUP BY EXTRACT(MONTH from order_date)
ORDER BY MONTH;

-- Retrieve the total number of products sold for each month in the year 2023 where the total number of products sold were greater than 2.
-- Display the month along with the total number of products
USE portfolioprojects;
SELECT EXTRACT(MONTH FROM order_date) AS month, SUM(quantity) AS total_product_sold
FROM orders o
JOIN order_details od ON o.order_id=od.order_id
WHERE EXTRACT(YEAR FROM order_date)=2023 
GROUP BY EXTRACT(MONTH FROM order_date)
HAVING SUM(quantity) > 2;

-- Retrieve the order IDs and the order amount based on the following criteria:
-- If the total_amount > 1000 then ‘High Value’
-- If it is less than or equal to 1000 then ‘Low Value’
-- Output should be — order IDs, order amount and Value
SELECT order_id, total_amount,
CASE WHEN total_amount>1000 THEN 'HIGH VALUE'
ELSE 'LOW VALUE'
END AS Value;

-- Retrieve the order IDs and the order amount based on the following criteria:
-- If the total_amount > 1000 then ‘High Value’
-- If it is less than 1000 then ‘Low Value’
-- If it is equal to 1000 then ‘Medium Value’
-- Also, please only print the ‘High Value’ products

SELECT order_id,total_amount 
FROM (SELECT order_id,total_amount,
CASE WHEN total_amount >1000 THEN 'High Value'
WHEN total_amount = 1000 THEN 'Medium Value'
ELSE 'Low Value'
END as Value
FROM orders) as sub
WHERE Value ='High Value';
