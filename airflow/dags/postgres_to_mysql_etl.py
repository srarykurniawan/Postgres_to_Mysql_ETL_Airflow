"""
PostgreSQL to MySQL ETL DAG
"""

from datetime import timedelta
import logging
import re

from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.utils.dates import days_ago
from airflow.providers.postgres.hooks.postgres import PostgresHook
from airflow.providers.mysql.hooks.mysql import MySqlHook


# -------------------------------------------------------------------
# DEFAULT ARGUMENTS
# -------------------------------------------------------------------
default_args = {
    'owner': 'data-engineering-team',
    'retries': 2,
    'retry_delay': timedelta(minutes=5),
}


# -------------------------------------------------------------------
# DAG DEFINITION
# -------------------------------------------------------------------
dag = DAG(
    dag_id='postgres_to_mysql_etl',
    default_args=default_args,
    description='ETL from PostgreSQL to MySQL',
    schedule_interval=timedelta(hours=6),
    start_date=days_ago(1),
    catchup=False,
    tags=['etl', 'postgresql', 'mysql', 'data-pipeline'],
)


# -------------------------------------------------------------------
# EXTRACT FUNCTIONS
# -------------------------------------------------------------------
def extract_customers_from_postgres(**context):
    hook = PostgresHook(postgres_conn_id='postgres_source')

    sql = """
        SELECT customer_id, name, phone, state, updated_at
        FROM raw_data.customers
        WHERE updated_at >= CURRENT_DATE - INTERVAL '1 day';
    """

    conn = hook.get_conn()
    cursor = conn.cursor()
    cursor.execute(sql)

    records = cursor.fetchall()
    columns = [col[0] for col in cursor.description]

    customers = [dict(zip(columns, row)) for row in records]

    context['ti'].xcom_push(
        key='customers_data',
        value=customers
    )

    logging.info("Extracted %s customer records", len(customers))



def extract_products_from_postgres(**context):
    hook = PostgresHook(postgres_conn_id='postgres_source')

    sql = """
        SELECT
            p.product_id,
            p.product_name,
            p.category,
            p.price,
            p.cost,
            p.updated_at,
            s.supplier_name
        FROM raw_data.products p
        JOIN raw_data.suppliers s
          ON p.supplier_id = s.supplier_id
        WHERE p.updated_at >= CURRENT_DATE - INTERVAL '1 day';
    """

    conn = hook.get_conn()
    cursor = conn.cursor()
    cursor.execute(sql)

    records = cursor.fetchall()
    columns = [col[0] for col in cursor.description]

    products = [dict(zip(columns, row)) for row in records]

    context['ti'].xcom_push(
        key='products_data',
        value=products
    )

    logging.info("Extracted %s product records", len(products))

def extract_orders_from_postgres(**context):
    hook = PostgresHook(postgres_conn_id='postgres_source')

    sql = """
        SELECT order_id, customer_id, order_date,
               status, total_amount, updated_at
        FROM raw_data.orders
        WHERE updated_at >= CURRENT_DATE - INTERVAL '1 day';
    """

    conn = hook.get_conn()
    cursor = conn.cursor()
    cursor.execute(sql)

    records = cursor.fetchall()
    columns = [col[0] for col in cursor.description]

    orders = [dict(zip(columns, row)) for row in records]

    context['ti'].xcom_push(
        key='orders_data',
        value=orders
    )

    logging.info("Extracted %s order records", len(orders))


# -------------------------------------------------------------------
# TRANSFORM & LOAD FUNCTIONS
# -------------------------------------------------------------------
def transform_and_load_customers(**context):
    """
    Transform and load customer data into MySQL.
    """
    customers = context['ti'].xcom_pull(
        task_ids='extract_customers',
        key='customers_data'
    )

    if not customers:
        logging.info("No customer data to process")
        return

    mysql_hook = MySqlHook(mysql_conn_id='mysql_warehouse')

    sql = """
        INSERT INTO dim_customers
        (customer_id, name, phone, state, updated_at)
        VALUES (%s, %s, %s, %s, %s)
        ON DUPLICATE KEY UPDATE
            name = VALUES(name),
            phone = VALUES(phone),
            state = VALUES(state),
            updated_at = VALUES(updated_at);
    """

    values = []
    for customer in customers:
        phone_digits = re.sub(r'\D', '', customer.get('phone', ''))
        if len(phone_digits) == 10:
            phone = f"({phone_digits[:3]}) {phone_digits[3:6]}-{phone_digits[6:]}"
        else:
            phone = None

        state = customer.get('state', '').upper()

        values.append((
            customer['customer_id'],
            customer['name'],
            phone,
            state,
            customer['updated_at']
        ))

    mysql_hook.run(sql, parameters=values)
    logging.info("Loaded %s customer records into MySQL", len(values))


def transform_and_load_products(**context):
    """
    Transform and load product data into MySQL.
    """
    products = context['ti'].xcom_pull(
        task_ids='extract_products',
        key='products_data'
    )

    if not products:
        logging.info("No product data to process")
        return

    mysql_hook = MySqlHook(mysql_conn_id='mysql_warehouse')

    sql = """
        INSERT INTO dim_products
        (product_id, product_name, category, price, cost,
         margin_percentage, supplier_name, updated_at)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
        ON DUPLICATE KEY UPDATE
            product_name = VALUES(product_name),
            category = VALUES(category),
            price = VALUES(price),
            cost = VALUES(cost),
            margin_percentage = VALUES(margin_percentage),
            supplier_name = VALUES(supplier_name),
            updated_at = VALUES(updated_at);
    """

    values = []
    for product in products:
        price = product.get('price', 0)
        cost = product.get('cost', 0)

        margin = ((price - cost) / price * 100) if price > 0 else 0
        category = product.get('category', '').title()

        values.append((
            product['product_id'],
            product['product_name'],
            category,
            price,
            cost,
            round(margin, 2),
            product['supplier_name'],
            product['updated_at']
        ))

    mysql_hook.run(sql, parameters=values)
    logging.info("Loaded %s product records into MySQL", len(values))


def transform_and_load_orders(**context):
    """
    Transform and load order data into MySQL.
    """
    orders = context['ti'].xcom_pull(
        task_ids='extract_orders',
        key='orders_data'
    )

    if not orders:
        logging.info("No order data to process")
        return

    mysql_hook = MySqlHook(mysql_conn_id='mysql_warehouse')

    sql = """
        INSERT INTO fact_orders
        (order_id, customer_id, order_date,
         status, total_amount, updated_at)
        VALUES (%s, %s, %s, %s, %s, %s)
        ON DUPLICATE KEY UPDATE
            status = VALUES(status),
            total_amount = VALUES(total_amount),
            updated_at = VALUES(updated_at);
    """

    values = []
    for order in orders:
        total_amount = order.get('total_amount', 0)
        if total_amount < 0:
            logging.warning(
                "Negative total_amount for order_id %s, set to 0",
                order['order_id']
            )
            total_amount = 0

        values.append((
            order['order_id'],
            order['customer_id'],
            order['order_date'],
            order.get('status', '').lower(),
            total_amount,
            order['updated_at']
        ))

    mysql_hook.run(sql, parameters=values)
    logging.info("Loaded %s order records into MySQL", len(values))


# -------------------------------------------------------------------
# TASK DEFINITIONS
# -------------------------------------------------------------------
extract_customers = PythonOperator(
    task_id='extract_customers',
    python_callable=extract_customers_from_postgres,
    dag=dag,
)

extract_products = PythonOperator(
    task_id='extract_products',
    python_callable=extract_products_from_postgres,
    dag=dag,
)

extract_orders = PythonOperator(
    task_id='extract_orders',
    python_callable=extract_orders_from_postgres,
    dag=dag,
)

load_customers = PythonOperator(
    task_id='transform_and_load_customers',
    python_callable=transform_and_load_customers,
    dag=dag,
)

load_products = PythonOperator(
    task_id='transform_and_load_products',
    python_callable=transform_and_load_products,
    dag=dag,
)

load_orders = PythonOperator(
    task_id='transform_and_load_orders',
    python_callable=transform_and_load_orders,
    dag=dag,
)

# -------------------------------------------------------------------
# DEPENDENCIES
# -------------------------------------------------------------------
extract_customers >> load_customers
extract_products >> load_products
extract_orders >> load_orders
