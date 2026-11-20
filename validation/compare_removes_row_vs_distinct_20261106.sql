-- Diagnostics only. BigQuery screenshot displayed 2123 distinct qualifying portfolios.
-- Sky reference displays -2131. Execute this to quantify row-grain effects.
SELECT cal_date,
  COUNTIF(sod_dtv_base = 1 AND eod_dtv_base = 0) AS removes_row_count,
  COUNT(DISTINCT IF(sod_dtv_base = 1 AND eod_dtv_base = 0, portfolio_id, NULL)) AS removes_distinct_portfolios,
  COUNTIF(sod_dtv_base = 1 AND eod_dtv_base = 0)
  - COUNT(DISTINCT IF(sod_dtv_base = 1 AND eod_dtv_base = 0, portfolio_id, NULL)) AS duplicate_qualifying_rows
FROM `skyuk-uk-vis-cust-res-p1-lab.key_tables.transformed_subscriptions_portfolio`
WHERE cal_date = DATE '2026-11-06'
GROUP BY 1;
