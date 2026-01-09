-- 3. TABEL PRODUCTS
CREATE TABLE IF NOT EXISTS raw_data.products (
    product_id VARCHAR(20) PRIMARY KEY,
    product_name VARCHAR(200) NOT NULL,
    product_category VARCHAR(50) NOT NULL,
    brand VARCHAR(50),
    price DECIMAL(10,2) NOT NULL,
    created_at DATE DEFAULT CURRENT_DATE,
    
    -- Constraints
    CONSTRAINT chk_price CHECK (price >= 0),
    CONSTRAINT chk_product_name CHECK (product_name IS NOT NULL AND product_name != ''),
    CONSTRAINT chk_product_category CHECK (product_category IS NOT NULL AND product_category != ''),
    CONSTRAINT chk_created_at_products CHECK (created_at <= CURRENT_DATE)
);