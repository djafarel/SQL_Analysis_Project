# Définitions des indicateurs

Les requêtes de `sql/04_sales_analysis.sql` et `sql/05_advanced_analysis.sql` filtrent les commandes dont `orders.order_status = 'completed'`.

| Indicateur | Définition dans ce projet | Limite d'interprétation |
|---|---|---|
| Chiffre d'affaires reconnu | Somme de `quantity × unit_price` des lignes de commandes terminées | Montant nominal ; taxes, remboursements, remises et devise ne sont pas modélisés |
| Ventes mensuelles | Même somme agrégée par mois de `order_date` | La requête descriptive affiche les mois avec ventes ; l'analyse avancée réintroduit aussi les mois intermédiaires à zéro |
| Unités vendues | Somme des quantités sur les commandes terminées | Exclut les commandes en attente et annulées |
| Produit le plus vendu | Classement par unités écoulées, puis chiffre d'affaires en cas d'égalité | La liste descriptive est limitée aux dix premiers |
| Client avec le plus de ventes | Somme des montants de lignes terminées regroupée par client | Il s'agit de chiffre d'affaires généré, et non de bénéfice ou de rentabilité nette |
| Panier moyen | Moyenne des montants par commande terminée | Une commande terminée sans lignes compterait pour zéro ; le contrôle qualité la signale |
| Évolution mensuelle | Variation et pourcentage par rapport au mois civil précédent | Si le mois précédent vaut zéro, le pourcentage est `NULL` (division non définie) |
| Part du chiffre d'affaires client | Chiffre d'affaires du client divisé par le total des clients classés | Les clients sans commande terminée ne figurent pas dans ce classement |

Les scripts SQL définissent les calculs, mais aucun résultat chiffré n'est embarqué comme résultat exécuté. Il faut exécuter les requêtes sur PostgreSQL pour obtenir les valeurs du jeu chargé.
