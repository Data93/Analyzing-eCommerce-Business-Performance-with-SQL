-- Create table database with query

-- 1. Customers dataset
CREATE TABLE IF NOT EXISTS customers_dataset(
	customer_id TEXT PRIMARY KEY NOT NULL,
	customer_unique_id TEXT,
	customer_zip_code_prefix SMALLINT,
	customer_city VARCHAR(50),
	customer_state VARCHAR(10)
);

-- 2. Geolocation dataset
CREATE TABLE IF NOT EXISTS geoloctaion_dataset(
	customer_id TEXT,
	customer_unique_id TEXT,
	customer_zip_code_prefix SMALLINT,
	customer_city VARCHAR(50),
	customer_state VARCHAR(10)
);
-- 3. Order item dataset
CREATE TABLE IF NOT EXISTS order_items_dataset (
	order_id TEXT,
	order_item_id TEXT,
	product_id TEXT,
	seller_id TEXT,
	shipping_limit_date TIMESTAMP WITH ZONE,
	price REAL,
	freight_value REAL
);

-- 4. Order payment dataset
CREATE TABLE IF NOT EXISTS order_payments_dataset(
	order_id TEXT,
	payment_sequential SMALLINT,
	payment_type VARCHAR(20),
	payment_installments SMALLINT,
	payment_value DOUBLE PRECISION
);

-- 5. Order review dataset
CREATE TABLE IF NOT EXISTS order_reviews_dataset(
	review_id TEXT,
	order_id TEXT,
	review_score SMALLINT,
	review_comment_title TEXT,
	review_comment_message TEXT,
	review_creation_date TIMESTAMP WITH TIME ZONE,
	review_answer_timestamp TIMESTAMP WITH TIME ZONE
);

-- 6. Order dataset
CREATE TABLE IF NOT EXISTS orders_dataset(
	order_id TEXT,
	customer_id TEXT PRIMARY KEY NOT NULL,
	order_status VARCHAR(50),
	order_purchase_timestamp TIMESTAMP WITH TIME ZONE,
	order_approved_at TIMESTAMP WITH TIME ZONE,
	order_delivered_carrier_date TIMESTAMP WITH TIME ZONE,
	order_delivered_customer_date TIMESTAMP WITH TIME ZONE,
	order_estimated_delivery_date TIMESTAMP WITH TIME ZONE
);

-- 7. Product dataset
CREATE TABLE IF NOT EXISTS product_dataset(
	number_id SMALLINT,
	product_id TEXT PRIMARY KEY NOT NULL,
	product_category_name VARCHAR(50),
	product_name_lenght DOUBLE PRECISION,
	product_description_lenght DOUBLE PRECISION,
	product_photos_qty DOUBLE PRECISION,
	product_weight_g DOUBLE PRECISION,
	product_length_cm DOUBLE PRECISION,
	product_height_cm DOUBLE PRECISION,
	product_width_cm DOUBLE PRECISION
);

-- 8. Seller dataset
CREATE TABLE IF NOT EXISTS sellers_dataset(
	seller_id TEXT PRIMARY KEY NOT NULL,
	seller_zip_code_prefix INT,
	seller_city VARCHAR(50),
	seller_state VARCHAR(10)
);

--- create foreign key
ALTER TABLE public.order_items_dataset ADD CONSTRAINT order_items_dataset_order_id_fkey FOREIGN KEY (order_id) REFERENCES orders_dataset(order_id);

ALTER TABLE public.order_items_dataset ADD CONSTRAINT order_items_dataset_product_id_fkey FOREIGN KEY (product_id) REFERENCES product_dataset(product_id);

ALTER TABLE public.order_items_dataset ADD CONSTRAINT order_items_dataset_fk FOREIGN KEY (seller_id) REFERENCES sellers_dataset(seller_id);

ALTER TABLE public.order_payments_dataset ADD CONSTRAINT order_payments_dataset_order_id_fkey FOREIGN KEY (order_id) REFERENCES orders_dataset(order_id);

ALTER TABLE public.orders_dataset ADD order_id text NOT NULL;

ALTER TABLE public.orders_dataset ADD CONSTRAINT orders_dataset_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES customers_dataset(customer_id);

