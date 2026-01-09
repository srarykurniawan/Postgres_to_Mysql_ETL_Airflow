-- Buat database warehouse jika belum ada
CREATE DATABASE IF NOT EXISTS warehouse 
    CHARACTER SET utf8mb4 
    COLLATE utf8mb4_unicode_ci;

-- Gunakan database warehouse
USE warehouse;

-- Buat user ETL dan berikan hak akses
CREATE USER IF NOT EXISTS 'etl_user'@'%' IDENTIFIED BY 'etl_password';
GRANT ALL PRIVILEGES ON warehouse.* TO 'etl_user'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER ON warehouse.* TO 'etl_user'@'%';
FLUSH PRIVILEGES;

-- Set session timezone
SET time_zone = '+07:00';