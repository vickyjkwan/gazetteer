connection: "data_warehouse"

datagroup: sfdc_oppty_data {
  max_cache_age: "24 hours"
  sql_trigger:
    select DATE_PART('day',max(received_at)) || '-' || DATE_PART('hour',max(received_at)) as day_hour from salesforce.opportunities ;;
}
datagroup: sfdc_lead_and_contact_data {
  max_cache_age: "24 hours"
  sql_trigger:
    WITH leads_and_contacts as (select received_at from salesforce.leads UNION select received_at from salesforce.contacts )
    select DATE_PART('day',max(received_at)) || '-' || DATE_PART('hour',max(received_at)) as day_hour from leads_and_contacts ;;
}

# model-level access grants
access_grant: can_view_revenue_data {
  user_attribute: access_grant_revenue
  allowed_values: [ "yes" ]
}

# include extended views
include: "sf__*[!.][!z].view.lkml"
include: "stripe*[!.][!z].view.lkml"
include: "marketo*[!.][!z].view.lkml"
include: "reghub_dockeruser.view.lkml"
include: "ucp_*[!.][!z].view.lkml"
include: "dtr_*[!.][!z].view.lkml"
include: "finance_revenue_forecast.view.lkml"
include: "sf__opportunity_dockercon_renewals.view.lkml"

# include just SFDC-related LookML dashboards
include: "sf__marketing_leadership.dashboard.lookml"

# Define the Fiscal Year offset
fiscal_month_offset:  -11 # starts in February

explore: sf__accounts {
  persist_for: "24 hours"
  label: "Accounts"
  view_label: "Accounts"
  sql_always_where: NOT ${sf__accounts.is_deleted} ;;

  join: owner {
    from: sf__users
    sql_on: ${sf__accounts.owner_id} = ${owner.id} ;;
    relationship: many_to_one
  }

  join: sf__contacts {
    view_label: "Contacts"
    sql_on: ${sf__accounts.id} = ${sf__contacts.account_id} ;;
    relationship: one_to_many
  }

  join: sf__cases {
    view_label: "Cases"
    sql_on: ${sf__accounts.id} = ${sf__cases.account_id} ;;
    relationship: one_to_many
  }

  join: tam {
    view_label: "TAM"
    from: sf__users
    sql_on: ${sf__accounts.tam} = ${tam.id} ;;
    relationship: many_to_one
  }
}

#
# Explore joins SFDC account and lead objects on an engagio determined custom field
#
explore: sf__accounts_leads_engagio {
  label: "Accounts (Engagio)"
  # Base view of explore
  from: sf__accounts
  # Hide it from the main list -- still accessible via URL
  hidden: yes
  # Label the view in the Explore UI as Accounts (instead of the long explore name)
  view_label: "Accounts"
  # Add a convenient description to Explore
  description: "Accounts and associated leads as identified by engagio"
  # Ignore deleted accounts
  sql_always_where: NOT ${sf__accounts_leads_engagio.is_deleted}
    ;;

  join: sf__leads {
    view_label: "Leads"
    sql_on: ${sf__accounts_leads_engagio.id} = ${sf__leads.engagio_matched_account} ;;
    # One account will have many leads,
    # and a lead (from engagio's perspective) belongs to a single account
    relationship: one_to_many
  }
}

#
# Explore SFDC case, case comments, and related contacts plus accounts
#
explore: sf__cases {
  persist_for: "24 hours"
  label: "Cases"
  # Label the view in the Explore UI as Cases (instead of the long explore name)
  view_label: "Cases"
  # Add a convenient description to Explore
  description: "Cases and associated comments"

  join: sf__case_comments {
    view_label: "Case Comments"
    sql_on: ${sf__cases.id} = ${sf__case_comments.parent_id} ;;
    relationship: one_to_many
  }

  join: sf__accounts {
    view_label: "Case Accounts"
    sql_on: ${sf__cases.account_id} = ${sf__accounts.id} ;;
    relationship: many_to_one
  }

  join: sf__opportunities {
    view_label: "Opportunities"
    sql_on: ${sf__opportunities.account_id} = ${sf__accounts.id} ;;
    relationship: one_to_many
  }

  join: opportunity_products {
    from: sf__opportunity_products
    view_label: "Opportunitiy Products"
    sql_on: ${sf__opportunities.id} = ${opportunity_products.opportunity_id} ;;
    relationship: one_to_many
  }

  join: sf__opportunity_revenue_movements {
    view_label: "Total Booking Movements"
    sql_on: ${sf__opportunity_revenue_movements.account_id} = ${sf__cases.account_id} ;;
    relationship: many_to_many
  }
  join: sf__opportunity_total_revenue {
    view_label: "Total Opportunity Bookings"
    sql_on: ${sf__opportunity_total_revenue.report_date} = ${sf__opportunity_revenue_movements.report_date} ;;
    relationship: many_to_many
  }

  join: sf__contacts {
    view_label: "Case Contacts"
    sql_on: ${sf__cases.contact_id} = ${sf__contacts.id} ;;
    relationship: many_to_one
  }

  join: owners {
    from: sf__users
    view_label: "Case Owners"
    sql_on: ${sf__cases.owner_id} = ${owners.id} ;;
    relationship: many_to_one
  }

  join: creators {
    from: sf__users
    view_label: "Case Creators"
    sql_on: ${sf__cases.created_by_id} = ${creators.id} ;;
    relationship: many_to_one
  }

  join: sf__leads {
    view_label: "Leads"
    sql_on: ${sf__leads.converted_opportunity_id} = ${sf__opportunities.id} ;;
    relationship: one_to_one
  }

}

explore: sf__campaign_members {
  label: "Campaign Members"
  join: sf__campaigns {

    sql_on: ${sf__campaign_members.campaign_id} = ${sf__campaigns.id} ;;
    relationship: many_to_one
  }

  join: sf__leads {
    sql_on: ${sf__campaign_members.lead_id} = ${sf__leads.id} ;;
    relationship: many_to_one
  }

  join: sf__contacts {
    sql_on: ${sf__campaign_members.lead_or_contact_id} = ${sf__contacts.id} ;;
    relationship: many_to_one
  }

  join: docker_users {
    from: reghub_dockeruser
    sql_on: docker_users.email = sf__campaign_members.email ;;
    relationship: many_to_one
  }

  join: ucp_licenses {
    from: ucp_licensing
    sql_on: ucp_licenses.hub_uuid = replace(${docker_users.uuid}, '-','') ;;
    required_joins: [docker_users]
    relationship: many_to_one
  }

  join: ucp_usage {
    sql_on: ucp_usage.license_id = ucp_licenses.license_key ;;
    required_joins: [ucp_licenses]
    relationship: many_to_one
  }
}

explore: sf__campaigns {
  label: "Campaigns"
  view_label: "Campaigns"
}

explore: sf__contacts {
  label: "Contacts"
  view_label: "Contacts"
}

explore: sf__events {
  label: "Events"
  view_label: "Events"
  join: sf__accounts {
    sql_on: ${sf__events.account_id} = ${sf__accounts.id} ;;
    relationship: many_to_one
  }

  join: event_owners {
    from: sf__users
    sql_on: ${sf__events.owner_id} = ${event_owners.id} ;;
    relationship: many_to_one
  }
}

explore: sf__deal_registrations {
  persist_for: "24 hours"
  label: "Deal Registration"
  view_label: "Deal Registration"
  sql_always_where: NOT ${sf__deal_registrations.is_deleted} ;;

  join: sf__accounts {
    view_label: "Account"
    sql_on: sf__accounts.id = ${sf__deal_registrations.account_c} ;;
    relationship: one_to_one
  }
  join: sf__partner_account {
    from: sf__accounts
    view_label: "Partner Account"
    sql_on: sf__accounts.id = ${sf__deal_registrations.partner_account_c} ;;
    relationship: one_to_one
  }
  join: sf__leads {
    view_label: "Lead"
    sql_on: sf__leads.id = sf__deal_registrations.lead_id_c ;;
    relationship: one_to_one
  }
  join: sf__opportunities {
    view_label: "Opportunity"
    sql_on: ${sf__opportunities.id} = ${sf__deal_registrations.opportunity_c} ;;
    relationship: one_to_one
  }
  join: opportunity_products {
    from: sf__opportunity_products
    view_label: "Opportunitiy Products"
    sql_on: ${sf__opportunities.id} = ${opportunity_products.opportunity_id} ;;
    relationship: one_to_many
  }
  join: sf__users {
    view_label: "Creator"
    sql_on: ${sf__users.id} = ${sf__deal_registrations.created_by_id} ;;
    relationship: one_to_one
    }
  join: sf__deal_reg_owner {
    from: sf__users
    view_label: "Owner"
    sql_on: ${sf__users.id} = ${sf__deal_registrations.owner_id} ;;
    relationship: one_to_one
    }
  join: sf__deal_reg_account_owner {
    from: sf__users
    view_label: "Partner Account Owner"
    sql_on: ${sf__users.id} = ${sf__deal_registrations.partner_account_owner_c} ;;
    relationship: one_to_one
    }
}

explore: sf__leads {
  persist_for: "24 hours"
  label: "Leads"
  view_label: "Leads"
  sql_always_where: NOT ${sf__leads.is_deleted} ;;

  join: sf__leads_converted {
    view_label: "Leads Converted"
    sql_on: ${sf__leads_converted.id} = ${sf__leads.id} ;;
    relationship: one_to_one
    fields: [
      id,
      days_from_creation_to_close,
      days_to_mql,
      days_to_sal,
      days_to_sql,
      days_to_close,
      avg_days_from_creation_to_close,
      avg_days_mql_to_convert,
      avg_days_to_close,
      avg_days_to_mql,
      avg_days_to_sal,
      avg_days_to_sql,
      count_distinct_mql,
      count_distinct_sal,
      count_distinct_sql,
      count_distinct_sqo
    ]
  }
  join: lead_owners {
    from: sf__users
    sql_on: ${sf__leads.owner_id} = ${lead_owners.id} ;;
    relationship: many_to_one
  }

  join: sf__accounts {
    view_label: "Accounts"
    sql_on: ${sf__leads.converted_account_id} = ${sf__accounts.id} ;;
    relationship: many_to_one
  }

  join: account_owners {
    from: sf__users
    sql_on: ${sf__accounts.owner_id} = ${account_owners.id} ;;
    relationship: many_to_one
  }

  #     - join: sf__contacts
  #       sql_on: ${sf__leads.converted_contact_id} = ${sf__contacts.id}
  #       relationship: many_to_one

  join: sf__opportunities {
    view_label: "Opportunities"
    sql_on: ${sf__leads.converted_opportunity_id} = ${sf__opportunities.id} ;;
    relationship: many_to_one
  }

  join: opportunity_products {
    from: sf__opportunity_products
    view_label: "Opportunitiy Products"
    sql_on: ${sf__opportunities.id} = ${opportunity_products.opportunity_id} ;;
    relationship: one_to_many
  }

  join: opportunity_owners {
    from: sf__users
    sql_on: ${sf__opportunities.owner_id} = ${opportunity_owners.id} ;;
    relationship: many_to_one
  }

  join: docker_users {
    from: reghub_dockeruser
    sql_on: docker_users.email = sf__leads.email ;;
    relationship: many_to_one
  }

  join: ucp_licenses {
    from: ucp_licensing
    sql_on: ucp_licenses.hub_uuid = replace(${docker_users.uuid}, '-','') ;;
    required_joins: [docker_users]
    relationship: many_to_one
  }

  join: ucp_usage {
    sql_on: ucp_usage.license_id = ucp_licenses.license_key ;;
    required_joins: [ucp_licenses]
    relationship: many_to_one
  }
  join: marketo_leads {
    from: marketo_leads_segment
    sql_on: ${marketo_leads.email} = ${sf__leads.email} ;;
    relationship: many_to_many
  }
  join: marketo_activities {
    from: marketo_lead_activities
    sql_on: ${marketo_activities.lead_id} = ${marketo_leads.id} ;;
    required_joins: [marketo_leads]
    relationship: one_to_many
  }
}

explore: total_active_node_count{
  # defined in the sf__accounts view
}

explore: sf__opportunities {
  persist_with: sfdc_oppty_data
  from: sf__opportunities_extended
  view_label: "Opportunities"
  label: "Opportunities"
  sql_always_where: NOT ${sf__opportunities.is_deleted} ;;

  join: sf__accounts {
    view_label: "Accounts"
    sql_on: ${sf__opportunities.account_id} = ${sf__accounts.id} ;;
    relationship: many_to_one
  }

  join: account_owners {
    from: sf__users
    sql_on: ${sf__accounts.owner_id} = ${account_owners.id} ;;
    relationship: many_to_one
  }

  join: opportunity_contact_roles {
    from: sf__opportunity_contact_role
    sql_on: ${opportunity_contact_roles.opportunity_id} = ${sf__opportunities.id} and NOT ${opportunity_contact_roles.is_deleted} ;;
    relationship: many_to_many
  }

  join: opportunity_contacts {
    from: sf__contacts
    sql_on: ${opportunity_contacts.id} = ${opportunity_contact_roles.contact_id} and NOT ${opportunity_contacts.is_deleted} ;;
    relationship: one_to_many
  }

  join: opportunity_contact_campaign_memberships {
    view_label: "Opportunity Contact Campaign Members (6mo prior to close)"
    from:  sf__campaign_members
    sql_on:
      ${opportunity_contacts.id} = ${opportunity_contact_campaign_memberships.contact_id}
      and ${opportunity_contact_campaign_memberships.created_date} >= DATE_ADD('month', -6, ${sf__opportunities.close_date})
      and NOT ${opportunity_contact_campaign_memberships.is_deleted} ;;
    relationship: one_to_many
  }

  join: opportunity_contact_campaigns {
    view_label: "Opportunity Contact Campaigns (6mo prior to close)"
    from:  sf__campaigns
    sql_on: ${opportunity_contact_campaign_memberships.campaign_id} = ${opportunity_contact_campaigns.id} and NOT ${opportunity_contact_campaigns.is_deleted} ;;
    relationship: many_to_one
  }

  join: sf__opportunity_history {
    view_label: "Opportunity History"
    sql_on: ${sf__opportunity_history.opportunity_id} = ${sf__opportunities.id} ;;
    relationship: one_to_many
  }

  join: sf__opportunity_field_history {
    view_label: "Opportunity Field History"
    sql_on: ${sf__opportunity_field_history.opportunity_id} = ${sf__opportunities.id} ;;
    relationship: one_to_many
  }

  join: campaign_members {
    view_label: "Opportunity Contact Campaign Members (no restriction)"
    from:  sf__campaign_members
    sql_on: ${opportunity_contacts.id} = ${campaign_members.contact_id} ;;
    relationship: one_to_many
  }

  join: campaigns {
    view_label: "Opportunity Contact Campaigns (no restriction)"
    from:  sf__campaigns
    sql_on: ${campaign_members.campaign_id} = ${campaigns.id} ;;
    relationship: many_to_one
  }

  join: opportunity_owners {
    from: sf__users
    sql_on: ${sf__opportunities.owner_id} = ${opportunity_owners.id} ;;
    relationship: many_to_one
  }

  join: opportunity_creators {
    from: sf__users
    sql_on: ${sf__opportunities.created_by_id} = ${opportunity_creators.id} ;;
    # Many opportunities can be created by the same person
    relationship: many_to_one
  }

  join: opportunity_products {
    from: sf__opportunity_products_extended
    sql_on: ${sf__opportunities.id} = ${opportunity_products.opportunity_id} ;;
    relationship: one_to_many
  }

  join: sf__deal_registrations {
    view_label: "Deal Registration"
    sql_on: ${sf__opportunities.id} = ${sf__deal_registrations.opportunity_c} ;;
    relationship: one_to_one
  }

  join: opportunity_primary_campaign {
    from:  sf__campaigns
    view_label: "Primary Campaign"
    sql_on: ${sf__opportunities.campaign_id} = ${opportunity_primary_campaign.id} ;;
    relationship: many_to_one
  }

  join: finance_revenue_forecast {
    view_label: "Bookings Forecast"
    sql_on: ${finance_revenue_forecast.forecast_month} = ${sf__opportunities.close_month} ;;
    relationship: many_to_one
  }

  join: finance_revenue_forecast_quarterly {
    from: finance_revenue_forecast
    view_label: "Quarterly Bookings Forecast"
    sql_on: ${finance_revenue_forecast_quarterly.forecast_fiscal_quarter} = ${sf__opportunities.close_fiscal_quarter} ;;
    relationship: many_to_many
  }

  join: cloud_revenue {
    from: stripe_charges
    sql_on: ${cloud_revenue.created_month} = ${sf__opportunities.close_month} ;;
    relationship: many_to_many
  }

  join: docker_users {
    from: reghub_dockeruser
    sql_on: ${docker_users.domain_name} = ${sf__accounts.domain} ;;
    relationship: many_to_one
  }

  join: ucp_licenses {
    from: ucp_licensing
    sql_on: ${ucp_licenses.hub_uuid} = replace(${docker_users.uuid}, '-','') ;;
    required_joins: [docker_users]
    relationship: many_to_one
  }

  join: ucp_usage {
    sql_on: ${ucp_usage.license_key} = ${ucp_licenses.license_key} ;;
    required_joins: [ucp_licenses]
    relationship: many_to_one
  }
  join: sf__leads {
    view_label: "Leads"
    sql_on: ${sf__leads.converted_opportunity_id} = ${sf__opportunities.id} ;;
    relationship: one_to_one
  }
}

explore: sf__pipeline_ndt {
  persist_for: "24 hours"
  label: "Pipeline"
  view_label: "Pipeline"
}

explore: sf__opportunity_ltm_acv {
  required_access_grants: [ can_view_revenue_data ]
  persist_for: "24 hours"
  label: "LTM ACV"
  description: "Sum of the last 12 months ACV"
  view_label: "LTM ACV"
  join: sf__accounts {
    view_label: "Accounts"
    sql_on: ${sf__opportunity_ltm_acv.account_id} = ${sf__accounts.id} ;;
    relationship: many_to_one
  }
  join: finance_revenue_forecast {
    view_label: "Bookings Forecast"
    sql_on: ${finance_revenue_forecast.forecast_month} = ${sf__opportunity_ltm_acv.report_month} ;;
    relationship: many_to_one
  }
  join: sf__opportunities {
    from: sf__opportunities_extended
    view_label: "Opportunities"
    sql_on: ${sf__opportunity_ltm_acv.opportunity_id} = ${sf__opportunities.id} ;;
    relationship: many_to_one
  }
  # join only opportunities with close dates matching the LTM ACV report dates (used by the Sales/Exec Dashboards)
  join: sf__opportunities_join_on_close_date {
    from: sf__opportunities_extended
    view_label: "Opportunities (Join on Date)"
    sql_on: ${sf__opportunity_ltm_acv.opportunity_id} = ${sf__opportunities_join_on_close_date.id} AND ${sf__opportunities_join_on_close_date.close_date} = ${sf__opportunity_ltm_acv.report_date} ;;
    relationship: many_to_one
  }
  join: opportunity_products {
    from: sf__opportunity_products
    view_label: "Opportunity Products"
    sql_on: ${sf__opportunities_join_on_close_date.id} = ${opportunity_products.opportunity_id} ;;
    relationship: one_to_many
  }
  join: sf__leads {
    view_label: "Leads"
    sql_on: ${sf__leads.converted_opportunity_id} = ${sf__opportunities.id} ;;
    relationship: one_to_one
  }
  join: cloud_revenue {
    from: stripe_charges
    sql_on: ${cloud_revenue.created_month} = ${sf__opportunities.close_month} ;;
    relationship: many_to_many
  }
}

explore: sf__opportunity_total_revenue {
  required_access_grants: [ can_view_revenue_data ]
  persist_for: "24 hours"
  label: "Total Opportunity Revenue"
  view_label: "Total Opportunity Revenue"
  description: "Opportunity Product-Level ACV w/ Daily snapshots of Total Revenue and Bookings Forecasts"
  sql_always_where: ${opportunity_products.end_date} IS NOT NULL ;;
  join: sf__accounts {
    view_label: "Accounts"
    sql_on: ${sf__opportunity_total_revenue.account_id} = ${sf__accounts.id} ;;
    relationship: many_to_one
  }
  join: sf__opportunities {
    view_label: "Opportunities"
    sql_on: ${sf__opportunity_total_revenue.opportunity_id} = ${sf__opportunities.id} ;;
    relationship: one_to_many
  }
  join: opportunity_products {
    from: sf__opportunity_products
    view_label: "Opportunity Products"
    sql_on: ${sf__opportunities.id} = ${opportunity_products.opportunity_id} ;;
    relationship: one_to_many
  }
  join: finance_revenue_forecast {
    view_label: "Bookings Forecast"
    sql_on: ${finance_revenue_forecast.forecast_month} = ${sf__opportunity_total_revenue.report_month} ;;
    relationship: many_to_one
  }
  join: sf__leads {
    view_label: "Leads"
    sql_on: ${sf__leads.converted_opportunity_id} = ${sf__opportunities.id} ;;
    relationship: one_to_one
  }
}

explore: sf__opportunity_revenue_movements {
  required_access_grants: [ can_view_revenue_data ]
  persist_for: "24 hours"
  label: "Total Revenue Movements"
  view_label: "Total Revenue Movements"
  description: "Daily snapshots of Account-level Revenue Movements"
  join: sf__accounts {
    view_label: "Accounts"
    sql_on: ${sf__opportunity_revenue_movements.account_id} = ${sf__accounts.id} ;;
    relationship: many_to_one    # Many account snapshots per account_id
  }
  join: sf__opportunity_total_revenue {
    view_label: "Total Opportunity Revenue"
    sql_on: ${sf__opportunity_total_revenue.report_date} = ${sf__opportunity_revenue_movements.report_date}
      AND ${sf__opportunity_total_revenue.account_id} = ${sf__opportunity_revenue_movements.account_id};;
    relationship: one_to_many    # One account snapshot has many opportunity products
  }
  join: sf__opportunities {
    # Make it possible to lookup Opportunity attributes
    fields: [
      sf__opportunities.id, sf__opportunities.name, sf__opportunities.is_won,
      sf__opportunities.forecast_category, sf__opportunities.close_date,
      sf__opportunities.syb_amount
    ]
    view_label: "Opportunities"
    sql_on: ${sf__opportunity_total_revenue.opportunity_id} = ${sf__opportunities.id} ;;
    relationship: many_to_one    # Many opportunity products per opportunity
  }
  join: finance_revenue_forecast {
    view_label: "Bookings Forecast"
    sql_on: ${finance_revenue_forecast.forecast_month} = ${sf__opportunity_total_revenue.report_month} ;;
    relationship: many_to_one
  }
}


#- explore: sf__opportunity_field_history

#- explore: sf__opportunity_history

#- explore: sf__opportunity_stage

explore: sf__tasks {
  label: "Tasks"
  view_label: "Tasks"
  join: sf__accounts {
    view_label: "Accounts"
    sql_on: ${sf__tasks.account_id} = ${sf__accounts.id} ;;
    relationship: many_to_one
  }
}

explore: sf__users {
  label: "Users"
  view_label: "Users"
  join: sf__opportunities {
    view_label: "Opportunities"
    sql_on: ${sf__opportunities.owner_id} = ${sf__users_opportunities.id} ;;
    relationship: one_to_many
  }

  join: opportunity_products {
    from: sf__opportunity_products
    view_label: "Opportunitiy Products"
    sql_on: ${sf__opportunities.id} = ${opportunity_products.opportunity_id} ;;
    relationship: one_to_many
  }

  join: sf__accounts {
    view_label: "Accounts"
    sql_on: ${sf__opportunities.account_id} = ${sf__accounts.id} ;;
    relationship: many_to_one
  }

  join: sf__users_opportunities {
    view_label: "User Opportunities"
    sql_on: ${sf__users_opportunities.id} = ${sf__users.id} ;;
    relationship: one_to_one
  }
  join: sf__leads {
    view_label: "Leads"
    sql_on: ${sf__leads.converted_opportunity_id} = ${sf__opportunities.id} ;;
    relationship: one_to_one
  }
}

#
# Explore conversion of Lead and Contacts to Opportunities
#
explore: sf__leads_and_contacts {
  description: "Explore both Leads and Contacts conversion to Opportunities.  Conceptually the same as a 'Person' in Marketo."
  label: "Leads and Contacts"
  view_label: "Leads and Contacts"
  join: sf__leads {
    view_label: "Leads"
    sql_on: ${sf__leads_and_contacts.lead_or_contact_id} = ${sf__leads.id} ;;
    relationship: one_to_one
    fields: [
      sf__leads.focused*
    ]
  }
  join: sf__leads_converted {
    view_label: "Leads Converted"
    sql_on: ${sf__leads_converted.id} = ${sf__leads.id} ;;
    relationship: one_to_one
    fields: [
      id,
      days_from_creation_to_close,
      days_to_mql,
      days_to_sal,
      days_to_sql,
      days_to_close,
      avg_days_from_creation_to_close,
      avg_days_mql_to_convert,
      avg_days_to_close,
      avg_days_to_mql,
      avg_days_to_sal,
      avg_days_to_sql,
      count_distinct_mql,
      count_distinct_sal,
      count_distinct_sql,
      count_distinct_sqo
    ]
  }
  join: sf__contacts {
    view_label: "Contacts"
    sql_on: ${sf__leads_and_contacts.lead_or_contact_id} = ${sf__contacts.id} ;;
    relationship: one_to_one
    fields: [
      sf__contacts.focused*
    ]
  }
  join: sf__accounts {
    from: sf__accounts
    view_label: "Accounts (Leads and Contacts)"
    sql_on: ${sf__leads_and_contacts.account_id} = ${sf__accounts.id} ;;
    relationship: one_to_one
  }
  join: sf__opportunity_contacts_role {
    from: sf__opportunity_contact_role
    view_label: "Opportunity Contacts"
    sql_on: ${sf__opportunity_contacts_role.contact_id} = ${sf__contacts.id} ;;
    relationship: one_to_many
  }
  join: sf__opportunities {
    from: sf__opportunities
    view_label: "Opportunities"
    sql_on: ${sf__opportunity_contacts_role.opportunity_id} = ${sf__opportunities.id} ;;
    #type: full_outer  # See https://docs.looker.com/reference/explore-params/type-for-join?version=5.18&lookml=new
    relationship: many_to_one
  }
  join: opportunity_products {
    from: sf__opportunity_products
    view_label: "Opportunity Products"
    sql_on: ${sf__opportunities.id} = ${opportunity_products.opportunity_id} ;;
    relationship: one_to_many
  }
  join: opportunity_accounts {
    from: sf__accounts
    view_label: "Accounts (Opportunities)"
    sql_on: ${opportunity_accounts.account_id} = ${sf__opportunities.account_id} ;;
    relationship: one_to_one
  }
  join: opportunity_owners {
    from: sf__users
    sql_on: ${sf__opportunities.owner_id} = ${opportunity_owners.id} ;;
    relationship: many_to_one
  }
  join: sf__deal_registrations {
    view_label: "Deal Registration"
    sql_on: ${sf__opportunities.id} = ${sf__deal_registrations.opportunity_c} ;;
    relationship: one_to_one
  }
  join: campaign_members {
    from:  sf__campaign_members
    sql_on: ${sf__leads_and_contacts.lead_or_contact_id} = ${campaign_members.lead_or_contact_id} ;;
    relationship: one_to_many
  }
  join: campaigns {
    from:  sf__campaigns
    sql_on: ${campaign_members.campaign_id} = ${campaigns.id} ;;
    relationship: many_to_one
  }
}

view: dockercon_2019{
  derived_table: {
    explore_source: leads_and_contacts_to_account_pipeline {
      column: id { field: sf__accounts.id }
      column: name { field: campaigns.name }
      filters: {
        field: campaigns.name
        value: "DockerCon 2019 Conference Registrants"
      }
    }
  }
  dimension: id {
    hidden: yes
    label: "Accounts (Leads and Contacts) ID"
    description: "Unique SFDC ID for Account"
  }
  dimension: name {
    hidden: yes
    label: "Campaign Name"
  }
  dimension: in_dockercon_2019 {
    type: yesno
    description: "Does this account have a matched lead or contact registered for DockerCon 2019?"
    sql: CASE WHEN ${name} = 'DockerCon 2019 Conference Registrants' THEN TRUE ELSE FALSE END ;;
  }
}

explore: leads_and_contacts_to_account_pipeline {
  from: sf__leads_and_contacts
  description: "Explore the Opportunity Pipeline associated an Account by looking at the matched Leads and Contacts."
  label: "Leads and Contacts to Opportunities via Matched Accounts"
  view_label: "Leads and Contacts"
  join: sf__leads {
    view_label: "Leads"
    sql_on: ${leads_and_contacts_to_account_pipeline.lead_or_contact_id} = ${sf__leads.id} ;;
    relationship: one_to_one
    fields: [
      sf__leads.focused*
    ]
  }
  join: sf__leads_converted {
    view_label: "Leads Converted"
    sql_on: ${sf__leads_converted.id} = ${sf__leads.id} ;;
    relationship: one_to_one
    fields: [
      id,
      days_from_creation_to_close,
      days_to_mql,
      days_to_sal,
      days_to_sql,
      days_to_close,
      avg_days_from_creation_to_close,
      avg_days_mql_to_convert,
      avg_days_to_close,
      avg_days_to_mql,
      avg_days_to_sal,
      avg_days_to_sql,
      count_distinct_mql,
      count_distinct_sal,
      count_distinct_sql,
      count_distinct_sqo
    ]
  }
  join: sf__contacts {
    view_label: "Contacts"
    sql_on: ${leads_and_contacts_to_account_pipeline.lead_or_contact_id} = ${sf__contacts.id} ;;
    relationship: one_to_one
    fields: [
      sf__contacts.focused*
    ]
  }
  join: sf__accounts {
    from: sf__accounts
    view_label: "Accounts (Leads and Contacts)"
    sql_on: ${leads_and_contacts_to_account_pipeline.account_id} = ${sf__accounts.id} ;;
    relationship: one_to_one
  }
  join: account_owners {
    from: sf__users
    sql_on: ${sf__accounts.owner_id} = ${account_owners.id} ;;
    relationship: many_to_one
  }
  join: dockercon_2019 {
    view_label: "Accounts (Leads and Contacts)"
    sql_on: ${sf__accounts.id} = ${dockercon_2019.id} ;;
    relationship: one_to_one
  }
  join: sf__opportunities {
    from: sf__opportunities
    view_label: "Opportunities"
    sql_on: ${sf__accounts.id} = ${sf__opportunities.account_id} ;;
    #type: full_outer  # See https://docs.looker.com/reference/explore-params/type-for-join?version=5.18&lookml=new
    relationship: many_to_one
  }
  join: sf__opportunity_snap_20190429 {
    view_label: "Opportunity_Snap_20190429"
    sql_on: ${sf__opportunities.id} = ${sf__opportunity_snap_20190429.opportunity_id} ;;
    relationship: one_to_one
  }
  join: opportunity_products {
    from: sf__opportunity_products
    view_label: "Opportunity Products"
    sql_on: ${sf__opportunities.id} = ${opportunity_products.opportunity_id} ;;
    relationship: one_to_many
  }
  join: campaign_members {
    from:  sf__campaign_members
    sql_on: ${leads_and_contacts_to_account_pipeline.lead_or_contact_id} = ${campaign_members.lead_or_contact_id} ;;
    relationship: one_to_many
  }
  join: campaigns {
    from:  sf__campaigns
    sql_on: ${campaign_members.campaign_id} = ${campaigns.id} ;;
    relationship: many_to_one
  }
}

explore: sf__opportunity_dockercon_renewals {}

explore: sf__opportunity_customers {
  label: "Opportunity Customers"
}
explore: sf__products {
  label: "Products"
  view_label: "Products"
}

include: "github_comments_poc.view"
explore: github_comments_poc {
  hidden: yes
}

include: "adhoc_transposed_customer_events.view.lkml"
explore: current_customer_buying_patterns {
  from: adhoc_transposed_customer_events
  hidden: yes
}

include: "adhoc_customer_contacts.view.lkml"
explore: adhoc_customer_contacts {
  view_label: "Customer Contacts"
  label: "Customer Contacts"
}

include: "sf__acv_updates.view.lkml"
explore: sf__acv_updates {
  view_label: "ACV Updates"
  label: "ACV Updates"
  hidden: yes
}
