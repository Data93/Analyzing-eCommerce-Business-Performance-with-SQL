-- Task 4
-- 1. Show total penggunaan masing-masing tipe pembayaran secara all time diurutkan dari yang terfavorit
SELECT payment_type, COUNT(1) 
FROM order_payments_dataset
GROUP BY 1
ORDER BY 2 DESC;

-- 2. Show detail informasi jumlah penggunaan masing-masing tipe pembayaran untuk setiap tahun
SELECT
	payment_type,
	SUM(CASE WHEN year = 2016 THEN total ELSE 0 END) AS "tahun_2016",
	SUM(CASE WHEN year = 2017 THEN total ELSE 0 END) AS "tahun_2017",
	SUM(CASE WHEN year = 2018 THEN total ELSE 0 END) AS "tahun_2018",
	SUM(total) AS total_payment_type_usage
FROM (
	SELECT 
		date_part('year', ord.order_purchase_timestamp) as year,
		op.payment_type,
		COUNT(op.payment_type) AS total
	FROM orders_dataset AS ord
	JOIN order_payments_dataset AS op 
		ON ord.order_id = op.order_id
	GROUP BY 1, 2
	) AS subsq
GROUP BY 1
ORDER BY 2 DESC;