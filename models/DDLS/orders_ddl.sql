CREATE OR REPLACE TABLE <dataset_name>.orders (
  order_id INT64,
  customer_id INT64,
  product_name STRING,
  category STRING,
  order_date DATE,
  quantity INT64,
  price FLOAT64,
  total_amount FLOAT64,
  city STRING,
  payment_mode STRING
);

INSERT INTO <dataset_name>.orders VALUES
(1, 101, 'Laptop', 'Electronics', '2026-04-01', 1, 75000, 75000, 'Mumbai', 'UPI'),
(2, 102, 'Mobile', 'Electronics', '2026-04-02', 2, 20000, 40000, 'Delhi', 'Card'),
(3, 103, 'Shoes', 'Fashion', '2026-04-03', 1, 3000, 3000, 'Bangalore', 'Cash'),
(4, 104, 'Watch', 'Accessories', '2026-04-04', 1, 5000, 5000, 'Pune', 'UPI'),
(5, 105, 'Headphones', 'Electronics', '2026-04-05', 2, 1500, 3000, 'Chennai', 'Card'),
(6, 106, 'T-shirt', 'Fashion', '2026-04-06', 3, 800, 2400, 'Hyderabad', 'UPI'),
(7, 107, 'Backpack', 'Accessories', '2026-04-07', 1, 2500, 2500, 'Kolkata', 'Cash'),
(8, 108, 'Tablet', 'Electronics', '2026-04-08', 1, 30000, 30000, 'Mumbai', 'Card'),
(9, 109, 'Jeans', 'Fashion', '2026-04-09', 2, 2000, 4000, 'Delhi', 'UPI'),
(10, 110, 'Camera', 'Electronics', '2026-04-10', 1, 45000, 45000, 'Bangalore', 'Card'),
(11, 111, 'Sunglasses', 'Accessories', '2026-04-11', 2, 1200, 2400, 'Pune', 'Cash'),
(12, 112, 'Smartwatch', 'Electronics', '2026-04-12', 1, 10000, 10000, 'Chennai', 'UPI'),
(13, 113, 'Jacket', 'Fashion', '2026-04-13', 1, 3500, 3500, 'Hyderabad', 'Card'),
(14, 114, 'Keyboard', 'Electronics', '2026-04-14', 2, 1500, 3000, 'Kolkata', 'UPI'),
(15, 115, 'Mouse', 'Electronics', '2026-04-15', 3, 700, 2100, 'Mumbai', 'Cash'),
(16, 116, 'Dress', 'Fashion', '2026-04-16', 1, 4000, 4000, 'Delhi', 'Card'),
(17, 117, 'Charger', 'Electronics', '2026-04-17', 2, 1000, 2000, 'Bangalore', 'UPI'),
(18, 118, 'Perfume', 'Accessories', '2026-04-18', 1, 2500, 2500, 'Pune', 'Cash'),
(19, 119, 'Speaker', 'Electronics', '2026-04-19', 1, 5000, 5000, 'Chennai', 'Card'),
(20, 120, 'Cap', 'Fashion', '2026-04-20', 2, 600, 1200, 'Hyderabad', 'UPI');
