# human resources model
connection: "snowflake_production"

include: "vena*[!.][!z].view.lkml"
include: "namely_employees.view"
include: "namely_demographics.view"


fiscal_month_offset: -11 # Looker syntax to allow FQ to be mapped to +1Y and 1M

explore: namely_employees{
  label: "Namely Employee Data"
}

explore: namely_demographics {
  label: "Namely Demographics"
}

explore: namely_headcount_historical {
  label: "Namely Headcount (Historical)"
}

# Commented out till future ETL for finance data is built out.

# # this model is hidden for the User & developer roles/groups
# explore: vena_report {
#   # we only want to expose the headcount data coming from Vena
#   sql_always_where: ${category} = 'Headcount' ;;
#   always_filter: {
#     filters: {
#       field: snapshot_date
#       value: "Most Recent Snapshot"
#     }
#   }
# }
