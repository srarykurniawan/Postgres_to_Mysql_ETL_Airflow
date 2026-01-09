-- Buat schema raw_data jika belum ada
CREATE SCHEMA IF NOT EXISTS raw_data;

-- Berikan hak akses ke user ETL
GRANT ALL PRIVILEGES ON SCHEMA raw_data TO etl_user;
GRANT USAGE ON SCHEMA raw_data TO etl_user;

-- Set search path untuk schema raw_data
ALTER DATABASE source_db SET search_path TO raw_data, public;