# Dictionnaire des données

Le schéma représente un petit catalogue de vente. Les données chargées par `sql/02_insert_data.sql` sont fictives et destinées aux exercices ; les dates et prix des lignes sont des valeurs de démonstration.

## Tables

| Table | Grain | Colonnes principales |
|---|---|---|
| `customers` | Un client synthétique | `customer_id` (PK), `first_name`, `last_name`, `email` (unique), `created_at` |
| `products` | Un article du catalogue | `product_id` (PK), `product_name` (unique), `category`, `unit_price`, `is_active` |
| `orders` | Une commande d'un client | `order_id` (PK), `customer_id` (FK), `order_date`, `order_status` |
| `order_items` | Un produit par commande | (`order_id`, `product_id`) (PK composite), `quantity`, `unit_price` |

## Relations et règles

- Un client peut avoir zéro ou plusieurs commandes ; chaque commande référence exactement un client.
- Une commande peut comporter plusieurs produits ; chaque ligne référence une commande et un produit.
- Le couple (`order_id`, `product_id`) est unique : une même référence apparaît au plus une fois par commande. Sa quantité est portée par `quantity`.
- Les clés étrangères empêchent les commandes sans client et les lignes sans commande ou produit. La suppression d'une commande supprime ses lignes ; les autres suppressions référencées sont refusées par défaut.
- Les quantités doivent être strictement positives ; les prix du catalogue sont positifs et les prix enregistrés sur une ligne sont positifs ou nuls.
- Les statuts sont `completed`, `pending` et `cancelled`.
- `order_items.unit_price` est un instantané du prix appliqué lors de l'achat. Il ne doit pas être recalculé depuis le prix actuel du catalogue.

## Limites du modèle de démonstration

Le schéma omet notamment devises, taxes, remises, retours, paiements, coûts et adresses. En conséquence, les métriques de ventes sont des montants nominaux issus des lignes de commande ; aucun bénéfice net ne peut être estimé.
