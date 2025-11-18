WITH dedup AS (
  SELECT *,
   ROW_NUMBER() OVER (
     PARTITION BY order_id, customer_id, product_id, amount, created_at, currency
     ORDER BY created_at
   ) AS rn
  FROM orders_raw
),

fixed_amount AS (
  SELECT
      order_id,
      customer_id,
      product_id,
      CASE 
        WHEN amount < 0 THEN 0
        WHEN amount IS NULL THEN (SELECT MEDIAN(amount) FROM orders_raw WHERE amount > 0)
        ELSE amount
      END AS amount_fixed,
      UPPER(currency) AS currency,
      created_at
  FROM dedup
  WHERE rn = 1
),

usd AS (
  SELECT
    *,
    CASE 
      WHEN currency = 'USD' THEN amount_fixed
      WHEN currency = 'INR' THEN amount_fixed * 0.012
      WHEN currency = 'SGD' THEN amount_fixed * 0.73
      WHEN currency = 'EUR' THEN amount_fixed * 1.08
      ELSE amount_fixed
    END AS amount_usd
  FROM fixed_amount
)

SELECT * FROM usd;