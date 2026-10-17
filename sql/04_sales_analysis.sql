-- Convention : seul le statut 'completed' contribue aux ventes reconnues.

-- Chiffre d'affaires total et nombre de commandes terminées.
WITH order_totals AS (
    SELECT
        o.order_id,
        COALESCE(SUM(oi.quantity * oi.unit_price), 0)::numeric(12, 2) AS order_revenue
    FROM orders AS o
    LEFT JOIN order_items AS oi ON oi.order_id = o.order_id
    WHERE o.order_status = 'completed'
    GROUP BY o.order_id
)
SELECT
    COUNT(*) AS completed_order_count,
    COALESCE(SUM(order_revenue), 0)::numeric(14, 2) AS recognized_revenue
FROM order_totals;

-- Ventes mensuelles ; les mois sans commande terminée ne sont pas affichés ici.
SELECT
    date_trunc('month', o.order_date)::date AS sales_month,
    COUNT(DISTINCT o.order_id) AS completed_order_count,
    SUM(oi.quantity)::bigint AS units_sold,
    SUM(oi.quantity * oi.unit_price)::numeric(14, 2) AS revenue
FROM orders AS o
JOIN order_items AS oi ON oi.order_id = o.order_id
WHERE o.order_status = 'completed'
GROUP BY date_trunc('month', o.order_date)::date
ORDER BY sales_month;

-- Produits les plus vendus, classés par unités écoulées puis par chiffre d'affaires.
SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity)::bigint AS units_sold,
    SUM(oi.quantity * oi.unit_price)::numeric(14, 2) AS revenue
FROM order_items AS oi
JOIN orders AS o ON o.order_id = oi.order_id
JOIN products AS p ON p.product_id = oi.product_id
WHERE o.order_status = 'completed'
GROUP BY p.product_id, p.product_name
ORDER BY units_sold DESC, revenue DESC, p.product_name
LIMIT 10;

-- Clients générant le chiffre d'affaires reconnu le plus élevé.
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(DISTINCT o.order_id) AS completed_order_count,
    SUM(oi.quantity * oi.unit_price)::numeric(14, 2) AS recognized_revenue
FROM customers AS c
JOIN orders AS o ON o.customer_id = c.customer_id
JOIN order_items AS oi ON oi.order_id = o.order_id
WHERE o.order_status = 'completed'
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY recognized_revenue DESC, c.customer_id
LIMIT 10;

-- Panier moyen : moyenne du montant des commandes terminées, lignes comprises.
WITH order_totals AS (
    SELECT
        o.order_id,
        COALESCE(SUM(oi.quantity * oi.unit_price), 0)::numeric(12, 2) AS order_revenue
    FROM orders AS o
    LEFT JOIN order_items AS oi ON oi.order_id = o.order_id
    WHERE o.order_status = 'completed'
    GROUP BY o.order_id
)
SELECT
    COUNT(*) AS completed_order_count,
    COALESCE(AVG(order_revenue), 0)::numeric(12, 2) AS average_order_value
FROM order_totals;
