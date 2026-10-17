-- 1. Évolution mensuelle avec un calendrier continu :
--    les mois sans ventes terminées apparaissent avec un chiffre d'affaires nul.
WITH bounds AS (
    SELECT
        date_trunc('month', MIN(order_date))::date AS first_month,
        date_trunc('month', MAX(order_date))::date AS last_month
    FROM orders
    WHERE order_status = 'completed'
),
calendar AS (
    SELECT generate_series(
        first_month::timestamp,
        last_month::timestamp,
        interval '1 month'
    )::date AS sales_month
    FROM bounds
    WHERE first_month IS NOT NULL
),
monthly_sales AS (
    SELECT
        date_trunc('month', o.order_date)::date AS sales_month,
        SUM(oi.quantity * oi.unit_price)::numeric(14, 2) AS revenue
    FROM orders AS o
    JOIN order_items AS oi ON oi.order_id = o.order_id
    WHERE o.order_status = 'completed'
    GROUP BY date_trunc('month', o.order_date)::date
),
monthly_series AS (
    SELECT
        c.sales_month,
        COALESCE(ms.revenue, 0)::numeric(14, 2) AS revenue
    FROM calendar AS c
    LEFT JOIN monthly_sales AS ms USING (sales_month)
),
monthly_comparison AS (
    SELECT
        sales_month,
        revenue,
        LAG(revenue) OVER (ORDER BY sales_month) AS previous_month_revenue
    FROM monthly_series
)
SELECT
    sales_month,
    revenue,
    previous_month_revenue,
    (revenue - previous_month_revenue)::numeric(14, 2) AS revenue_change,
    ROUND(
        100 * (revenue - previous_month_revenue)
        / NULLIF(previous_month_revenue, 0),
        2
    ) AS month_over_month_change_pct
FROM monthly_comparison
ORDER BY sales_month;

-- 2. Classement des produits au sein de chaque mois par chiffre d'affaires.
WITH product_monthly_sales AS (
    SELECT
        date_trunc('month', o.order_date)::date AS sales_month,
        p.product_id,
        p.product_name,
        SUM(oi.quantity)::bigint AS units_sold,
        SUM(oi.quantity * oi.unit_price)::numeric(14, 2) AS revenue
    FROM orders AS o
    JOIN order_items AS oi ON oi.order_id = o.order_id
    JOIN products AS p ON p.product_id = oi.product_id
    WHERE o.order_status = 'completed'
    GROUP BY date_trunc('month', o.order_date)::date, p.product_id, p.product_name
),
ranked_products AS (
    SELECT
        sales_month,
        product_id,
        product_name,
        units_sold,
        revenue,
        DENSE_RANK() OVER (
            PARTITION BY sales_month
            ORDER BY revenue DESC
        ) AS monthly_revenue_rank
    FROM product_monthly_sales
)
SELECT sales_month, product_id, product_name, units_sold, revenue, monthly_revenue_rank
FROM ranked_products
WHERE monthly_revenue_rank <= 3
ORDER BY sales_month, monthly_revenue_rank, product_name;

-- 3. Classement cumulatif des clients et part du chiffre d'affaires total.
WITH customer_sales AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        SUM(oi.quantity * oi.unit_price)::numeric(14, 2) AS revenue
    FROM customers AS c
    JOIN orders AS o ON o.customer_id = c.customer_id
    JOIN order_items AS oi ON oi.order_id = o.order_id
    WHERE o.order_status = 'completed'
    GROUP BY c.customer_id, c.first_name, c.last_name
),
ranked_customer_sales AS (
    SELECT
        customer_id,
        first_name,
        last_name,
        revenue,
        DENSE_RANK() OVER (ORDER BY revenue DESC) AS revenue_rank,
        SUM(revenue) OVER (
            ORDER BY revenue DESC, customer_id
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_revenue,
        SUM(revenue) OVER () AS total_revenue
    FROM customer_sales
)
SELECT
    customer_id,
    first_name,
    last_name,
    revenue,
    revenue_rank,
    cumulative_revenue::numeric(14, 2) AS cumulative_revenue,
    ROUND(100 * revenue / NULLIF(total_revenue, 0), 2) AS revenue_share_pct
FROM ranked_customer_sales
ORDER BY revenue_rank, customer_id;
