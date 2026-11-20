-- SKY 2026-11-06: classify DTV primary-viewing SOD->EOD status movements.
-- Discovery only. The output is an aggregate distribution, NOT a final definition of
-- Reinstatements or Back in Policy. No portfolio-level identifiers are returned.
-- Note the query executes against p1-lab, which may not equal the KPI reference scope.
WITH snapshot AS (
  SELECT
    COALESCE(sod_dtv_pv_status, '<NULL>') AS sod_dtv_status,
    COALESCE(eod_dtv_pv_status, '<NULL>') AS eod_dtv_status,
    sod_dtv_base,
    eod_dtv_base,
    portfolio_id,
    sod_dtv_pv_status IS DISTINCT FROM eod_dtv_pv_status AS status_changed,
    sod_dtv_base IS DISTINCT FROM eod_dtv_base AS base_changed
  FROM `skyuk-uk-vis-cust-res-p1-lab.key_tables.transformed_subscriptions_portfolio`
  WHERE cal_date = DATE '2026-11-06'
)
SELECT
  sod_dtv_status,
  eod_dtv_status,
  sod_dtv_base,
  eod_dtv_base,
  COUNT(*) AS row_count,
  COUNT(DISTINCT portfolio_id) AS unique_portfolios,
  COUNTIF(status_changed) AS changed_status_rows,
  COUNTIF(base_changed) AS changed_base_rows
FROM snapshot
WHERE status_changed OR base_changed
GROUP BY 1,2,3,4
ORDER BY row_count DESC, sod_dtv_status, eod_dtv_status;
