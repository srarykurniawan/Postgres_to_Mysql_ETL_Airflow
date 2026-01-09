PostgreSQL to MySQL ETL Pipeline (Apache Airflow)

📌 DESKRIPSI PROJECT
Project ini bertujuan untuk membangun ETL (Extract, Transform, Load) pipeline menggunakan Apache Airflow untuk memindahkan data dari PostgreSQL (source) ke MySQL (data warehouse) secara terjadwal.

Pipeline akan:

1. Extract data terbaru dari PostgreSQL
2. Transform data sesuai kebutuhan bisnis
3. Load data ke MySQL dalam bentuk tabel dimensi dan fakta

Pipeline dijalankan otomatis setiap 6 jam.

🧱 ARSITEKTUR PIPELINE
PostgreSQL (Source)
   |
   |  Extract (PythonOperator)
   v
Apache Airflow
   |
   |  Transform & Load (PythonOperator)
   v
MySQL (Data Warehouse)

🛠️ TEKNOLOGI YANG DIGUNAKAN
1. Apache Airflow
2. PostgreSQL
3. MySQL
4. Docker & Docker Compose
5. Python

📂 STRUKTUR FOLDER
postgres-to-mysql-etl/
│
├── airflow/
│   ├── dags/
│   │   └── postgres_to_mysql_etl.py   # File DAG utama
│   ├── logs/
│   └── plugins/
│
├── docker-compose.yml                 # Konfigurasi container
├── README.md                          # Dokumentasi project

🗄️ DATABASE & TABEL

1️⃣ PostgreSQL (Source Database)

Connection ID Airflow: postgres_source

Schema: raw_data

Tabel sumber:

raw_data.customers
raw_data.products
raw_data.suppliers
raw_data.orders

Data yang diekstrak hanya data dengan: updated_at >= CURRENT_DATE - INTERVAL '1 day'

2️⃣ MySQL (Data Warehouse)

Connection ID Airflow: mysql_warehouse

Tabel target:

dim_customers
dim_products
fact_orders

🔄 Alur ETL Pipeline
1. EXTRACT
Mengambil data dari PostgreSQL menggunakan PostgresHook:

extract_customers
extract_products
extract_orders

Hasil extract:
Dikonversi menjadi list of dictionaries
Disimpan ke XCom

2. TRANSFORM
Contoh transformasi:
Format nomor telepon customer
Mengubah state menjadi huruf besar
Menghitung margin produk
Validasi nilai negatif pada total order

3. LOAD
Memasukkan data ke MySQL menggunakan MySqlHook:
Menggunakan INSERT ... ON DUPLICATE KEY UPDATE
Mendukung incremental load

⏱️ Jadwal DAG
DAG dijalankan setiap 6 jam: schedule_interval=timedelta(hours=6)

▶️ CARA MENJALANKAN PROJECT
1️⃣ Jalankan Docker --> docker-compose up -d

Pastikan container berikut RUNNING:

airflow_webserver
airflow_scheduler
postgres_source
mysql_warehouse

2️⃣ Akses Airflow Web UI
Buka browser: http://localhost:8080

Login (default):
Username: airflow
Password: airflow

3️⃣ Aktifkan DAG
Masuk ke halaman DAGs
Aktifkan DAG postgres_to_mysql_etl
Klik ▶️ Trigger DAG

4️⃣ Monitoring
Lihat status task (success / failed)
Cek log jika terjadi error
Pastikan data masuk ke MySQL

🔍 CARA VERIFIKASI DATA
PostgreSQL
- docker exec -it postgres_source psql -U postgres
- SELECT * FROM raw_data.customers LIMIT 5;

MySQL
- docker exec -it mysql_warehouse mysql -u root -p
- SELECT * FROM dim_customers LIMIT 5;
- SELECT * FROM dim_products LIMIT 5;
- SELECT * FROM fact_orders LIMIT 5;

⚠️ CATATAN PENTING
Pastikan Connection Airflow sudah dibuat:
postgres_source
mysql_warehouse
Pastikan schema & tabel sudah ada sebelum DAG dijalankan
DAG ini tidak menggunakan catchup

📌 KESIMPULAN
Project ini mensimulasikan ETL production-ready menggunakan Apache Airflow dengan:
- Modular task
- Incremental load
- Monitoring terpusat
- Orkestrasi berbasis Docker

####################################################################################################################

# PostgreSQL Initialization Scripts

Script inisialisasi database untuk ETL pipeline PostgreSQL-to-MySQL.

## Urutan Eksekusi:
1. `01_create_schema.sql` - Buat schema dan set hak akses
2. `02_create_customers.sql` - Buat tabel customers
3. `03_create_orders.sql` - Buat tabel orders
4. `04_create_products.sql` - Buat tabel products
5. `05_create_suppliers.sql` - Buat tabel suppliers
6. `06_insert_sample_data.sql` - Insert data contoh
7. `07_create_indexes.sql` - Buat indeks untuk optimasi

## Cara Menjalankan:
### Docker Container:
Skrip akan otomatis dijalankan saat container PostgreSQL pertama kali dibuat.

### Manual Execution:
```bash
# Masuk ke container PostgreSQL
docker exec -it postgres_container psql -U postgres -d source_db

# Jalankan skrip satu per satu
\i /docker-entrypoint-initdb.d/01_create_schema.sql
\i /docker-entrypoint-initdb.d/02_create_customers.sql
# ... dan seterusnya

####################################################################################################################

# MySQL Data Warehouse Initialization Scripts

Script inisialisasi database warehouse untuk ETL pipeline PostgreSQL-to-MySQL.

## Struktur Data Warehouse:
- **Database**: `warehouse`
- **Tabel Dimensi**:
  - `dim_customers` - Dimensi pelanggan
  - `dim_products` - Dimensi produk (dengan perhitungan margin otomatis)
- **Tabel Fakta**:
  - `fact_orders` - Fakta pesanan/transaksi

## Urutan Eksekusi:
1. `01_create_database.sql` - Buat database dan user
2. `02_create_dim_customers.sql` - Buat tabel dimensi customers
3. `03_create_dim_products.sql` - Buat tabel dimensi products
4. `04_create_fact_orders.sql` - Buat tabel fakta orders
5. `05_create_indexes.sql` - Buat indeks untuk optimasi
6. `06_create_triggers.sql` - Buat trigger untuk validasi
7. `07_insert_sample_data.sql` - Insert data contoh (opsional)

## Fitur Tambahan:
1. **Generated Column**: `margin_percentage` dihitung otomatis
2. **Triggers**: Validasi data dan auto-update timestamp
3. **Foreign Keys**: Relasi antar tabel
4. **Indexes**: Optimasi untuk query analitik
5. **Constraints**: Validasi integritas data

## Cara Menjalankan:
### Docker Container:
Skrip akan otomatis dijalankan saat container MySQL pertama kali dibuat.

### Manual Execution:
```bash
# Masuk ke container MySQL
docker exec -it mysql_container mysql -u root -p

# Atau gunakan user ETL
mysql -u etl_user -p warehouse

# Jalankan skrip
SOURCE /docker-entrypoint-initdb.d/01_create_database.sql;
SOURCE /docker-entrypoint-initdb.d/02_create_dim_customers.sql;
# ... dan seterusnya