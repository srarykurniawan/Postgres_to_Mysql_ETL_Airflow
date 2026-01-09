-- 4. TABEL SUPPLIERS
CREATE TABLE IF NOT EXISTS raw_data.suppliers (
    supplier_id VARCHAR(20) PRIMARY KEY,
    supplier_name VARCHAR(200) NOT NULL,
    supplier_city VARCHAR(50) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100),
    created_at DATE DEFAULT CURRENT_DATE,
    
    -- Constraints
    CONSTRAINT chk_email_format CHECK (email IS NULL OR email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    CONSTRAINT chk_supplier_name CHECK (supplier_name IS NOT NULL AND supplier_name != ''),
    CONSTRAINT chk_supplier_city CHECK (supplier_city IS NOT NULL AND supplier_city != ''),
    CONSTRAINT chk_created_at_suppliers CHECK (created_at <= CURRENT_DATE)
);
