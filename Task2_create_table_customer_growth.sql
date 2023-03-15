--- Tugas 2

--- Calculate MAU (Monthly Active User) average by year
WITH monthly_active_user AS (
	SELECT year, round(AVG(monthly_active_user), 3) AS avg_monthly_active_user
	FROM (
		SELECT date_part('year', ord.order_purchase_timestamp) AS year,
		 	date_part('month', ord.order_purchase_timestamp) AS month,
		  	COUNT(DISTINCT cs.customer_unique_id) AS monthly_active_user
		FROM orders_dataset AS ord
		JOIN customers_dataset AS cs ON ord.customer_id = cs.customer_id
		GROUP BY 1, 2
	) subsq
	GROUP BY 1
	ORDER BY 1 ASC
	),

--- New Customer (First_order) by year
new_customer AS(
	SELECT date_part('year', first_order) AS year,
		COUNT(DISTINCT customer_unique_id) AS total_new_customer
	FROM(
		SELECT cs.customer_unique_id,
			min(ord.order_purchase_timestamp) AS first_order
		FROM orders_dataset AS ord
		JOIN customers_dataset AS cs ON ord.customer_id = cs.customer_id
		GROUP BY 1
		) subsq
	GROUP BY 1
	ORDER BY 1 ASC
),

--- Regular customer (Repeat order) by year
repeat AS(
	SELECT year,
		COUNT(customer) AS total_repeat_customer
	FROM(
		SELECT cs.customer_unique_id,
			COUNT(1) AS customer,
			date_part('year', ord.order_purchase_timestamp) AS YEAR
		FROM orders_dataset AS ord
		JOIN customers_dataset AS cs ON ord.customer_id = cs.customer_id
		GROUP BY 1, 3
		HAVING COUNT (1) > 1
	) subsq
	GROUP BY 1
	ORDER BY 1 ASC
),

-- Average order by year
avg_freq AS(
	SELECT year,
		ROUND(AVG(total_order), 3) AS avg_total_order
	FROM(
		SELECT cs.customer_unique_id,
			date_part('year', ord.order_purchase_timestamp) AS year,
			COUNT(1) AS total_order
		FROM orders_dataset AS ord
		JOIN customers_dataset AS cs ON ord.customer_id = cs.customer_id
	GROUP BY 1, 2
	) subsq
	GROUP BY 1
	ORDER BY 1 ASC
)

-- task 5
SELECT m.year, m.avg_monthly_active_user, nc.total_new_customer, r.total_repeat_customer, af.avg_total_order
FROM monthly_active_user AS m
JOIN new_customer AS nc ON m.year = nc.year
JOIN repeat AS r ON m.year = r.year
JOIN avg_freq AS af ON m.year = af.year;