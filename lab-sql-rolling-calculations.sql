-- Lab | SQL Rolling calculations
-- In this lab, you will be using the Sakila database of movie rentals.

-- Instructions
-- Get number of monthly active customers.
-- Active users in the previous month.
-- Percentage change in the number of active customers.
-- Retained customers every month.

-- Número de clientes activos mensuales:

use sakila; 

SELECT
    DATE_FORMAT(rental_date, '%Y-%m') AS month,
    COUNT(DISTINCT customer_id) AS active_customers
FROM
    rental
GROUP BY
    DATE_FORMAT(rental_date, '%Y-%m');

-- Usuarios activos en el mes anterior:

SELECT
    DATE_FORMAT(rental_date, '%Y-%m') AS month,
    COUNT(DISTINCT customer_id) AS active_customers,
    LAG(COUNT(DISTINCT customer_id), 1) OVER (ORDER BY DATE_FORMAT(rental_date, '%Y-%m')) AS previous_month_active_customers -- con el lag te creas una columna nueva con los datos de la linea anterior
FROM
    rental
GROUP BY
    DATE_FORMAT(rental_date, '%Y-%m');
    
-- Cambio porcentual en el número de clientes activos:

SELECT
    DATE_FORMAT(rental_date, '%Y-%m') AS month,
    COUNT(DISTINCT customer_id) AS active_customers,
    LAG(COUNT(DISTINCT customer_id), 1) OVER (ORDER BY DATE_FORMAT(rental_date, '%Y-%m')) AS previous_month_active_customers
    ,COUNT(DISTINCT customer_id) - LAG(COUNT(DISTINCT customer_id), 1) OVER (ORDER BY DATE_FORMAT(rental_date, '%Y-%m')) AS variación_clientes
    ,100* (COUNT(DISTINCT customer_id) - LAG(COUNT(DISTINCT customer_id), 1) OVER (ORDER BY DATE_FORMAT(rental_date, '%Y-%m'))) / COUNT(DISTINCT customer_id)  AS variación_clientes_porcentual
FROM
    rental
GROUP BY
    DATE_FORMAT(rental_date, '%Y-%m');
    
-- Clientes retenidos cada mes:
    
SELECT
    month,
    active_customers,
    previous_month_active_customers,
    retained_customers
FROM (
    SELECT
        month,
        active_customers,
        previous_month_active_customers,
        active_customers - previous_month_active_customers AS retained_customers
    FROM (
        SELECT
            DATE_FORMAT(rental_date, '%Y-%m') AS month,
            COUNT(DISTINCT customer_id) AS active_customers,
            LAG(COUNT(DISTINCT customer_id), 1) OVER (ORDER BY DATE_FORMAT(rental_date, '%Y-%m')) AS previous_month_active_customers
        FROM
            rental
        GROUP BY
            DATE_FORMAT(rental_date, '%Y-%m')
    ) AS subquery
) AS retained_customers;

SELECT
	DATE_FORMAT(rental_date, '%Y-%m') AS month, customer_id,
    COUNT(DISTINCT customer_id) AS active_customers,
    LAG(COUNT(DISTINCT customer_id), 1) OVER (ORDER BY DATE_FORMAT(rental_date, '%Y-%m')) AS previous_month_active_customers,
    (LAG(COUNT(DISTINCT customer_id), 1) OVER (ORDER BY DATE_FORMAT(rental_date, '%Y-%m'))) - (COUNT(DISTINCT customer_id)) AS Variación_customer
FROM
    rental
GROUP BY
    DATE_FORMAT(rental_date, '%Y-%m'), customer_id;