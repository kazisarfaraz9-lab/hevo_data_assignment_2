# Hevo Data Assignment — SQL Transformations

This repository contains SQL DDL, sample inserts, and transformation queries used to clean and merge a small e-commerce-like dataset for the assessment.

**Project structure**
- `SQL/` : table definitions and sample data inserts (`*_raw.sql`, `insert_*.sql`, `country_dim.sql`).
- `Transformations/` : cleaning and enrichment queries (`customers_cleaned.sql`, `orders_cleaned.sql`, `products_cleaned.sql`, `merged_cleaned_dataset.sql`).

**Purpose**
- Demonstrate data cleaning, deduplication, normalization, and simple enrichment (currency conversion) using SQL.

Prerequisites
- A SQL engine that supports standard window functions and common string / aggregate functions. Postgres 9.6+ or later is recommended for best compatibility (window functions, `INITCAP`, `REGEXP_REPLACE`, and `PERCENTILE_CONT`).
- `psql` client (or another SQL client) to run the files from the command line.

Quick setup (example using PostgreSQL and PowerShell)

1. Create or choose a database (example uses `hevo_assignment`):

```powershell
# create database (run as a user with privileges)
psql -h <host> -U <user> -c "CREATE DATABASE hevo_assignment;"
```

2. Run the DDL files to create raw tables:

```powershell
psql -h <host> -U <user> -d hevo_assignment -f "SQL\country_dim.sql"
psql -h <host> -U <user> -d hevo_assignment -f "SQL\customers_raw.sql"
psql -h <host> -U <user> -d hevo_assignment -f "SQL\products_raw.sql"
psql -h <host> -U <user> -d hevo_assignment -f "SQL\orders_raw.sql"
```

3. Insert the sample data:

```powershell
psql -h <host> -U <user> -d hevo_assignment -f "SQL\insert_country_dim.sql"
psql -h <host> -U <user> -d hevo_assignment -f "SQL\insert_customers_raw.sql"
psql -h <host> -U <user> -d hevo_assignment -f "SQL\insert_products_raw.sql"
psql -h <host> -U <user> -d hevo_assignment -f "SQL\insert_orders_raw.sql"
```

4. Run the transformations (note: most files are `SELECT` queries — to persist results, wrap them with `CREATE TABLE AS` or run them in your client and export the output):

```powershell
psql -h <host> -U <user> -d hevo_assignment -f "Transformations\customers_cleaned.sql"
psql -h <host> -U <user> -d hevo_assignment -f "Transformations\products_cleaned.sql"
psql -h <host> -U <user> -d hevo_assignment -f "Transformations\orders_cleaned.sql"
psql -h <host> -U <user> -d hevo_assignment -f "Transformations\merged_cleaned_dataset.sql"
```

Notes on running and persistence
- The transformation files currently contain `SELECT` statements (not `CREATE TABLE AS`). If you want persistent cleaned tables, add `CREATE TABLE cleaned_customers AS` (or `CREATE TABLE IF NOT EXISTS ...`) before the main `SELECT`, or run the `SELECT` and direct the output to a file.

Key assumptions and business rules
- Latest customer row: `customers_cleaned.sql` keeps the most recently `updated_at` row per `customer_id` (tie-breakers are not fully deterministic if timestamps match).
- Phone normalization: only 10-digit phone numbers are considered valid; others become `Unknown`.
- Country mapping: a small hard-coded mapping is used in `customers_cleaned.sql`. The repository also contains `country_dim.sql` — consider joining to that table instead of hard-coded `CASE` statements for maintainability.
- Orders: negative `amount` values are set to `0`. NULL `amount` values are replaced by the median of positive amounts (note: `MEDIAN()` is used in the provided file but is not a standard Postgres function).
- Currency conversion: fixed conversion rates are embedded in `orders_cleaned.sql` for demonstration. For production use, fetch rates from a maintained table or external service.

Compatibility notes / gotchas
- `MEDIAN(amount)` may not exist in your SQL engine. In Postgres, replace that with `PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY amount)` or compute median in a CTE.
- `INITCAP`, `REGEXP_REPLACE`, window functions, and `ROW_NUMBER()` are used; ensure your engine supports these functions.
- `merged_cleaned_dataset.sql` currently joins the raw tables. For a fully cleaned merged dataset, update it to join the cleaned outputs (`customers_cleaned`, `products_cleaned`, `orders_cleaned`) or wrap the transformation SELECTs as CTEs.