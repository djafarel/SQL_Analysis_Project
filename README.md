# Analyse des ventes avec SQL

Projet de portfolio Data Analyst consacré à l'analyse d'un jeu de données e-commerce fictif avec PostgreSQL. Il couvre la modélisation relationnelle, la qualité des données, les indicateurs commerciaux et des analyses SQL avancées.

> **Données de démonstration uniquement.** Tous les clients, produits, commandes et montants de ce dépôt sont fictifs. Les adresses utilisent le domaine réservé `.test` ; aucune donnée personnelle réelle n'est utilisée.

## Objectifs

- Modéliser des clients, produits, commandes et lignes de commande avec des contraintes relationnelles.
- Contrôler les doublons, champs requis, incohérences et relations orphelines.
- Calculer le chiffre d'affaires reconnu, son évolution mensuelle, les produits et clients en tête, ainsi que le panier moyen.
- Illustrer l'utilisation des CTE, fonctions de fenêtre et classements.

## Technologies

- PostgreSQL 14 ou supérieur
- `psql` (client en ligne de commande fourni avec PostgreSQL)
- SQL standard PostgreSQL ; aucun paquet ou service tiers n'est requis

## Structure

```text
.
├── docs/
│   ├── indicateurs.md
│   └── schema.md
├── sql/
│   ├── 01_create_tables.sql
│   ├── 02_insert_data.sql
│   ├── 03_data_quality.sql
│   ├── 04_sales_analysis.sql
│   └── 05_advanced_analysis.sql
├── .gitignore
└── README.md
```

## Installation et exécution

Créez une base PostgreSQL vide, puis exécutez les scripts dans l'ordre. Par exemple, dans PowerShell depuis la racine du dépôt :

```powershell
createdb -U postgres analyse_ventes
psql -U postgres -d analyse_ventes -v ON_ERROR_STOP=1 -f sql\01_create_tables.sql
psql -U postgres -d analyse_ventes -v ON_ERROR_STOP=1 -f sql\02_insert_data.sql
psql -U postgres -d analyse_ventes -v ON_ERROR_STOP=1 -f sql\03_data_quality.sql
psql -U postgres -d analyse_ventes -v ON_ERROR_STOP=1 -f sql\04_sales_analysis.sql
psql -U postgres -d analyse_ventes -v ON_ERROR_STOP=1 -f sql\05_advanced_analysis.sql
```

Adaptez `postgres` au rôle de votre installation. Sous Linux ou macOS, remplacez les séparateurs de chemin Windows par `/`. Les scripts d'analyse sont consultables et exécutables séparément après le chargement des tables et des données.

### Attention au rechargement des données

`01_create_tables.sql` crée les tables et index s'ils n'existent pas. Le script `02_insert_data.sql` **vide les quatre tables du projet avant de recharger le jeu de démonstration**, afin de rendre son résultat reproductible. Exécutez-le uniquement dans une base dédiée à ce projet : `TRUNCATE ... CASCADE` supprime les données qui s'y trouvent déjà.

## Utilisation et interprétation

1. Inspectez le modèle décrit dans [`docs/schema.md`](docs/schema.md).
2. Lancez `03_data_quality.sql` ; les contrôles sont des requêtes de diagnostic et retournent les lignes problématiques éventuelles.
3. Lancez `04_sales_analysis.sql` pour les indicateurs descriptifs.
4. Lancez `05_advanced_analysis.sql` pour les classements et tendances avec CTE et fonctions de fenêtre.
5. Consultez [`docs/indicateurs.md`](docs/indicateurs.md) pour les définitions et limites des métriques.

Les analyses de ventes incluent uniquement les commandes au statut `completed`. Les commandes `pending` et `cancelled` sont exclues du chiffre d'affaires. Les prix unitaires des lignes sont des instantanés du prix au moment de la commande. En l'absence de coûts d'achat, le chiffre d'affaires par client est un indicateur de ventes générées, **pas** une mesure de bénéfice ou de rentabilité nette.

## Résultats et validation

Ce dépôt fournit les requêtes et les données d'entrée, pas des résultats d'exécution pré-calculés. Les résultats numériques dépendent de l'exécution des scripts sur une instance PostgreSQL ; aucun total ou classement n'est présenté ici comme ayant été exécuté. Sur le jeu fourni, les contrôles de doublons, champs requis et intégrité sont conçus pour ne relever aucune anomalie. Cette attente doit être confirmée en exécutant les scripts dans PostgreSQL.

## Licence et réutilisation

Projet pédagogique libre de réutilisation. Les données de démonstration ne représentent aucune personne ni entreprise réelle.
