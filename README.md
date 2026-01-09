# PostgreSQL to MySQL ETL Pipeline - Orchestrated with Airflow

## Ringkasan Proyek
Sebuah ETL Pipeline (Extract, Transform, Load) yang dibangun menggunakan Apache Airflow untuk memindahkan data dari PostgreSQL (source database) ke MySQL (data warehouse) secara otomatis, terjadwal, dan incremental. Pipeline ini mensimulasikan workflow Data Engineering production-ready dengan orkestrasi berbasis container.

## 🎯 Fitur Utama
- 🔄 Ekstraksi Inkremental
Hanya mengambil data yang berubah dalam 24 jam terakhir
- 🧹 Transformasi Data
Pembersihan, validasi, dan standardisasi data
- ⚡ Load Optimal (Upsert)
Menggunakan INSERT ... ON DUPLICATE KEY UPDATE
- ⏱️ Scheduling Otomatis
Pipeline berjalan setiap 6 jam
- 🐳 Containerized Environment
Menggunakan Docker untuk kemudahan deployment

## 🏗️ Arsitektur Pipeline
PostgreSQL (Source)  
        ↓
   Extract Task  
        ↓
    Apache Airflow  
        ↓
Transform & Load Task  
        ↓
 MySQL (Data Warehouse)  

 ## 🛠️ Teknologi yang Digunakan
 | Teknologi               | Versi | Fungsi                 |
| ----------------------- | ----- | ---------------------- |
| Apache Airflow          | 2.x+  | Workflow Orchestration |
| PostgreSQL              | 14+   | Source Database        |
| MySQL                   | 8.x   | Data Warehouse         |
| Docker & Docker Compose | -     | Containerization       |
| Python                  | 3.9+  | ETL Logic              |

## 📁 Struktur Proyek
postgres-to-mysql-etl/  
├── airflow/  
│   ├── dags/  
│   │   └── postgres_to_mysql_etl.py    # Main DAG file  
│   ├── logs/  
│   └── plugins/  
├── docker-compose.yml                  # Container configuration  
├── requirements.txt                    # Python dependencies  
└── README.md                           # Project documentation  

## 🗄️ Konfigurasi Database
1️⃣ PostgreSQL (Source Database)  
Airflow Connection ID: postgres_source  
Schema: raw_data  
Source Tables:  
🔄 raw_data.customers  
🔄 raw_data.products  
🔄 raw_data.suppliers  
🔄 raw_data.orders  
Filter Ekstraksi (Incremental): updated_at >= CURRENT_DATE - INTERVAL '1 day' (sql)  

2️⃣ MySQL (Data Warehouse)  
Airflow Connection ID: mysql_warehouse  
Target Tables:  
🔄 dim_customers (Dimensi)  
🔄 dim_products (Dimensi)  
🔄 fact_orders (Fakta)  

## 🔄 Alur ETL Pipeline
1️⃣ EXTRACT
Mengambil data dari PostgreSQL menggunakan PostgresHook:
-extract_customers() → Data pelanggan  
-extract_products() → Data produk  
-extract_orders() → Data pesanan  
📦 Output:  
Data dikonversi menjadi list of dictionaries dan disimpan ke XCom  

2️⃣ TRANSFORM  
Contoh transformasi yang diterapkan:  
📞 Format nomor telepon pelanggan  
🔠 Konversi state menjadi UPPERCASE  
💰 Perhitungan margin produk  
❌ Validasi nilai negatif pada total order  
📅 Standardisasi format tanggal  

3️⃣ LOAD  
-Memasukkan data ke MySQL menggunakan MySqlHook:  
-INSERT ... ON DUPLICATE KEY UPDATE  
-Mendukung incremental load  
-Penanganan error & retry logic  

## ⏱️ Scheduling  
DAG dijalankan setiap 6 jam: schedule_interval = timedelta(hours=6)  

## 🚀 Cara Menjalankan Proyek  
1️⃣ Clone dan setup project  
-git clone <repository-url>  
-cd postgres-to-mysql-etl  
2️⃣ Jalankan Docker services  
docker-compose up -d  
3️⃣ Verifikasi container  
docker-compose ps  
4️⃣ Akses Airflow Web UI  
🌐 URL: http://localhost:8080  
🔐 Login:  
-Username: airflow  
-Password: airflow  
5️⃣ Aktifkan & Trigger DAG  
-Masuk ke halaman DAGs  
-Cari DAG postgres_to_mysql_etl  
-Aktifkan DAG (toggle ON)  
Klik ▶️ Trigger DAG  
6️⃣ Monitoring  
📊 Pantau status task di Graph View  
📄 Cek logs untuk troubleshooting  
✅ Verifikasi data di database target  

## 🔍 Verifikasi Data  
1️⃣ PostgreSQL (Source)  
docker exec -it postgres_source psql -U postgres -d source_db  
sql:  
-SELECT * FROM raw_data.customers LIMIT 5;  
-SELECT COUNT(*) FROM raw_data.orders;  
2️⃣ MySQL (Data Warehouse)  
docker exec -it mysql_warehouse mysql -u root -p  
sql:  
USE warehouse_db;  
-SELECT * FROM dim_customers LIMIT 5;  
-SELECT * FROM dim_products LIMIT 5;  
-SELECT * FROM fact_orders LIMIT 5;  

########################################################################

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
