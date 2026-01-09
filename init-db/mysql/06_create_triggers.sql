-- TRIGGER UNTUK VALIDASI DATA

-- Trigger untuk memastikan updated_at selalu diupdate
DELIMITER $$

-- Trigger untuk dim_customers
CREATE TRIGGER IF NOT EXISTS trg_dim_customers_before_update
BEFORE UPDATE ON dim_customers
FOR EACH ROW
BEGIN
    SET NEW.updated_at = CURRENT_TIMESTAMP;
END$$

-- Trigger untuk dim_products
CREATE TRIGGER IF NOT EXISTS trg_dim_products_before_update
BEFORE UPDATE ON dim_products
FOR EACH ROW
BEGIN
    SET NEW.updated_at = CURRENT_TIMESTAMP;
    -- Validasi: harga harus lebih besar dari cost
    IF NEW.price < NEW.cost THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Harga produk tidak boleh lebih rendah dari cost';
    END IF;
END$$

-- Trigger untuk fact_orders
CREATE TRIGGER IF NOT EXISTS trg_fact_orders_before_insert
BEFORE INSERT ON fact_orders
FOR EACH ROW
BEGIN
    -- Validasi: total_amount harus sama dengan quantity * unit_price
    IF NEW.total_amount != (NEW.quantity * NEW.unit_price) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Total amount harus sama dengan quantity dikali unit_price';
    END IF;
    
    -- Validasi: order_date tidak boleh di masa depan
    IF NEW.order_date > CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Order date tidak boleh di masa depan';
    END IF;
END$$

DELIMITER ;