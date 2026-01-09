-- SAMPLE DATA UNTUK DATA WAREHOUSE
-- Data akan diisi oleh proses ETL, ini hanya contoh untuk testing

-- Sample data dim_customers (dimapping dari PostgreSQL)
INSERT INTO dim_customers (customer_id, name, phone, state, city) VALUES
(1, 'John Doe', '08123456789', 'DKI Jakarta', 'Jakarta'),
(2, 'Jane Smith', '08234567890', 'Jawa Barat', 'Bandung'),
(3, 'Bob Johnson', '08345678901', 'Jawa Timur', 'Surabaya'),
(4, 'Alice Brown', '08456789012', 'Sumatera Utara', 'Medan'),
(5, 'Charlie Wilson', '08567890123', 'Jawa Tengah', 'Semarang')
ON DUPLICATE KEY UPDATE 
    name = VALUES(name),
    phone = VALUES(phone),
    state = VALUES(state),
    city = VALUES(city),
    updated_at = CURRENT_TIMESTAMP;

-- Sample data dim_products (dimapping dari PostgreSQL)
INSERT INTO dim_products (product_id, product_name, category, brand, price, cost, supplier_name, supplier_city) VALUES
(1, 'Laptop ASUS ROG', 'Elektronik', 'ASUS', 15000000, 12000000, 'PT Elektronik Maju', 'Jakarta'),
(2, 'Mouse Wireless Logitech', 'Elektronik', 'Logitech', 250000, 180000, 'PT Elektronik Maju', 'Jakarta'),
(3, 'Keyboard Mechanical', 'Elektronik', 'Razer', 1200000, 900000, 'UD Tekno Gadget', 'Surabaya'),
(4, 'Kemeja Casual', 'Fashion', 'UNIQLO', 299000, 200000, 'CV Fashion Indonesia', 'Bandung'),
(5, 'Sepatu Sneakers', 'Fashion', 'Nike', 1500000, 1000000, 'CV Fashion Indonesia', 'Bandung')
ON DUPLICATE KEY UPDATE 
    product_name = VALUES(product_name),
    category = VALUES(category),
    brand = VALUES(brand),
    price = VALUES(price),
    cost = VALUES(cost),
    supplier_name = VALUES(supplier_name),
    supplier_city = VALUES(supplier_city),
    updated_at = CURRENT_TIMESTAMP;

-- Sample data fact_orders (dimapping dari PostgreSQL)
INSERT INTO fact_orders (order_id, customer_id, product_id, order_date, status, quantity, unit_price, total_amount, payment_method) VALUES
(1, 1, 1, '2024-01-15', 'delivered', 1, 15000000, 15000000, 'Credit Card'),
(2, 2, 4, '2024-01-16', 'shipped', 1, 299000, 299000, 'Bank Transfer'),
(3, 3, 3, '2024-01-17', 'processing', 1, 1200000, 1200000, 'E-Wallet'),
(4, 1, 4, '2024-01-18', 'pending', 2, 299000, 598000, 'Credit Card'),
(5, 4, 5, '2024-01-19', 'delivered', 1, 1500000, 1500000, 'Cash on Delivery')
ON DUPLICATE KEY UPDATE 
    customer_id = VALUES(customer_id),
    product_id = VALUES(product_id),
    order_date = VALUES(order_date),
    status = VALUES(status),
    quantity = VALUES(quantity),
    unit_price = VALUES(unit_price),
    total_amount = VALUES(total_amount),
    payment_method = VALUES(payment_method),
    updated_at = CURRENT_TIMESTAMP;