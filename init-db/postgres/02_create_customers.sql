-- 1. TABEL CUSTOMERS
CREATE TABLE IF NOT EXISTS raw_data.customers (
    customer_id VARCHAR(10) PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    customer_city VARCHAR(50) NOT NULL,
    phone VARCHAR(20),
    state VARCHAR(50),
    updated_at DATE DEFAULT CURRENT_DATE,
    
    -- Constraints
    CONSTRAINT chk_customer_name CHECK (customer_name IS NOT NULL AND customer_name != ''),
    CONSTRAINT chk_customer_city CHECK (customer_city IS NOT NULL AND customer_city != ''),
    CONSTRAINT chk_created_at CHECK (created_at <= CURRENT_DATE)
);

COMMENT ON TABLE raw_data.customers IS 'Tabel data pelanggan';
COMMENT ON COLUMN raw_data.customers.customer_id IS 'ID unik pelanggan';
COMMENT ON COLUMN raw_data.customers.customer_name IS 'Nama lengkap pelanggan';
COMMENT ON COLUMN raw_data.customers.customer_city IS 'Kota tempat tinggal pelanggan';