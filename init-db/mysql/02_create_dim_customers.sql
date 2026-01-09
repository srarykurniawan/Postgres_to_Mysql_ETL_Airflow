-- DIMENSI CUSTOMERS
CREATE TABLE IF NOT EXISTS dim_customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(30),
    state VARCHAR(50),
    city VARCHAR(50), -- Ditambahkan untuk konsistensi dengan source
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Constraints
    INDEX idx_customers_state (state),
    INDEX idx_customers_city (city),
    INDEX idx_customers_updated (updated_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Komentar tabel
ALTER TABLE dim_customers COMMENT = 'Tabel dimensi untuk data pelanggan';