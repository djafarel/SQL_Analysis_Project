-- Jeu de démonstration entièrement fictif et déterministe.
-- Les adresses .test et les identités ci-dessous ne désignent pas de personnes réelles.
-- ATTENTION : ce script vide les tables du projet avant de recharger les données.

TRUNCATE TABLE order_items, orders, products, customers RESTART IDENTITY CASCADE;

INSERT INTO customers (customer_id, first_name, last_name, email, created_at) VALUES
    (1, 'Alex', 'Martin', 'customer01@example.test', '2025-01-01 09:00:00'),
    (2, 'Camille', 'Bernard', 'customer02@example.test', '2025-01-02 09:00:00'),
    (3, 'Jordan', 'Petit', 'customer03@example.test', '2025-01-03 09:00:00'),
    (4, 'Sam', 'Robert', 'customer04@example.test', '2025-01-04 09:00:00'),
    (5, 'Taylor', 'Richard', 'customer05@example.test', '2025-01-05 09:00:00'),
    (6, 'Morgan', 'Durand', 'customer06@example.test', '2025-01-06 09:00:00'),
    (7, 'Charlie', 'Dubois', 'customer07@example.test', '2025-01-07 09:00:00'),
    (8, 'Avery', 'Moreau', 'customer08@example.test', '2025-01-08 09:00:00'),
    (9, 'Riley', 'Laurent', 'customer09@example.test', '2025-01-09 09:00:00'),
    (10, 'Casey', 'Simon', 'customer10@example.test', '2025-01-10 09:00:00');

INSERT INTO products (product_id, product_name, category, unit_price, is_active) VALUES
    (1, 'Ergonomic keyboard', 'Accessories', 79.99, true),
    (2, 'Wireless mouse', 'Accessories', 29.99, true),
    (3, 'USB-C hub', 'Accessories', 49.50, true),
    (4, '27-inch monitor', 'Displays', 229.00, true),
    (5, 'Laptop stand', 'Accessories', 39.90, true),
    (6, 'Over-ear headset', 'Audio', 89.00, true),
    (7, 'HD webcam', 'Video', 59.00, true),
    (8, '1 TB SSD', 'Storage', 99.00, true),
    (9, 'Mechanical keyboard', 'Accessories', 119.00, true),
    (10, 'USB-C cable', 'Accessories', 12.50, true);

INSERT INTO orders (order_id, customer_id, order_date, order_status) VALUES
    (1,  1, '2025-01-05 10:15:00', 'completed'),
    (2,  2, '2025-01-10 14:20:00', 'completed'),
    (3,  3, '2025-01-15 11:30:00', 'completed'),
    (4,  1, '2025-01-20 16:45:00', 'cancelled'),
    (5,  4, '2025-01-25 09:10:00', 'completed'),
    (6,  5, '2025-02-02 13:00:00', 'completed'),
    (7,  2, '2025-02-08 15:35:00', 'completed'),
    (8,  6, '2025-02-12 10:00:00', 'pending'),
    (9,  3, '2025-02-15 12:25:00', 'completed'),
    (10, 7, '2025-02-20 17:05:00', 'completed'),
    (11, 1, '2025-03-01 09:45:00', 'completed'),
    (12, 8, '2025-03-05 11:15:00', 'completed'),
    (13, 4, '2025-03-10 14:30:00', 'cancelled'),
    (14, 5, '2025-03-15 16:00:00', 'completed'),
    (15, 2, '2025-03-20 10:40:00', 'completed'),
    (16, 9, '2025-04-02 13:20:00', 'completed'),
    (17, 3, '2025-04-10 15:50:00', 'completed'),
    (18, 6, '2025-04-14 09:25:00', 'completed'),
    (19, 10, '2025-04-22 12:10:00', 'pending'),
    (20, 1, '2025-05-03 11:05:00', 'completed'),
    (21, 7, '2025-05-09 14:45:00', 'completed'),
    (22, 8, '2025-05-17 16:30:00', 'cancelled'),
    (23, 5, '2025-06-04 10:50:00', 'completed'),
    (24, 9, '2025-06-18 13:35:00', 'completed');

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
    (1, 1, 1, 79.99), (1, 2, 2, 29.99),
    (2, 4, 1, 229.00),
    (3, 3, 1, 49.50), (3, 10, 2, 12.50),
    (4, 2, 1, 29.99),
    (5, 4, 1, 229.00), (5, 5, 1, 39.90),
    (6, 8, 1, 99.00),
    (7, 6, 1, 89.00), (7, 2, 1, 29.99),
    (8, 7, 1, 59.00),
    (9, 1, 1, 79.99), (9, 7, 1, 59.00),
    (10, 5, 1, 39.90), (10, 2, 1, 29.99),
    (11, 4, 1, 229.00), (11, 3, 1, 49.50),
    (12, 6, 1, 89.00), (12, 8, 1, 99.00),
    (13, 4, 1, 229.00),
    (14, 1, 1, 79.99), (14, 8, 1, 99.00),
    (15, 7, 1, 59.00), (15, 10, 1, 12.50),
    (16, 4, 1, 229.00), (16, 6, 1, 89.00),
    (17, 8, 1, 99.00), (17, 3, 1, 49.50),
    (18, 2, 2, 29.99), (18, 7, 1, 59.00),
    (19, 1, 1, 79.99),
    (20, 4, 1, 229.00), (20, 5, 1, 39.90),
    (21, 6, 1, 89.00), (21, 7, 1, 59.00), (21, 2, 1, 29.99),
    (22, 8, 1, 99.00),
    (23, 9, 1, 119.00), (23, 10, 2, 12.50),
    (24, 4, 1, 229.00), (24, 8, 1, 99.00), (24, 3, 1, 49.50);

-- Synchronise les séquences après l'insertion d'identifiants explicites.
SELECT setval(pg_get_serial_sequence('customers', 'customer_id'),
              (SELECT MAX(customer_id) FROM customers));
SELECT setval(pg_get_serial_sequence('products', 'product_id'),
              (SELECT MAX(product_id) FROM products));
SELECT setval(pg_get_serial_sequence('orders', 'order_id'),
              (SELECT MAX(order_id) FROM orders));
