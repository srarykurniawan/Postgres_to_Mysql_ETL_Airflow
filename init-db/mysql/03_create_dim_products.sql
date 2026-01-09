-- DIMENSI PRODUCTS
CREATE TABLE IF NOT EXISTS dim_products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    category VARCHAR(100) NOT NULL,
    brand VARCHAR(50), -- Ditambahkan untuk konsistensi dengan source
    price DECIMAL(12,2) NOT NULL,
    cost DECIMAL(12,2) NOT NULL,
    margin_percentage DECIMAL(5,2) GENERATED ALWAYS AS (
        CASE 
            WHEN cost > 0 THEN ROUND(((price - cost) / cost) * 100, 2)
            ELSE 0 
        END
    ) STORED,
    supplier_name VARCHAR(150),
    supplier_city VARCHAR(50), -- Ditambahkan untuk informasi supplier
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT chk_price_positive CHECK (price >= 0),
    CONSTRAINT chk_cost_positive CHECK (cost >= 0),
    INDEX idx_products_category (category),
    INDEX idx_products_brand (brand),
    INDEX idx_products_supplier (supplier_name),
    INDEX idx_products_updated (updated_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Komentar tabel
ALTER TABLE dim_products COMMENT = 'Tabel dimensi untuk data produk dengan perhitungan margin otomatis';