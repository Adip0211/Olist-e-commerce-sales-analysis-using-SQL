-- =====================================================
-- 01_schema_and_load.sql
-- Creates tables and loads the Olist CSV files (PostgreSQL)
-- =====================================================

DROP TABLE IF EXISTS order_payments, order_items, orders, customers, products, category_translation CASCADE;

CREATE TABLE customers (
    customer_id              VARCHAR(50) PRIMARY KEY,
    customer_unique_id       VARCHAR(50) NOT NULL,
    customer_zip_code_prefix VARCHAR(10),
    customer_city            VARCHAR(100),
    customer_state           CHAR(2)
);

CREATE TABLE orders (
    order_id                      VARCHAR(50) PRIMARY KEY,
    customer_id                   VARCHAR(50) REFERENCES customers(customer_id),
    order_status                  VARCHAR(20),
    order_purchase_timestamp      TIMESTAMP,
    order_approved_at             TIMESTAMP,
    order_delivered_carrier_date  TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP
);

CREATE TABLE products (
    product_id                 VARCHAR(50) PRIMARY KEY,
    product_category_name      VARCHAR(100),
    product_name_lenght        INT,
    product_description_lenght INT,
    product_photos_qty         INT,
    product_weight_g           INT,
    product_length_cm          INT,
    product_height_cm          INT,
    product_width_cm           INT
);

CREATE TABLE order_items (
    order_id            VARCHAR(50) REFERENCES orders(order_id),
    order_item_id       INT,
    product_id          VARCHAR(50) REFERENCES products(product_id),
    seller_id           VARCHAR(50),
    shipping_limit_date TIMESTAMP,
    price               NUMERIC(10,2),
    freight_value       NUMERIC(10,2),
    PRIMARY KEY (order_id, order_item_id)
);

CREATE TABLE order_payments (
    order_id             VARCHAR(50) REFERENCES orders(order_id),
    payment_sequential   INT,
    payment_type         VARCHAR(30),
    payment_installments INT,
    payment_value        NUMERIC(10,2),
    PRIMARY KEY (order_id, payment_sequential)
);

CREATE TABLE category_translation (
    product_category_name         VARCHAR(100) PRIMARY KEY,
    product_category_name_english VARCHAR(100)
);

-- Load data (run from psql in the project root; change paths if needed).
-- Order matters because of the foreign keys.
\copy customers            FROM 'data/olist_customers_dataset.csv'          CSV HEADER
\copy orders               FROM 'data/olist_orders_dataset.csv'             CSV HEADER
\copy products             FROM 'data/olist_products_dataset.csv'           CSV HEADER
\copy order_items          FROM 'data/olist_order_items_dataset.csv'        CSV HEADER
\copy order_payments       FROM 'data/olist_order_payments_dataset.csv'     CSV HEADER
\copy category_translation FROM 'data/product_category_name_translation.csv' CSV HEADER
