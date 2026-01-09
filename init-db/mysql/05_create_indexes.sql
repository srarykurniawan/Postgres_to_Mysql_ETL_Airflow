-- INDEKS TAMBAHAN UNTUK OPTIMASI PERFORMANCE

-- Indeks untuk dim_customers
CREATE INDEX IF NOT EXISTS idx_dim_customers_name ON dim_customers(name);
CREATE INDEX IF NOT EXISTS idx_dim_customers_phone ON dim_customers(phone);

-- Indeks untuk dim_products
CREATE INDEX IF NOT EXISTS idx_dim_products_price ON dim_products(price);
CREATE INDEX IF NOT EXISTS idx_dim_products_margin ON dim_products(margin_percentage);
CREATE INDEX IF NOT EXISTS idx_dim_products_supplier_city ON dim_products(supplier_city);

-- Indeks untuk fact_orders
CREATE INDEX IF NOT EXISTS idx_fact_orders_customer_date 
    ON fact_orders(customer_id, order_date);
    
CREATE INDEX IF NOT EXISTS idx_fact_orders_product_date 
    ON fact_orders(product_id, order_date);
    
CREATE INDEX IF NOT EXISTS idx_fact_orders_date_status 
    ON fact_orders(order_date, status);

-- Indeks composite untuk query analitik
CREATE INDEX IF NOT EXISTS idx_fact_orders_analytics 
    ON fact_orders(customer_id, product_id, order_date, status, total_amount);