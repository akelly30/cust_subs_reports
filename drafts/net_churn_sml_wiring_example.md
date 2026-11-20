# Net Churn SML wiring ... DRAFT ONLY; not for deployment

Sky's screenshot specifies: `Net Churn = Removes + Reinstatements + Back in Policy`.
The individual reinstatement and back-in-policy predicates, source fields and distinct-counting grain have **not** been provided.
The screenshot gives -2131 + Reinstatements + Back in Policy = -1114, so the combined positive total is 1017, but do **not** use 1017 as a hard-coded business formula.

**If Sky confirms that both count distinct portfolios**, append two conditional portfolio keys as dataset calculated columns:

```yaml
# DRAFT EXAMPLES. Keep commented until predicates are approved.
# - name: dtv_reinstatement_portfolio_key
#   data_type: string
#   sql: "CASE WHEN <APPROVED_REINSTATEMENT_RULE> THEN portfolio_id ELSE NULL END"
# - name: dtv_back_in_policy_portfolio_key
#   data_type: string
#   sql: "CASE WHEN <APPROVED_BACK_IN_POLICY_RULE> THEN portfolio_id ELSE NULL END"
```

```yaml
# DRAFT metrics/m_sky_dtv_reinstatements.yml
unique_name: m_sky_dtv_reinstatements
object_type: metric
label: Reinstatements
calculation_method: count distinct
dataset: transformed_subscriptions_portfolio
column: dtv_reinstatement_portfolio_key
```
```yaml
# DRAFT metrics/m_sky_dtv_back_in_policy.yml
unique_name: m_sky_dtv_back_in_policy
object_type: metric
label: Back in Policy
calculation_method: count distinct
dataset: transformed_subscriptions_portfolio
column: dtv_back_in_policy_portfolio_key
```
```yaml
# DRAFT calculations/cm_sky_dtv_net_churn.yml
unique_name: cm_sky_dtv_net_churn
object_type: metric_calc
label: Net Churn
expression: '[Measures].[cm_sky_dtv_removes] + [Measures].[m_sky_dtv_reinstatements] + [Measures].[m_sky_dtv_back_in_policy]'
```

Do not add these files to the active model until exact predicates, counting grain and target results are approved. A status reversal can require event history unavailable in the daily snapshot table.
