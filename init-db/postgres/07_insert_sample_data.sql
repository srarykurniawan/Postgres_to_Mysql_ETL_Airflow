-- SAMPLE DATA UNTUK TABEL CUSTOMERS
INSERT INTO raw_data.customers (customer_id, customer_name, customer_city, phone, state, created_at) VALUES
('CUST001', 'John Doe', 'Jakarta', '08123456789', 'DKI Jakarta', '2024-01-10'),
('CUST002', 'Jane Smith', 'Bandung', '08234567890', 'Jawa Barat', '2024-01-11'),
('CUST003', 'Bob Johnson', 'Surabaya', '08345678901', 'Jawa Timur', '2024-01-12'),
('CUST004', 'Alice Brown', 'Medan', '08456789012', 'Sumatera Utara', '2024-01-13'),
('CUST005', 'Charlie Wilson', 'Semarang', '08567890123', 'Jawa Tengah', '2024-01-14')
ON CONFLICT (customer_id) DO NOTHING;

-- SAMPLE DATA UNTUK TABEL PRODUCTS
INSERT INTO raw_data.products (product_id, product_name, product_category, brand, price, created_at) VALUES
('PROD001', 'Laptop ASUS ROG', 'Elektronik', 'ASUS', 15000000, '2024-01-01'),
('PROD002', 'Mouse Wireless Logitech', 'Elektronik', 'Logitech', 250000, '2024-01-02'),
('PROD003', 'Keyboard Mechanical', 'Elektronik', 'Razer', 1200000, '2024-01-03'),
('PROD004', 'Kemeja Casual', 'Fashion', 'UNIQLO', 299000, '2024-01-04'),
('PROD005', 'Sepatu Sneakers', 'Fashion', 'Nike', 1500000, '2024-01-05')
ON CONFLICT (product_id) DO NOTHING;

-- SAMPLE DATA UNTUK TABEL SUPPLIERS
INSERT INTO raw_data.suppliers (supplier_id, supplier_name, supplier_city, phone, email, created_at) VALUES
('SUPP001', 'PT Elektronik Maju', 'Jakarta', '0211234567', 'info@elektronikmaju.com', '2024-01-01'),
('SUPP002', 'CV Fashion Indonesia', 'Bandung', '0227654321', 'contact@fashionindonesia.co.id', '2024-01-02'),
('SUPP003', 'UD Tekno Gadget', 'Surabaya', '0319876543', 'sales@teknogadget.com', '2024-01-03')
ON CONFLICT (supplier_id) DO NOTHING;

-- SAMPLE DATA UNTUK TABEL ORDERS
INSERT INTO raw_data.orders (order_id, customer_id, order_date, order_status, payment_method, total_amount) VALUES
('ORD001', 'CUST001', '2024-01-15', 'delivered', 'Credit Card', 15250000),
('ORD002', 'CUST002', '2024-01-16', 'shipped', 'Bank Transfer', 1799000),
('ORD003', 'CUST003', '2024-01-17', 'processing', 'E-Wallet', 1200000),
('ORD004', 'CUST001', '2024-01-18', 'pending', 'Credit Card', 299000),
('ORD005', 'CUST004', '2024-01-19', 'delivered', 'Cash on Delivery', 1500000)
ON CONFLICT (order_id) DO NOTHING;