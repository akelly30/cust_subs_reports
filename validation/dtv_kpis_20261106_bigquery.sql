-- Ground truth for the exact four queries supplied by Sky on 2026-11-20.
-- NOTE: AtScale queries must be filtered/grouped by cal_date, preferably one day.
-- This query is provided for execution in BigQuery; not run in this package.
SELECT
  cal_date,
  COUNT(DISTINCT IF(sod_dtv_base = 1, portfolio_id, NULL)) AS opening_dtv_base,
  COUNT(DISTINCT IF(sod_dtv_base = 0 AND eod_dtv_base = 1, portfolio_id, NULL)) AS adds,
  -COUNT(DISTINCT IF(sod_dtv_base = 1 AND eod_dtv_base = 0, portfolio_id, NULL)) AS removes,
  COUNT(DISTINCT IF(eod_dtv_base = 1, portfolio_id, NULL)) AS closing_dtv_base,
  COUNT(DISTINCT IF(eod_dtv_base = 1, portfolio_id, NULL))
    - COUNT(DISTINCT IF(sod_dtv_base = 1, portfolio_id, NULL)) AS net_growth,
  COUNT(DISTINCT IF(eod_dtv_base = 1, portfolio_id, NULL))
    - COUNT(DISTINCT IF(sod_dtv_base = 1, portfolio_id, NULL))
    - COUNT(DISTINCT IF(sod_dtv_base = 0 AND eod_dtv_base = 1, portfolio_id, NULL))
    + COUNT(DISTINCT IF(sod_dtv_base = 1 AND eod_dtv_base = 0, portfolio_id, NULL)) AS movement_reconciliation_delta,
  COUNT(*) AS source_row_count,
  COUNT(DISTINCT portfolio_id) AS total_distinct_portfolios
FROM `skyuk-uk-vis-cust-res-p1-lab.key_tables.transformed_subscriptions_portfolio`
WHERE cal_date = DATE '2026-11-06'
GROUP BY 1;
