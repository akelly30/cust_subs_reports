# Net Churn ... awaiting Sky business definition

Screenshot dated 06-Nov-2026:
- Removes = -2,131
- Net Churn = -1,114
- Formula: Removes + Reinstatements + Back in Policy

Thus, Reinstatements + Back in Policy = +1,017 (combined).
The two components are not individually defined in the provided screenshot
or in the 495-column `transformed_subscriptions_portfolio` field dictionary.

Do not deploy a synthetic Net Churn metric until Sky confirms:
- The precise start/end state transitions qualifying as Reinstatements.
- The precise definition of Back in Policy, including whether same-day
  reactivations, migrations, and nulls are treated specially.
- Whether the population, date grain, and exclusions match the other DTV KPIs.

Proposed future calculation *after* those two metrics exist:

    [Measures].[cm_sky_dtv_removes] +
    [Measures].[m_sky_dtv_reinstatements] +
    [Measures].[m_sky_dtv_back_in_policy]

This is documentation only, not active SML.
