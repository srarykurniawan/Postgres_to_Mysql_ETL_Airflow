-- 2. TABEL ORDERS
CREATE TABLE IF NOT EXISTS raw_data.orders (
    order_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(10),
    order_date DATE NOT NULL DEFAULT CURRENT_DATE,
    order_status VARCHAR(20) NOT NULL,
    payment_method VARCHAR(30),
    total_amount DECIMAL(12,2) NOT NULL,
    
    -- Foreign key constraint ke tabel customer
    CONSTRAINT fk_customer 
        FOREIGN KEY (customer_id) 
        REFERENCES raw_data.customers (customer_id)
        ON DELETE SET NULL,
    
    -- Constraints
    CONSTRAINT chk_order_status CHECK (order_status IN ('pending', 'processing', 'shipped', 'delivered', 'cancelled')),
    CONSTRAINT chk_total_amount CHECK (total_amount >= 0),
    CONSTRAINT chk_order_date CHECK (order_date <= CURRENT_DATE)
);

COMMENT ON TABLE raw_data.orders IS 'Tabel data pesanan';
COMMENT ON COLUMN raw_data.orders.order_status IS 'Status pesanan: pending, processing, shipped, delivered, cancelled';