-- Task 3
-- 1. Membuat tabel total revenue berdasarkan tahun
CREATE TABLE total_revenue AS(
	SELECT
		date_part('year', ord.order_purchase_timestamp) AS year,
		SUM(oid.price + oid.freight_value) AS revenue
	FROM order_items_dataset AS oid
	JOIN orders_dataset AS ord
		ON oid.order_id = ord.order_id
	WHERE ord.order_status like 'delivered'
	GROUP BY 1
	ORDER BY 1
);	
-- 2.Membuat tabel jumlah cancel order berdasarkan tahun
CREATE TABLE canceled_order AS(
	SELECT
		date_part('year', order_purchase_timestamp) AS year,
		COUNT(order_status) AS canceled
	FROM orders_dataset
	WHERE order_status like 'canceled'
	GROUP BY 1
	ORDER BY 1
);	
-- 3.Membuat tabel kategori produk yang memberikan pendapatan total tertinggi untuk masing-masing tahun
CREATE TABLE top_product_category AS(
	SELECT 
		year,
		top_category,
		product_revenue
	FROM (
		SELECT
			date_part('year', shipping_limit_date) AS year,
			pd.product_category_name AS top_category,
			SUM(oid.price + oid.freight_value) AS product_revenue,
			RANK() OVER (PARTITION BY date_part('year', shipping_limit_date)
					 ORDER BY SUM(oid.price + oid.freight_value) DESC) AS ranking
		FROM orders_dataset AS ord 
		JOIN order_items_dataset AS oid
			ON ord.order_id = oid.order_id
		JOIN product_dataset AS pd
			ON oid.product_id = pd.product_id
		WHERE ord.order_status like 'delivered'
		GROUP BY 1, 2
		ORDER BY 1
		) AS subsq
	WHERE ranking = 1
);
	
--4) Membuat tabel kategori produk yang memiliki jumlah cancel order terbanyak untuk masing-masing tahun
CREATE TABLE most_canceled_category AS(
	SELECT 
		year,
		most_canceled,
		total_canceled
	FROM (
		SELECT
			date_part('year', shipping_limit_date) AS year,
			pd.product_category_name AS most_canceled,
			COUNT(ord.order_id) AS total_canceled,
			RANK() OVER (PARTITION BY date_part('year', shipping_limit_date)
					 ORDER BY COUNT(ord.order_id) DESC) AS ranking
		FROM orders_dataset AS ord
		JOIN order_items_dataset AS oid
			ON ord.order_id = oid.order_id
		JOIN product_dataset AS pd
			ON oid.product_id = pd.product_id
		WHERE ord.order_status like 'canceled'
		GROUP BY 1, 2
		ORDER BY 1
		) AS subsq
	WHERE ranking = 1
);
-- Tambahan - Menghapus anomali data tahun 2020
DELETE FROM top_product_category WHERE year = 2020;
DELETE FROM most_canceled_category WHERE year = 2020;

-- 5. Menampilkan tabel yang dibutuhkan
SELECT 
	tr.year,
	tr.revenue AS total_revenue,
	tpc.top_category AS top_product,
	tpc.product_revenue AS total_revenue_top_product,
	co.canceled total_canceled,
	mcc.most_canceled top_canceled_product,
	mcc.total_canceled total_top_canceled_product
FROM total_revenue AS tr
JOIN top_product_category AS tpc
	ON tr.year = tpc.year
JOIN canceled_order AS co
	ON tpc.year = co.year
JOIN most_canceled_category AS mcc
	ON co.year = mcc.year
GROUP BY 1, 2, 3, 4, 5, 6, 7