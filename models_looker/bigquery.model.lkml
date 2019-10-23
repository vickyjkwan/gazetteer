connection: "bigquery_production"

include: "clari*.view.lkml"                       # include all views in this project

include: "finance_*"

include: "tech_diversity.view.lkml"


fiscal_month_offset: -11

# model level access grant

access_grant: can_view_bigquery_finance_data {
  user_attribute: access_bigquery_finance_data
  allowed_values: [ "yes" ]
}


explore: clari_pulse_breakdown {}
explore: clari_pulse_conversion_breakdown {}
explore: finance_arr {}
explore: finance_renewal_retention_metrics {}
explore: finance_monthly_costs {}
explore: finance_monthly_renewal_retention {}
explore: finance_monthly_cash_burn {}
explore: finance_monthly_revenue_forecast {}
explore: finance_planned_headcount {}
explore: tech_diversity {}
