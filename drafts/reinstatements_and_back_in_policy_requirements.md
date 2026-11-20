# 20261120 – AKYAT – AtScale – Sky: Reinstatements and Back in Policy metric definition gaps

## Sky reference (2026-11-06)

| KPI | Approved screenshot wording | Expected |
|---|---|---:|
| Removes | `sod_dtv_base = 1 and eod_dtv_base = 0` | -2,131 |
| Net Churn | `Removes + Reinstatements + Back in Policy` | -1,114 |

**Arithmetic requirement**: for the reference date, `Reinstatements + Back in Policy = +1,017`.
The screenshot does **not** state the value of either component separately. The newly supplied SQL confirms distinct-portfolio counting only for Opening, Adds, Removes, and Closing; it does not define the grain for these two components.
This is a reconciliation check, not a formula for either component.

## Confirmed available source fields

The supplied `transformed_subscriptions_portfolio (1).xlsx` dictionary has:

- `cal_date` (DATE), `portfolio_id` (STRING)
- `sod_dtv_base`, `eod_dtv_base` (INTEGER)
- `sod_dtv_pv_status`, `eod_dtv_pv_status` (STRING)
- `sod_dtv_pv_first_act_dt`, `eod_dtv_pv_first_act_dt` (timestamps)

It has **no field named** Reinstatements, Back in Policy, or a published qualifying rule for either.
The supplied **Gen AI Call Insights – Semantic Layer LLD** describes active-to-pending-cancel status changes as *intent to churn* and says saves still need to be accounted for, but does not define either KPI.

## Working interpretations to TEST, not implement as confirmed fact

- **Reinstatements:** Could refer to a withdrawn or reversed cancellation or restoration of a DTV subscription. A customer might remain active (`sod_dtv_base=1`, `eod_dtv_base=1`) despite a status reversal. Which statuses, events, and effective dates qualify is unknown.
- **Back in Policy:** Could refer to a previously pending/removed DTV subscription returning to an in-policy state. Its precise meaning is unknown, including whether it is a subset of Reinstatements, separate, or dependent on historical status.

**Do not** equate either metric with the raw `0 -> 1` DTV base transition. Sky's screenshot shows only 209 Adds for the same day, whereas the combined required contribution is 1,017; the categories cannot simply be the same 209 records under an identical row/count grain.

## Questions Sky's KPI owner must answer

1. Which SOD/EOD `dtv_pv_status` codes or underlying cancellation/reinstatement events define each category?
2. Is it a same-day SOD-to-EOD transition, comparison with the previous day, or a rolling historical window?
3. Does the count represent unique `portfolio_id`, subscription events, or rows? How are multiple same-day changes handled?
4. Are Reinstatements and Back in Policy mutually exclusive, and do they overlap Adds or Removes?
5. How should home moves, Sky Q-to-Glass migrations, and other technology changes be treated?
6. What are the expected separate numbers for 2026-11-06, and which project/table/version produced the reference?

## SML implementation after business sign-off

1. Confirm classification predicates using the diagnostic SQL in `validation/profile_dtv_status_transitions_20261106.sql`.
2. After confirming whether both components count distinct portfolios, consider conditional `portfolio_id` keys in the dataset, or a separate properly joined history source if daily snapshots are insufficient.
3. Implement approved aggregation methods for both components. For a *confirmed distinct-portfolio* grain, see `drafts/net_churn_sml_wiring_example.md`; do not assume `sum` or `count distinct` without sign-off.
4. Add the two metrics and one `metric_calc` for Net Churn to the model **only after** predicates are known.
5. Validate statically, deploy to non-production, query for 2026-11-06, reconcile each component and the -1,114 total, and obtain Sky sign-off.

## Evidence status

- Field availability: checked against the uploaded workbook.
- Business formula: confirmed from supplied screenshot.
- Individual reinstatement and back-in-policy predicates: **NOT PROVIDED**.
- SML CLI, deployment, BigQuery runtime diagnostic, BI tool parity: **NOT EXECUTED**.

**Do not promote this model as six fully implemented KPIs.** It currently contains five executable business KPIs (Opening, Adds, Removes, Closing, Net Growth), QA checks, and the separate missing-components workflow.
