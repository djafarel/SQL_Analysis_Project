-- Contrôles de diagnostic : chaque requête retourne uniquement les anomalies.
-- Les contraintes du schéma empêchent plusieurs de ces cas à l'insertion.

-- Doublons sur les identifiants métier supposés uniques.
SELECT email, COUNT(*) AS row_count
FROM customers
GROUP BY email
HAVING COUNT(*) > 1;

SELECT product_name, COUNT(*) AS row_count
FROM products
GROUP BY product_name
HAVING COUNT(*) > 1;

-- Champs obligatoires absents ou composés uniquement d'espaces.
SELECT customer_id, 'first_name' AS column_name
FROM customers
WHERE first_name IS NULL OR btrim(first_name) = ''
UNION ALL
SELECT customer_id, 'last_name'
FROM customers
WHERE last_name IS NULL OR btrim(last_name) = ''
UNION ALL
SELECT customer_id, 'email'
FROM customers
WHERE email IS NULL OR btrim(email) = '';

SELECT product_id, 'product_name' AS column_name
FROM products
WHERE product_name IS NULL OR btrim(product_name) = ''
UNION ALL
SELECT product_id, 'category'
FROM products
WHERE category IS NULL OR btrim(category) = '';

SELECT order_id, 'order_date' AS column_name
FROM orders
WHERE order_date IS NULL
UNION ALL
SELECT order_id, 'order_status'
FROM orders
WHERE order_status IS NULL OR order_status NOT IN ('completed', 'pending', 'cancelled');

-- Valeurs numériques ou quantités incohérentes.
SELECT product_id, unit_price
FROM products
WHERE unit_price IS NULL OR unit_price <= 0;

SELECT order_id, product_id, quantity, unit_price
FROM order_items
WHERE quantity IS NULL OR quantity <= 0
   OR unit_price IS NULL OR unit_price < 0;

-- Lignes de commande sans commande ou produit correspondant (orphelines).
SELECT oi.order_id, oi.product_id
FROM order_items AS oi
LEFT JOIN orders AS o ON o.order_id = oi.order_id
LEFT JOIN products AS p ON p.product_id = oi.product_id
WHERE o.order_id IS NULL OR p.product_id IS NULL;

-- Commandes associées à un client manquant ou sans aucune ligne.
SELECT o.order_id, o.customer_id
FROM orders AS o
LEFT JOIN customers AS c ON c.customer_id = o.customer_id
WHERE c.customer_id IS NULL;

SELECT o.order_id, o.order_status
FROM orders AS o
LEFT JOIN order_items AS oi ON oi.order_id = o.order_id
GROUP BY o.order_id, o.order_status
HAVING COUNT(oi.product_id) = 0;
