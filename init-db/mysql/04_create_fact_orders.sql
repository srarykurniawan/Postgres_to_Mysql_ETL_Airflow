-- FAKTA ORDERS
CREATE TABLE IF NOT EXISTS fact_orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    product_id INT NOT NULL, -- Ditambahkan untuk menghubungkan ke produk
    order_date DATE NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'pending',
    quantity INT NOT NULL DEFAULT 1, -- Ditambahkan untuk kuantitas
    unit_price DECIMAL(12,2) NOT NULL,
    total_amount DECIMAL(14,2) NOT NULL,
    payment_method VARCHAR(30),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Foreign key constraints
    CONSTRAINT fk_fact_orders_customer 
        FOREIGN KEY (customer_id) 
        REFERENCES dim_customers(customer_id)
        ON DELETE CASCADE,
    
    CONSTRAINT fk_fact_orders_product 
        FOREIGN KEY (product_id) 
        REFERENCES dim_products(product_id)
        ON DELETE CASCADE,
    
    -- Constraints
    CONSTRAINT chk_total_amount_positive CHECK (total_amount >= 0),
    CONSTRAINT chk_quantity_positive CHECK (quantity > 0),
    CONSTRAINT chk_unit_price_positive CHECK (unit_price >= 0),
    
    -- Indexes
    INDEX idx_orders_customer (customer_id),
    INDEX idx_orders_product (product_id),
    INDEX idx_orders_date (order_date),
    INDEX idx_orders_status (status),
    INDEX idx_orders_payment (payment_method),
    INDEX idx_orders_updated (updated_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Komentar tabel
ALTER TABLE fact_orders COMMENT = 'Tabel fakta untuk data pesanan/transaksi';