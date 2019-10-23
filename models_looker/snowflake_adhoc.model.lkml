connection: "snowflake_production"
include: "marketo_lead_snapshot_20190403.view.lkml"
include: "sf__leads.view.lkml"
include: "wootric_*"
include: "jira_*"
include: "sf__accounts.view.lkml"

fiscal_month_offset: -11

explore: marketo_lead_snapshot_20190403 {
  sql_table_name: SEGMENT.MARKETO.lead_snapshot_20190403 ;;
  sql_always_where: NOT ${sf__leads.is_deleted} OR ${sf__leads.is_deleted} IS NULL;;
  join: sf__leads {
    sql_table_name: SEGMENT.SALESFORCE.LEADS ;;
    sql_on: ${marketo_lead_snapshot_20190403.marketo_sfdc_id} = ${sf__leads.id} ;;
    view_label: "Leads"
    relationship: one_to_one
  }
}

explore: wootric_nps {}
explore: wootric_ces {}
explore: jira_issues {
  label: "VoC (JIRA)"

  join: snowflake_sf__accounts {
    sql_on: ${jira_issues.sfdc_id} = ${snowflake_sf__accounts.id};;
    relationship: many_to_one
  }
}
