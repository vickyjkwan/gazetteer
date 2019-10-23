# human resources model
connection: "data_warehouse"

include: "callidus*.view.lkml"
include: "sf__*[!.][!z].view.lkml"
include: "stripe_charges*.view.lkml"

fiscal_month_offset: -11 # Looker syntax to allow FQ to be mapped to +1Y and 1M

explore: quotas {
  from: callidus_positions

  join: employees {
    relationship: one_to_one
    from: callidus_participants
    sql_on: ${employees.id} = ${quotas.employee_id} ;;
  }

  join: account_owners {
    from: sf__users
    sql_on: ${account_owners.email} = ${employees.email} ;;
    relationship: one_to_one
  }

  join: sf__opportunities {
    view_label: "Opportunities"
    from: sf__opportunities_sales
    sql_on: ${sf__opportunities.account_id} = ${sf__accounts.id} ;;
    relationship: one_to_many
  }

  join: sf__accounts {
    view_label: "Accounts"
    sql_on: ${account_owners.id} = ${sf__accounts.owner_id} ;;
    relationship: one_to_many
  }

  join: opportunity_products {
    from: sf__opportunity_products_extended
    sql_on: ${sf__opportunities.id} = ${opportunity_products.opportunity_id} ;;
    relationship: one_to_many
  }

  join: cloud_revenue {
    from: stripe_charges
    sql_on: ${cloud_revenue.created_month} = ${sf__opportunities.close_month} ;;
    relationship: many_to_many
  }

  join: sf__leads {
    view_label: "Leads"
    sql_on: ${sf__leads.converted_opportunity_id} = ${sf__opportunities.id} ;;
    relationship: one_to_one
  }
}
