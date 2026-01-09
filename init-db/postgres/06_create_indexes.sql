-- INDEKS UNTUK TABEL ORDERS
CREATE INDEX IF NOT EXISTS idx_orders_customer_id ON raw_data.orders(customer_id);
CREATE INDEX IF NOT EXISTS idx_orders_order_date ON raw_data.orders(order_date);
CREATE INDEX IF NOT EXISTS idx_orders_status ON raw_data.orders(order_status);
CREATE INDEX IF NOT EXISTS idx_orders_payment_method ON raw_data.orders(payment_method);

-- INDEKS UNTUK TABEL PRODUCTS
CREATE INDEX IF NOT EXISTS idx_products_category ON raw_data.products(product_category);
CREATE INDEX IF NOT EXISTS idx_products_brand ON raw_data.products(brand);
CREATE INDEX IF NOT EXISTS idx_products_price ON raw_data.products(price);
CREATE INDEX IF NOT EXISTS idx_products_created ON raw_data.products(created_at);

-- INDEKS UNTUK TABEL SUPPLIERS
CREATE INDEX IF NOT EXISTS idx_suppliers_city ON raw_data.suppliers(supplier_city);
CREATE INDEX IF NOT EXISTS idx_suppliers_created ON raw_data.suppliers(created_at);
CREATE INDEX IF NOT EXISTS idx_suppliers_name ON raw_data.suppliers(supplier_name);

-- INDEKS UNTUK TABEL CUSTOMERS
CREATE INDEX IF NOT EXISTS idx_customers_city ON raw_data.customers(customer_city);
CREATE INDEX IF NOT EXISTS idx_customers_state ON raw_data.customers(state);
CREATE INDEX IF NOT EXISTS idx_customers_created ON raw_data.customers(updated_at);

-- Grant privileges on indexes to ETL user
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA raw_data TO etl_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA raw_data TO etl_user;