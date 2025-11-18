WITH ranked AS (
  SELECT
      customer_id,
      LOWER(email) AS email,
      REGEXP_REPLACE(phone, '[^0-9]', '') AS phone_digits,
      country_code,
      COALESCE(created_at, '1900-01-01') AS created_at,
      updated_at,
      ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY updated_at DESC NULLS LAST) AS rn
  FROM customers_raw
),

clean AS (
  SELECT
      customer_id,
      email,
      CASE 
        WHEN LENGTH(phone_digits) = 10 THEN phone_digits
        ELSE 'Unknown'
      END AS phone,
      CASE
        WHEN UPPER(country_code) IN ('US','USA','UNITEDSTATES') THEN 'US'
        WHEN UPPER(country_code) IN ('IND','INDIA') THEN 'IN'
        WHEN UPPER(country_code) IN ('SG','SINGAPORE') THEN 'SG'
        ELSE 'Unknown'
      END AS country_code,
      created_at,
      updated_at
  FROM ranked
  WHERE rn = 1
)

SELECT *,
  CASE 
    WHEN email IS NULL 
      AND phone = 'Unknown'
      AND country_code = 'Unknown'
    THEN 'Invalid Customer'
    ELSE NULL
  END AS status
FROM clean;