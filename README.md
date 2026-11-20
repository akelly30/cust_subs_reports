# 20261120 – AKYAT – AtScale – Sky: DTV KPI SML from confirmed distinct-portfolio SQL

## Outcome
This package **replaces the earlier sum/row-count KPI definitions** with the four exact `COUNT(DISTINCT portfolio_id)` SQL business rules supplied in chat on 2026-11-20.

| Visible metric | SML implementation | Status |
|---|---|---|
| Opening DTV Base | `COUNT(DISTINCT CASE WHEN sod_dtv_base=1 THEN portfolio_id END)` | Defined |
| Adds | `COUNT(DISTINCT CASE WHEN sod_dtv_base=0 AND eod_dtv_base=1 THEN portfolio_id END)` | Defined |
| Removes | Negative of `COUNT(DISTINCT CASE WHEN sod_dtv_base=1 AND eod_dtv_base=0 THEN portfolio_id END)` | Defined |
| Closing DTV Base | `COUNT(DISTINCT CASE WHEN eod_dtv_base=1 THEN portfolio_id END)` | Defined |
| Net Growth | Closing DTV Base minus Opening DTV Base | Defined |
| Net Churn | Removes + Reinstatements + Back in Policy | NOT IMPLEMENTED: predicates missing |

For all four base metrics, dataset SQL creates a `portfolio_id` key only if the condition holds, or NULL otherwise. `count distinct` ignores the NULLs. The SML calculation `cm_sky_dtv_removes` reverses the sign of the underlying unsigned metric to match Sky's reference report.

The source table is `skyuk-uk-vis-cust-res-p1-lab.key_tables.transformed_subscriptions_portfolio` in the BigQuery SQL supplied. **Do not assume this matches the production warehouse scope.**

## Files and deployment checklist

- `catalog.yml`: starter catalog. For an existing Git repository retain its approved catalog configuration.
- `datasets/transformed_subscriptions_portfolio.yml`: one dataset, 495 physical columns as copied from Sky's supplied data dictionary plus four calculated portfolio-key columns. The placeholder `connection_id` **must** be replaced with the precise AtScale BigQuery connection ID. Confirm the physical table resolves to the correct project/dataset/table through that connection.
- `dimensions/`: date and portfolio degenerate dimensions from the same dataset; no external dimension joins.
- `metrics/`: four exact distinct-count base metrics, with Removes unsigned internally.
- `calculations/`: displayed signed Removes, Net Growth, and a QA reconciliation delta.
- `models/phase1_dtv_kpis.yml`: exposes five defined business metrics, one QA metric, and two dimensions.
- `validation/dtv_kpis_20261106_bigquery.sql`: exact test benchmark against `2026-11-06`.
- `drafts/`: Net Churn requirements and future templates, not active SML objects.

1. Use a development/test Git repo or branch; the previous screenshot showed production AtScale on `main`.
2. Configure and verify the dataset's connection and physical BigQuery table mapping. Prefer using an imported dataset YAML from Sky's existing AtScale workspace to avoid incorrect connection properties.
3. If your repo already contains the dataset, **merge just the four new computed columns** and do not replace its connection-specific metadata or catalog.
4. Keep all six new KPI objects isolated from earlier model artifacts to avoid duplicate `unique_name` conflicts.
5. Run static SML validation (SML CLI / Design Center), then deploy into nonproduction and run AtScale queries with `cal_date = 2026-11-06`.
6. Compare with the Sky business reference, and investigate any deviations; do not adjust definitions to force a match.

## Reconciliation status
Reference on 2026-11-06: Opening 4,941,665; Adds 209; Removes -2,131; Closing 4,939,746; Net Growth -1,919; Net Churn -1,114.
Previously shared BigQuery screenshot showed a `COUNT(DISTINCT portfolio_id)` result of **2,123** for qualifying Removes (unsigned), a gap of **8** against Sky's reference of 2,131. This difference is unresolved. The other four metrics were **not shown validated together**.

**Important:** Distinct portfolio counts are not additive across dates. Use the Date dimension to group by each snapshot day or filter to exactly one day. Do not sum daily distinct counts to obtain a multi-day unique total.

## Evidence statement
This revision has been YAML-parsed and cross-reference checked locally. It has **not** passed SML CLI validation, deployment, warehouse execution through AtScale, BI parity, or Sky acceptance. The test SQL has not been run by this package.
