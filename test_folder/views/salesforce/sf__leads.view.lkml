view: sf__leads {
  extends: [sfbase__leads]

  dimension: created {
    #X# Invalid LookML inside "dimension": {"timeframes":["time","date","week","month","raw"]}
  }

  dimension: number_of_employees_tier {
    type: tier
    tiers: [
      0,
      1,
      11,
      51,
      201,
      501,
      1001,
      5001,
      10000
    ]
    sql: ${number_of_employees} ;;
    style: integer
    description: "Number of Employees as reported on the Salesforce lead"
  }

  dimension: is_mql {
    description:  "Lead has MQL'd"
    type: yesno
    sql: CASE WHEN ${became_mqldate_date} IS NOT NULL THEN TRUE ELSE FALSE END ;;
  }

  measure: converted_to_contact_count {
    type: count
    drill_fields: [detail*]

    filters: {
      field: converted_contact_id
      value: "-null"
    }
  }

  measure: became_MEL_count {
    label: "Became MEL Count"
    description: "Count the number of leads converted to MEL (Marketing Engaged Lead) status"
    type: count
    drill_fields: [detail*]

    filters: {
      field: became_mel_date_time
      value: "-null"
    }
  }

  measure: beyond_MEL_count {
    label: "Progressed Beyond MEL Count"
    description: "Count the number of leads that progressed beyond the MEL lifecycle stage"
    type: sum
    drill_fields: [detail*]

    filters: {
      field: became_mel_date_time
      value: "-null"
    }

    sql:
    CASE
      WHEN
        ( ${became_sal_date_time} IS NOT NULL AND ${became_sal_date_time} > ${became_mel_date_time} )
        OR ( ${became_sql_date_time} IS NOT NULL AND ${became_sql_date_time} > ${became_mel_date_time} )
        OR ( ${converted_opportunity_id} IS NOT NULL )
        THEN 1 ELSE 0 END
    ;;
  }

  measure: mql_converted_to_contact_count {
    label: "Count MQLs converted to contacts"
    description: "Number of contacts that are from MQLs"
    type: count
    drill_fields: [detail*]

    filters: {
      field: converted_contact_id
      value: "-null"
    }
    filters: {
      field: became_mqldate_date
      value: "-null"
    }
  }

  measure: converted_to_account_count {
    type: count
    drill_fields: [detail*]

    filters: {
      field: converted_account_id
      value: "-null"
    }
  }

  measure: mql_converted_to_account_count {
    description: "Number of accounts that are from MQLs"
    label: "Count MQLs converted to accounts"
    type: count
    drill_fields: [detail*]

    filters: {
      field: converted_account_id
      value: "-null"
    }
    filters: {
      field: became_mqldate_date
      value: "-null"
    }
  }

  measure: converted_to_opportunity_count {
    type: count
    link: {
      label: "MQL Conversion Dashboard"
      url: "/dashboards/295"
      icon_url: "http://looker.com/favicon.ico"
    }
    filters: {
      field: converted_opportunity_id
      value: "-null"
    }
    drill_fields: [detail*]

  }

  measure: mql_converted_to_opportunity_count {
    label: "Count MQLs converted to opportunities"
    description: "Number of opportunities that are from MQLs "
    type: count
    drill_fields: [detail*]

    filters: {
      field: converted_opportunity_id
      value: "-null"
    }
    filters: {
      field: became_mqldate_date
      value: "-null"
    }

  }

  measure: became_MQL_count {
    label: "Became MQL Count"
    description: "Count the number of leads converted to MQL (Marketing Qualified Lead) status"
    type: count
    drill_fields: [detail*]

    filters: {
      field: became_mqldate_time
      value: "-null"
    }
  }

  measure: beyond_MQL_count {
    label: "Progressed Beyond MQL Count"
    description: "Count the number of leads that progressed beyond the MQL lifecycle stage"
    type: sum
    drill_fields: [detail*]

    filters: {
      field: became_mqldate_time
      value: "-null"
    }

    sql:
    CASE
      WHEN ${became_sal_date_time} IS NOT NULL OR ${became_sql_date_time} IS NOT NULL OR ${converted_opportunity_id} IS NOT NULL THEN 1 ELSE 0 END
    ;;
  }

  measure: became_SAL_count {
    label: "Became SAL Count"
    description: "Count the number of leads converted to SAL (Sales Accepted Lead) status"
    type: count
    drill_fields: [detail*]

    filters: {
      field: became_sal_date_date
      value: "-null"
    }
  }

  measure: became_SQL_count {
    label: "Became SQL Count"
    description: "Count the number of leads converted to SQL (Sales Qualified Lead) status"
    type: count
    drill_fields: [detail*]

    filters: {
      field: became_sql_date_date
      value: "-null"
    }
  }

  measure: conversion_to_contact_percent {
    sql: 100.00 * ${converted_to_contact_count} / NULLIF(${count},0) ;;
    type: number
    value_format: "0.00\%"
  }

  measure: conversion_to_account_percent {
    sql: 100.00 * ${converted_to_account_count} / NULLIF(${count},0) ;;
    type: number
    value_format: "0.00\%"
  }

  measure: conversion_to_opportunity_percent {
    sql: 100.00 * ${converted_to_opportunity_count} / NULLIF(${count},0) ;;
    type: number
    value_format: "0.00\%"
  }

  measure: avg_days_mql_to_convert {
    label: "Avg Days - MQL to Convert"
    type: average
    sql: ${mql_days_to_convert} ;;
  }

  set: focused {
    fields: [
      became_mel_date_date,
      became_mel_date_fiscal_quarter,
      became_mqldate_date,
      became_mqldate_fiscal_quarter,
      sf__leads.became_sql_date_date,
      sf__leads.became_sal_date_fiscal_quarter,
      sf__leads.became_sql_date_date,
      sf__leads.became_sql_date_fiscal_quarter,
      sf__leads.behavior_score,
      sf__leads.company,
      sf__leads.name,
      sf__leads.country,
      sf__leads.country_code,
      sf__leads.email,
      sf__leads.engagio_matched_account,
      sf__leads.geo,
      sf__leads.region,
      sf__leads.sub_region,
      sf__leads.is_converted,
      sf__leads.is_mql,
      sf__leads.last_modified_date,
      sf__leads.lead_source,
      sf__leads.lead_source_detail,
      sf__leads.record_type_id,
      sf__leads.id,
      sf__leads.status,
      sf__leads.state,
      sf__leads.state_code,
      sf__leads.type,
      sf__leads.converted_to_contact_count,
      sf__leads.mql_converted_to_contact_count,
      sf__leads.converted_to_account_count,
      sf__leads.mql_converted_to_account_count,
      sf__leads.converted_to_opportunity_count,
      sf__leads.mql_converted_to_opportunity_count,
      sf__leads.became_MQL_count,
      sf__leads.became_SAL_count,
      sf__leads.became_SQL_count,
      sf__leads.conversion_to_contact_percent,
      sf__leads.conversion_to_account_percent,
      sf__leads.conversion_to_opportunity_percent,
      sf__leads.avg_days_mql_to_convert,
      sf__leads.became_mqldate_time,
      sf__leads.became_sql_date_date,
      became_sal_date_date,
      converted_contact_id,
      converted_account_id,
      converted_opportunity_id,
      disqualified_date,
      disqualified_from_stage,

      recycled_date,
      recycled_from_stage,

      bizible_account_id,
      bizible_ad_campaign_name_ft,
      bizible_ad_campaign_name_lc,
      bizible_bizible_id,
      bizible_landing_page_ft,
      bizible_landing_page_lc,
      bizible_marketing_channel_ft,
      bizible_marketing_channel_lc,
      bizible_touchpoint_date_ft_date,
      bizible_touchpoint_date_lc_date,
      bizible_touchpoint_source_ft,
      bizible_touchpoint_source_lc
    ]
  }
}

view: sfbase__leads {
  sql_table_name: salesforce.leads ;;

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
    link: {
      label: "SFDC Lead"
      url: "https://docker.my.salesforce.com/{{value}}"
      icon_url: "https://docker.my.salesforce.com/favicon.ico"
    }
  }

  dimension: account_band {
    type: string
    description: "Standardized revenue band for this lead"
    sql: ${TABLE}.account_band_c ;;
  }

  dimension: accepted_ucp_beta_terms {
    type: yesno
    sql: ${TABLE}.accepted_ucp_beta_terms_c ;;
  }

  dimension: agreement_version {
    type: string
    sql: ${TABLE}.agreement_version_c ;;
  }

  dimension: annual_revenue {
    type: string
    sql: ${TABLE}.annual_revenue ;;
  }

  dimension: authentication_type {
    type: string
    sql: ${TABLE}.authentication_type_c ;;
  }

  dimension_group: became_mel_date {
    description: "Date when Lead became Marketing Engaged"
    label: "Became MEL"
    type: time
    timeframes: [time, fiscal_month_num, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.became_mel_date_c ;;
  }

  dimension_group: became_mqldate {
    type: time
    label: "Became MQL"
    description: "Date when the Lead became Marketing Qualified"
    timeframes: [time, fiscal_month_num, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.became_mqldate_c ;;
  }

  dimension_group: became_sal_date {
    type: time
    label: "Became SAL"
    description: "Date when the Lead became Sales Accepted"
    timeframes: [time, fiscal_month_num, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.became_sal_date_c ;;
  }

  dimension_group: became_sql_date {
    type: time
    label: "Became SQL"
    description: "Date when the Lead became Sales Qualified"
    timeframes: [time, fiscal_month_num, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.became_sql_date_c ;;
  }

  dimension: time_in_mel {
    label: "Time in MEL"
    description: "SFDC counter for days a Lead spent in the Engaged Lifecycle Stage"
    type: number
    sql: ${TABLE}.time_in_mel_c ;;
  }

  dimension: time_in_mql {
    label: "Time in MQL"
    description: "Length of time a lead is in MQL stage measured in days"
    type: number
    sql: ${TABLE}.time_in_mql_c ;;
  }

  dimension: time_in_sal {
    label: "Time in SAL"
    description: "Length of time a lead is in SAL stage measured in days"
    type: number
    sql: ${TABLE}.time_in_sal_c ;;
  }

  dimension: time_in_sql {
    label: "Time in SQL"
    description: "Length of time a lead is in SQL stage measured in days"
    type: number
    sql: ${TABLE}.time_in_sql_c ;;
  }

  dimension: behavior_score {
    type: number
    sql: ${TABLE}.behavior_score_c ;;
  }

  dimension: bizible_account_id {
    group_label: "Bizible"
    group_item_label: "SFDC Account ID"
    type: string
    sql: ${TABLE}.bizible_2_account_c ;;
  }

  dimension: bizible_ad_campaign_name_ft {
    group_label: "Bizible"
    group_item_label: "Ad Campaign Name FT"
    type: string
    sql: ${TABLE}.bizible_2_ad_campaign_name_ft_c ;;
  }

  dimension: bizible_ad_campaign_name_lc {
    group_label: "Bizible"
    group_item_label: "Ad Campaign Name LC"
    type: string
    sql: ${TABLE}.bizible_2_ad_campaign_name_lc_c ;;
  }

  dimension: bizible_bizible_id {
    group_label: "Bizible"
    group_item_label: "Id"
    hidden: yes   # Field is visible in Segment, but no data must exist, as field is NOT in Snowflake
    type: string
    sql: ${TABLE}.bizible_2_bizible_id_c ;;
  }

  dimension: bizible_landing_page_ft {
    group_label: "Bizible"
    group_item_label: "Landing Page FT"
    type: string
    sql: ${TABLE}.bizible_2_landing_page_ft_c ;;
  }

  dimension: bizible_landing_page_lc {
    group_label: "Bizible"
    group_item_label: "Landing Page LC"
    type: string
    sql: ${TABLE}.bizible_2_landing_page_lc_c ;;
  }

  dimension: bizible_marketing_channel_ft {
    group_label: "Bizible"
    group_item_label: "Marketing Channel FT"
    type: string
    sql: ${TABLE}.bizible_2_marketing_channel_ft_c ;;
  }

  dimension: bizible_activity_type_ft {
    group_label: "Bizible"
    group_item_label: "Marketing Activty Type FT"
    type: string
    sql: CASE WHEN UPPER(${TABLE}.bizible_2_marketing_channel_ft_c) = 'EVENTS' THEN 'EVENTS' ELSE 'DIGITAL' END;;
  }

  dimension: bizible_marketing_channel_lc {
    group_label: "Bizible"
    group_item_label: "Marketing Channel LC"
    type: string
    sql: ${TABLE}.bizible_2_marketing_channel_lc_c ;;
  }

  dimension: bizible_activity_type_lc {
    group_label: "Bizible"
    group_item_label: "Marketing Activty Type LC"
    type: string
    sql: CASE WHEN UPPER(${TABLE}.bizible_2_marketing_channel_lc_c) = 'EVENTS' THEN 'EVENTS' ELSE 'DIGITAL' END;;
  }

  dimension_group: bizible_touchpoint_date_ft {
    type: time
    timeframes: [time, fiscal_month_num, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.bizible_2_touchpoint_date_ft_c ;;
  }

  dimension_group: bizible_touchpoint_date_lc {
    type: time
    timeframes: [time, fiscal_month_num, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.bizible_2_touchpoint_date_lc_c ;;
  }

  dimension: bizible_touchpoint_source_ft {
    group_label: "Bizible"
    group_item_label: "Touchpoint Source FT"
    type: string
    sql: ${TABLE}.bizible_2_touchpoint_source_ft_c ;;
  }

  dimension: bizible_touchpoint_source_lc {
    group_label: "Bizible"
    group_item_label: "Touchpoint Source LC"
    type: string
    sql: ${TABLE}.bizible_2_touchpoint_source_lc_c ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension_group: click_to_accept_date {
    type: time
    timeframes: [time, fiscal_month_num, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.click_to_accept_date_c ;;
  }

  dimension: cloudingo_agent_as {
    type: number
    sql: ${TABLE}.cloudingo_agent_as_c ;;
  }

  dimension: cloudingo_agent_les {
    type: number
    sql: ${TABLE}.cloudingo_agent_les_c ;;
  }

  dimension: company {
    type: string
    sql: ${TABLE}.company ;;
  }

  dimension: company_duns_number {
    type: string
    sql: ${TABLE}.company_duns_number ;;
  }

  dimension: company_overview {
    type: string
    sql: ${TABLE}.company_overview_c ;;
  }

  dimension: competition {
    type: string
    sql: ${TABLE}.competition_c ;;
  }

  dimension: contacted {
    type: yesno
    sql: ${TABLE}.contacted_c ;;
  }

  dimension_group: contacted_date {
    type: time
    timeframes: [time, fiscal_month_num, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.contacted_date_c ;;
  }

  dimension: convert_to_account {
    description: "Do not use -- not consistently populated.  When so, it matches converted_to_account_id"
    hidden: yes
    type: string
    sql: ${TABLE}.convert_to_account_c ;;
  }

  dimension: convert_to_contact {
    description: "Do not use -- not consistently populated.  When so, it matches converted_to_contact_id"
    hidden: yes
    type: string
    sql: ${TABLE}.convert_to_contact_c ;;
  }

  dimension: converted_account_id {
    type: string
    sql: ${TABLE}.converted_account_id ;;
    link: {
      label: "SFDC Converted Account"
      url: "https://docker.my.salesforce.com/{{value}}"
      icon_url: "https://docker.my.salesforce.com/favicon.ico"
    }
  }

  dimension: converted_contact_id {
    type: string
    sql: ${TABLE}.converted_contact_id ;;
    link: {
      label: "SFDC Converted Contact"
      url: "https://docker.my.salesforce.com/{{value}}"
      icon_url: "https://docker.my.salesforce.com/favicon.ico"
    }
  }

  dimension_group: converted {
    type: time
    timeframes: [time, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.converted_date ;;
  }

  dimension: converted_opportunity_id {
    type: string
    sql: ${TABLE}.converted_opportunity_id ;;
    link: {
      url: "/dashboards/295"
      icon_url: "http://www.salesforce.com/favicon.ico"
    }
    link: {
      label: "SFDC Converted Opportunity"
      url: "https://docker.my.salesforce.com/{{value}}"
      icon_url: "https://docker.my.salesforce.com/favicon.ico"
    }
  }

  dimension: country {
    type: string
    sql: ${TABLE}.country ;;
  }

  dimension: country_code {
    type: string
    sql: ${TABLE}.country_code ;;
  }

  dimension: created_by_id {
    type: string
    sql: ${TABLE}.created_by_id ;;
  }

  dimension_group: created {
    type: time
    timeframes: [time, fiscal_month_num, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.created_date ;;
  }

  dimension: currency_iso_code {
    type: string
    sql: ${TABLE}.currency_iso_code ;;
  }

  dimension: dandb_company_id {
    type: string
    sql: ${TABLE}.dandb_company_id ;;
  }

  dimension: ddc_eval_containers {
    type: number
    sql: ${TABLE}.ddc_eval_containers_c ;;
  }

  dimension: ddc_eval_controllers {
    type: number
    sql: ${TABLE}.ddc_eval_controllers_c ;;
  }

  dimension_group: ddc_eval_expiration {
    type: time
    timeframes: [time, fiscal_month_num, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.ddc_eval_expiration_c ;;
  }

  dimension: ddc_eval_nodes {
    type: number
    sql: ${TABLE}.ddc_eval_nodes_c ;;
  }

  dimension: demographic_score {
    type: number
    sql: ${TABLE}.demographic_score_c ;;
  }

  dimension: dhe_customer_agreement {
    type: yesno
    sql: ${TABLE}.dhe_customer_agreement_c ;;
  }

  dimension: dhe_usage_type {
    type: string
    sql: ${TABLE}.dhe_usage_type_c ;;
  }

  dimension_group: disqualified {
    type: time
    timeframes: [time, fiscal_month_num, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.disqualified_date_c ;;
  }

  dimension: disqualified_from_stage {
    type: string
    sql: ${TABLE}.disqualified_from_stage_c ;;
  }

  dimension: docker_familiarity {
    type: string
    sql: ${TABLE}.docker_familiarity_c ;;
  }

  dimension: docker_hub_email_address {
    type: string
    sql: ${TABLE}.docker_hub_email_address_c ;;
  }

  dimension: docker_hub_user_name {
    type: string
    sql: ${TABLE}.docker_hub_user_name_c ;;
  }

  dimension: docker_readiness {
    type: string
    sql: ${TABLE}.docker_readiness_c ;;
  }

  dimension: docker_use_case {
    type: string
    sql: ${TABLE}.docker_use_case_c ;;
  }

  dimension: domain {
    type: string
    sql: ${TABLE}.domain_c ;;
  }

  dimension: domain_extension {
    type: string
    sql: ${TABLE}.domain_extension_c ;;
  }

  dimension: dscorgpkg_company_hq_address {
    type: string
    sql: ${TABLE}.dscorgpkg_company_hq_address_c ;;
  }

  dimension: dscorgpkg_company_hq_city {
    type: string
    sql: ${TABLE}.dscorgpkg_company_hq_city_c ;;
  }

  dimension: dscorgpkg_company_hq_country_code {
    type: string
    sql: ${TABLE}.dscorgpkg_company_hq_country_code_c ;;
  }

  dimension: dscorgpkg_company_hq_country_full_name {
    type: string
    sql: ${TABLE}.dscorgpkg_company_hq_country_full_name_c ;;
  }

  dimension: dscorgpkg_company_hq_postal_code {
    type: string
    sql: ${TABLE}.dscorgpkg_company_hq_postal_code_c ;;
  }

  dimension: dscorgpkg_company_hq_state {
    type: string
    sql: ${TABLE}.dscorgpkg_company_hq_state_c ;;
  }

  dimension: dscorgpkg_company_hq_state_full_name {
    type: string
    sql: ${TABLE}.dscorgpkg_company_hq_state_full_name_c ;;
  }

  dimension: dscorgpkg_conflict {
    type: string
    sql: ${TABLE}.dscorgpkg_conflict_c ;;
  }

  dimension: dscorgpkg_deleted_from_discover_org {
    type: string
    sql: ${TABLE}.dscorgpkg_deleted_from_discover_org_c ;;
  }

  dimension: dscorgpkg_department {
    type: string
    sql: ${TABLE}.dscorgpkg_department_c ;;
  }

  dimension: dscorgpkg_discover_org_company_id {
    type: string
    sql: ${TABLE}.dscorgpkg_discover_org_company_id_c ;;
  }

  dimension_group: dscorgpkg_discover_org_created_on {
    type: time
    timeframes: [time, fiscal_month_num, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.dscorgpkg_discover_org_created_on_c ;;
  }

  dimension: dscorgpkg_discover_org_full_country_name {
    type: string
    sql: ${TABLE}.dscorgpkg_discover_org_full_country_name_c ;;
  }

  dimension: dscorgpkg_discover_org_id {
    type: string
    sql: ${TABLE}.dscorgpkg_discover_org_id_c ;;
  }

  dimension_group: dscorgpkg_discover_org_last_update {
    type: time
    timeframes: [time, fiscal_month_num, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.dscorgpkg_discover_org_last_update_c ;;
  }

  dimension: dscorgpkg_discover_org_state_full_name {
    type: string
    sql: ${TABLE}.dscorgpkg_discover_org_state_full_name_c ;;
  }

  dimension: dscorgpkg_discover_org_technologies {
    type: string
    sql: ${TABLE}.dscorgpkg_discover_org_technologies_c ;;
  }

  dimension: dscorgpkg_do_3_yr_employees_growth {
    type: string
    sql: ${TABLE}.dscorgpkg_do_3_yr_employees_growth_c ;;
  }

  dimension: dscorgpkg_do_3_yr_sales_growth {
    type: string
    sql: ${TABLE}.dscorgpkg_do_3_yr_sales_growth_c ;;
  }

  dimension: dscorgpkg_exclude_update {
    type: yesno
    sql: ${TABLE}.dscorgpkg_exclude_update_c ;;
  }

  dimension: dscorgpkg_external_discover_org_id {
    type: string
    sql: ${TABLE}.dscorgpkg_external_discover_org_id_c ;;
  }

  dimension: dscorgpkg_fiscal_year_end {
    type: string
    sql: ${TABLE}.dscorgpkg_fiscal_year_end_c ;;
  }

  dimension: dscorgpkg_fortune_rank {
    type: string
    sql: ${TABLE}.dscorgpkg_fortune_rank_c ;;
  }

  dimension: dscorgpkg_it_budget {
    type: number
    sql: ${TABLE}.dscorgpkg_it_budget_c ;;
  }

  dimension: dscorgpkg_it_employees {
    type: number
    sql: ${TABLE}.dscorgpkg_it_employees_c ;;
  }

  dimension: dscorgpkg_itorg_chart {
    type: string
    sql: ${TABLE}.dscorgpkg_itorg_chart_c ;;
  }

  dimension: dscorgpkg_job_function {
    type: string
    sql: ${TABLE}.dscorgpkg_job_function_c ;;
  }

  dimension: dscorgpkg_linked_in_url {
    type: string
    sql: ${TABLE}.dscorgpkg_linked_in_url_c ;;
  }

  dimension: dscorgpkg_management_level {
    type: string
    sql: ${TABLE}.dscorgpkg_management_level_c ;;
  }

  dimension: dscorgpkg_middle_name {
    type: string
    sql: ${TABLE}.dscorgpkg_middle_name_c ;;
  }

  dimension: dscorgpkg_naics_codes {
    type: string
    sql: ${TABLE}.dscorgpkg_naics_codes_c ;;
  }

  dimension: dscorgpkg_nick_name {
    type: string
    sql: ${TABLE}.dscorgpkg_nick_name_c ;;
  }

  dimension: dscorgpkg_ownership {
    type: string
    sql: ${TABLE}.dscorgpkg_ownership_c ;;
  }

  dimension: dscorgpkg_reports_to {
    type: string
    sql: ${TABLE}.dscorgpkg_reports_to_c ;;
  }

  dimension: dscorgpkg_sic_codes {
    type: string
    sql: ${TABLE}.dscorgpkg_sic_codes_c ;;
  }

  dimension: dscorgpkg_twitter_url {
    type: string
    sql: ${TABLE}.dscorgpkg_twitter_url_c ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension_group: email_bounced {
    type: time
    timeframes: [time, fiscal_month_num, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.email_bounced_date ;;
  }

  dimension: email_bounced_reason {
    type: string
    sql: ${TABLE}.email_bounced_reason ;;
  }

  dimension: employee_range {
    type: string
    sql: ${TABLE}.employee_range_c ;;
  }

  dimension_group: eval_expiration_date {
    type: time
    timeframes: [time, fiscal_month_num, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.eval_expiration_date_c ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: fortune_2000_global {
    type: yesno
    sql: ${TABLE}.fortune_2000_global_c ;;
  }


  dimension: fortune_10K_global {
    type: yesno
    sql: ${TABLE}.fortune_10_k_c ;;
  }

  dimension: generated_by {
    type: string
    sql: ${TABLE}.generated_by_c ;;
  }

  dimension: geo {
    type: string
    sql: ${TABLE}.geo_c ;;
  }

  dimension: global_engagement_score {
    description: "Lead engagement score based on behavioral actions"
    type: number
    sql: ${TABLE}.global_engagement_score_c ;;
  }

  dimension: global_firmographic_score {
    description: "Lead engagement score based on company attributes"
    type:  number
    sql: ${TABLE}.global_firmographic_score_c ;;
  }

  dimension: has_opted_out_of_email {
    type: yesno
    sql: ${TABLE}.has_opted_out_of_email ;;
  }

  dimension: industry {
    type: string
    sql: ${TABLE}.industry ;;
  }

  dimension: interest {
    type: string
    sql: ${TABLE}.interest_c ;;
  }

  dimension: is_addressable {
    type: yesno
    sql: ${TABLE}.is_addressable_c ;;
  }

  dimension: is_converted {
    type: yesno
    sql: ${TABLE}.is_converted ;;
  }

  dimension: is_deleted {
    type: yesno
    sql: ${TABLE}.is_deleted ;;
  }

  dimension: is_unread_by_owner {
    type: yesno
    sql: ${TABLE}.is_unread_by_owner ;;
  }

  dimension: jigsaw_contact_id {
    type: string
    sql: ${TABLE}.jigsaw_contact_id ;;
  }

  dimension: job_function {
    type: string
    sql: ${TABLE}.job_function_c ;;
  }

  dimension: job_seniority {
    type: string
    sql: ${TABLE}.job_seniority_c ;;
  }

  dimension_group: last_activity {
    type: time
    timeframes: [time, fiscal_month_num, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.last_activity_date ;;
  }

  dimension_group: last_activity_date {
    type: time
    timeframes: [time, fiscal_month_num, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.last_activity_date_c ;;
  }

  dimension: last_modified_by_id {
    type: string
    sql: ${TABLE}.last_modified_by_id ;;
  }

  dimension_group: last_modified {
    type: time
    timeframes: [time, fiscal_month_num, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.last_modified_date ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension_group: last_referenced {
    type: time
    timeframes: [time, fiscal_month_num, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.last_referenced_date ;;
  }

  dimension_group: last_viewed {
    type: time
    timeframes: [time, fiscal_month_num, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.last_viewed_date ;;
  }

  dimension: lead_lifecycle_stage {
    type: string
    sql: ${TABLE}.lead_lifecycle_stage_c ;;
  }

  dimension: lead_lifecycle_stage_number {
    description: "Lead Lifecycle stage sequence number; use for lining up lead counts in order of lifecycle stages"
    type: number
    sql:
    CASE
      WHEN ${TABLE}.lead_lifecycle_stage_c = 'Suspect' THEN 0
      WHEN ${TABLE}.lead_lifecycle_stage_c = 'Inquiry' THEN 1
      WHEN ${TABLE}.lead_lifecycle_stage_c = 'MQL' THEN 2
      WHEN ${TABLE}.lead_lifecycle_stage_c = 'SAL' THEN 3
      WHEN ${TABLE}.lead_lifecycle_stage_c = 'SQL' THEN 4
      WHEN ${TABLE}.lead_lifecycle_stage_c = 'Disqualified' THEN 5
      WHEN ${TABLE}.lead_lifecycle_stage_c = 'Recycle' THEN 6
    ELSE
      NULL
    END ;;
  }

  dimension: lead_quality_rating {
    description: "Quality score for Leads (e.g. A1,A2,A3,B1,B2,B3,C1,C2,C3, or NO)."
    type: string
    sql: ${TABLE}.lead_quality_rating_c ;;
  }

  dimension: lead_source {
    type: string
    sql: ${TABLE}.lead_source ;;
  }

  dimension: lead_source_detail {
    type: string
    sql: ${TABLE}.lead_source_detail_c ;;
  }


  #
  # Lean Data
  #
  dimension: leandata_a2b_account {
    hidden: yes
    group_label: "LeanData"
    type: string
    sql: ${TABLE}.lean_data_a2_b_account_c ;;
  }

  dimension: leandata_a2b_group {
    hidden:  yes
    group_label: "LeanData"
    type: string
    sql: ${TABLE}.lean_data_a2_b_group_c ;;
  }

  dimension: leandata_segment {
    hidden:  yes
    group_label: "LeanData"
    type: string
    sql: ${TABLE}.lean_data_id_segment_c ;;
  }

  dimension: leandata_marketing_sys_created_date{
    hidden:  yes
    group_label: "LeanData"
    type: string
    sql: ${TABLE}.lean_data_marketing_sys_created_date_c ;;
  }

  dimension: leandata_matched_account {
    group_label: "LeanData"
    description: "SFDC Account ID for the account Lean Data matched this lead to"
    type: string
    sql: ${TABLE}.LEAN_DATA_REPORTING_MATCHED_ACCOUNT_C ;;
  }

  dimension: leandata_matched_buyer_persona {
    hidden:  yes
    group_label: "LeanData"
    type: string
    sql: ${TABLE}.lean_data_matched_buyer_persona ;;
  }

  dimension: leandata_matched_lead {
    hidden:  yes
    group_label: "LeanData"
    type: string
    sql: ${TABLE}.lean_data_matched_lead_c ;;
  }

  dimension: leandata_modified_score {
    hidden:  yes
    group_label: "LeanData"
    type: string
    sql: ${TABLE}.lean_data_modified_score_c ;;
  }

  dimension: leandata_reporting_timestamp {
    group_label: "LeanData"
    type: string
    sql: ${TABLE}.lean_data_reporting_timestamp_c ;;
  }

  dimension: leandata_router_status {
    hidden:  yes
    group_label: "LeanData"
    type: string
    sql: ${TABLE}.lean_data_router_status ;;
  }

  dimension: leandata_routing_action {
    group_label: "LeanData"
    type: string
    sql: ${TABLE}.lean_data_routing_action_c ;;
  }

  dimension: leandata_routing_status {
    group_label: "LeanData"
    type: string
    sql: ${TABLE}.lean_data_routing_status_c ;;
  }

  dimension: leandata_search {
    hidden:  yes
    group_label: "LeanData"
    type: string
    sql: ${TABLE}.lean_data_search_c ;;
  }

  dimension: leandata_search_index {
    group_label: "LeanData"
    type: string
    sql: ${TABLE}.lean_data_search_index_c ;;
  }

  dimension: leandata_status_info {
    group_label: "LeanData"
    type: string
    sql: ${TABLE}.lean_data_status_info_c ;;
  }

  dimension: leandata_tag {
    hidden:  yes
    group_label: "LeanData"
    type: string
    sql: ${TABLE}.lean_data_tag_c ;;
  }

  dimension: mdr {
    description: "BDR/MDR that assigned the Lead to a Sales Rep"
    type: string
    sql: ${TABLE}.mdr_c ;;
    link: {
      label: "SFDC BDR/MDR"
      url: "https://docker.my.salesforce.com/{{value}}"
      icon_url: "https://docker.my.salesforce.com/favicon.ico"
    }
  }

  dimension: member {
    type: yesno
    sql: ${TABLE}.member_c ;;
  }

  dimension: member_mirror {
    type: yesno
    sql: ${TABLE}.member_mirror_c ;;
  }

  dimension_group: mkto_2_acquisition_date {
    type: time
    timeframes: [time, fiscal_month_num, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.mkto_2_acquisition_date_c ;;
  }

  dimension: mkto_2_acquisition_program {
    type: string
    sql: ${TABLE}.mkto_2_acquisition_program_c ;;
  }

  dimension: mkto_2_inferred_city {
    type: string
    sql: ${TABLE}.mkto_2_inferred_city_c ;;
  }

  dimension: mkto_2_inferred_company {
    type: string
    sql: ${TABLE}.mkto_2_inferred_company_c ;;
  }

  dimension: mkto_2_inferred_country {
    type: string
    sql: ${TABLE}.mkto_2_inferred_country_c ;;
  }

  dimension: mkto_2_inferred_metropolitan_area {
    type: string
    sql: ${TABLE}.mkto_2_inferred_metropolitan_area_c ;;
  }

  dimension: mkto_2_inferred_phone_area_code {
    type: string
    sql: ${TABLE}.mkto_2_inferred_phone_area_code_c ;;
  }

  dimension: mkto_2_inferred_postal_code {
    type: string
    sql: ${TABLE}.mkto_2_inferred_postal_code_c ;;
  }

  dimension: mkto_2_inferred_state_region {
    type: string
    sql: ${TABLE}.mkto_2_inferred_state_region_c ;;
  }

  dimension: mkto_2_lead_score {
    type: number
    sql: ${TABLE}.mkto_2_lead_score_c ;;
  }

  dimension: mkto_2_original_referrer {
    type: string
    sql: ${TABLE}.mkto_2_original_referrer_c ;;
  }

  dimension: mkto_2_original_search_engine {
    type: string
    sql: ${TABLE}.mkto_2_original_search_engine_c ;;
  }

  dimension: mkto_2_original_search_phrase {
    type: string
    sql: ${TABLE}.mkto_2_original_search_phrase_c ;;
  }

  dimension: mkto_2_original_source_info {
    type: string
    sql: ${TABLE}.mkto_2_original_source_info_c ;;
  }

  dimension: mkto_2_original_source_type {
    type: string
    sql: ${TABLE}.mkto_2_original_source_type_c ;;
  }

  dimension_group: mkto_71_acquisition_date {
    type: time
    timeframes: [time, fiscal_month_num, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.mkto_71_acquisition_date_c ;;
  }

  dimension: mkto_71_acquisition_program {
    type: string
    sql: ${TABLE}.mkto_71_acquisition_program_c ;;
  }

  dimension: mkto_71_acquisition_program_id {
    type: number
    value_format_name: id
    sql: ${TABLE}.mkto_71_acquisition_program_id_c ;;
  }

  dimension: mkto_71_inferred_city {
    type: string
    sql: ${TABLE}.mkto_71_inferred_city_c ;;
  }

  dimension: mkto_71_inferred_company {
    type: string
    sql: ${TABLE}.mkto_71_inferred_company_c ;;
  }

  dimension: mkto_71_inferred_country {
    type: string
    sql: ${TABLE}.mkto_71_inferred_country_c ;;
  }

  dimension: mkto_71_inferred_metropolitan_area {
    type: string
    sql: ${TABLE}.mkto_71_inferred_metropolitan_area_c ;;
  }

  dimension: mkto_71_inferred_phone_area_code {
    type: string
    sql: ${TABLE}.mkto_71_inferred_phone_area_code_c ;;
  }

  dimension: mkto_71_inferred_postal_code {
    type: string
    sql: ${TABLE}.mkto_71_inferred_postal_code_c ;;
  }

  dimension: mkto_71_inferred_state_region {
    type: string
    sql: ${TABLE}.mkto_71_inferred_state_region_c ;;
  }

  dimension: mkto_71_lead_score {
    type: number
    sql: ${TABLE}.mkto_71_lead_score_c ;;
  }

  dimension: mkto_71_original_referrer {
    type: string
    sql: ${TABLE}.mkto_71_original_referrer_c ;;
  }

  dimension: mkto_71_original_search_engine {
    type: string
    sql: ${TABLE}.mkto_71_original_search_engine_c ;;
  }

  dimension: mkto_71_original_search_phrase {
    type: string
    sql: ${TABLE}.mkto_71_original_search_phrase_c ;;
  }

  dimension: mkto_71_original_source_info {
    type: string
    sql: ${TABLE}.mkto_71_original_source_info_c ;;
  }

  dimension: mkto_71_original_source_type {
    type: string
    sql: ${TABLE}.mkto_71_original_source_type_c ;;
  }

  dimension: mkto_si_add_to_marketo_campaign {
    type: string
    sql: ${TABLE}.mkto_si_add_to_marketo_campaign_c ;;
  }

  dimension: mkto_si_last_interesting_moment {
    type: string
    sql: ${TABLE}.mkto_si_last_interesting_moment_c ;;
  }

  dimension_group: mkto_si_last_interesting_moment_date {
    type: time
    timeframes: [time, fiscal_month_num, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.mkto_si_last_interesting_moment_date_c ;;
  }

  dimension: mkto_si_last_interesting_moment_desc {
    type: string
    sql: ${TABLE}.mkto_si_last_interesting_moment_desc_c ;;
  }

  dimension: mkto_si_last_interesting_moment_source {
    type: string
    sql: ${TABLE}.mkto_si_last_interesting_moment_source_c ;;
  }

  dimension: mkto_si_last_interesting_moment_type {
    type: string
    sql: ${TABLE}.mkto_si_last_interesting_moment_type_c ;;
  }

  dimension: mkto_si_priority {
    type: number
    sql: ${TABLE}.mkto_si_priority_c ;;
  }

  dimension: mkto_si_relative_score {
    type: string
    sql: ${TABLE}.mkto_si_relative_score_c ;;
  }

  dimension: mkto_si_relative_score_value {
    type: number
    sql: ${TABLE}.mkto_si_relative_score_value_c ;;
  }

  dimension: mkto_si_urgency {
    type: string
    sql: ${TABLE}.mkto_si_urgency_c ;;
  }

  dimension: mkto_si_urgency_value {
    type: number
    sql: ${TABLE}.mkto_si_urgency_value_c ;;
  }

  dimension: mkto_si_view_in_marketo {
    type: string
    sql: ${TABLE}.mkto_si_view_in_marketo_c ;;
  }

  dimension: mobile_phone {
    type: string
    sql: ${TABLE}.mobile_phone ;;
  }

  #
  # MEL Fields
  #
  dimension: raw_mel_days_to_mql {
    sql: DATEDIFF('day', ${TABLE}.became_mel_date_c, ${TABLE}.became_mqldate_c) ;;
    hidden: yes
  }
  dimension: mel_days_to_mql {
    description: "Days between when a Lead first became Marketing Engaged to when it became Marketing Qualified"
    type: number
    sql: CASE WHEN ${raw_mel_days_to_mql} < 0 THEN null ELSE ${raw_mel_days_to_mql} END ;;
  }

  dimension: raw_mel_days_to_sal {
    sql: DATEDIFF('day', ${TABLE}.became_mel_date_c, ${TABLE}.became_sal_date_c) ;;
    hidden: yes
  }
  dimension: mel_days_to_sal {
    description: "Days between when a Lead first became Marketing Engaged to when it became Sales Accepted"
    type: number
    sql: CASE WHEN ${raw_mel_days_to_sal} < 0 THEN null ELSE ${raw_mel_days_to_sal} END ;;
  }

  dimension: raw_mel_days_to_sql {
    sql: DATEDIFF('day', ${TABLE}.became_mel_date_c, ${TABLE}.became_sql_date_c) ;;
    hidden: yes
  }
  dimension: mel_days_to_sql {
    description: "Days between when a Lead first became Marketing Engaged to when it became Sales Qualified"
    type: number
    sql: CASE WHEN ${raw_mel_days_to_sql} < 0 THEN null ELSE ${raw_mel_days_to_sql} END ;;
  }

  dimension: raw_mel_days_to_convert {
    sql: DATEDIFF('day', ${TABLE}.became_mel_date_c, ${TABLE}.converted_date) ;;
    hidden: yes
  }
  dimension: mel_days_to_convert {
    description: "Days between when a Lead first became Marketing Engaged to when it was converted to an Opportunity"
    type: number
    sql: CASE WHEN ${raw_mel_days_to_convert} < 0 THEN null ELSE ${raw_mel_days_to_convert} END ;;
  }

  #
  # MQL
  #
  dimension: mqlaccepted {
    type: yesno
    sql: ${TABLE}.mqlaccepted_c ;;
    hidden: yes  # No longer used. See https://docker.atlassian.net/browse/MS-2306
  }

  dimension_group: mqlaccepted_date {
    type: time
    timeframes: [time, fiscal_month_num, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.mqlaccepted_date_c ;;
    hidden: yes  # No longer used. See https://docker.atlassian.net/browse/MS-2306
  }

  dimension: mql_days_to_convert {
    type: number
    sql: DATEDIFF('day', ${TABLE}.became_mqldate_c, ${TABLE}.converted_date) ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: lead_name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: next_step {
    type: string
    sql: ${TABLE}.next_step_c ;;
  }

  dimension: number_of_employees {
    type: number
    sql: ${TABLE}.number_of_employees ;;
  }

  dimension: overwrite_contact {
    type: yesno
    sql: ${TABLE}.overwrite_contact_c ;;
  }

  dimension: owner_id {
    type: string
    sql: ${TABLE}.owner_id ;;
  }

  dimension: owner_queue_id {
    type: string
    sql: ${TABLE}.owner_queue_id_c ;;
  }

  dimension: owner_queue_name {
    description: "Queue name when the assigned owner is a queue"
    type: string
    sql:
    -- Using https://docker.my.salesforce.com/p/own/Queue/d?id=
    CASE (${TABLE}.owner_id)
      WHEN '00GG0000004pWpoMAE' THEN 'Global Unverified Queue'
      WHEN '00GG0000004pUtYMAU' THEN 'South America Lead Queue'
      WHEN '00GG0000004pWoWMAU' THEN 'AMER Lead Queue'
      WHEN '00GG0000004pUjJMAU' THEN 'EMEA Lead Queue'
      WHEN '00GG0000004pUj9MAE' THEN 'APAC Lead Queue'
      WHEN '00G0f0000062QP9EAM' THEN 'CreationLine Leads'
      WHEN '00G0f000004iNl9EAE' THEN 'Federal Systems Integrator Lead Queue'
      WHEN '00GG00000048IWJMA2' THEN 'Partner Lead Assignment Queue'
      ELSE Null
    END
    ;;
  }

  dimension: partner_source {
    type: string
    sql: ${TABLE}.partner_source_c ;;
  }

  dimension: partners_agreement_approved {
    type: string
    sql: ${TABLE}.partners_agreement_approved_c ;;
  }

  dimension: partnership_interest {
    type: string
    sql: ${TABLE}.partnership_interest_c ;;
  }

  dimension: percentage_of_business_from_the_educatio {
    type: string
    sql: ${TABLE}.percentage_of_business_from_the_educatio_c ;;
  }

  dimension: percentage_of_business_from_the_enterpri {
    type: string
    sql: ${TABLE}.percentage_of_business_from_the_enterpri_c ;;
  }

  dimension: percentage_of_business_from_the_federal {
    type: string
    sql: ${TABLE}.percentage_of_business_from_the_federal_c ;;
  }

  dimension: percentage_of_business_from_the_mid_mkt {
    type: string
    sql: ${TABLE}.percentage_of_business_from_the_mid_mkt_c ;;
  }

  dimension: percentage_of_business_from_the_smb_segm {
    type: string
    sql: ${TABLE}.percentage_of_business_from_the_smb_segm_c ;;
  }

  dimension: percentage_of_business_from_the_state_go {
    type: string
    sql: ${TABLE}.percentage_of_business_from_the_state_go_c ;;
  }

  dimension: percentage_of_revenues_from_consulting_s {
    type: string
    sql: ${TABLE}.percentage_of_revenues_from_consulting_s_c ;;
  }

  dimension: percentage_of_revenues_from_hardware_sal {
    type: string
    sql: ${TABLE}.percentage_of_revenues_from_hardware_sal_c ;;
  }

  dimension: percentage_of_revenues_from_post_sales_s {
    type: string
    sql: ${TABLE}.percentage_of_revenues_from_post_sales_s_c ;;
  }

  dimension: percentage_of_revenues_from_services_pro {
    type: string
    sql: ${TABLE}.percentage_of_revenues_from_services_pro_c ;;
  }

  dimension: percentage_of_revenues_from_software_sal {
    type: string
    sql: ${TABLE}.percentage_of_revenues_from_software_sal_c ;;
  }

  dimension: percentage_of_revenues_from_training {
    type: string
    sql: ${TABLE}.percentage_of_revenues_from_training_c ;;
  }

  dimension: phone {
    type: string
    sql: ${TABLE}.phone ;;
  }

  dimension: photo_url {
    type: string
    sql: ${TABLE}.photo_url ;;
  }

  dimension: point_of_entry {
    type: string
    sql: ${TABLE}.point_of_entry_c ;;
  }

  dimension: postal_code {
    type: string
    sql: ${TABLE}.postal_code ;;
  }

  dimension: previous_docker_con_sponsor {
    type: string
    sql: ${TABLE}.previous_docker_con_sponsor_c ;;
  }

  dimension: primary_competitor {
    type: string
    sql: ${TABLE}.primary_competitor_c ;;
  }

  dimension: products_sold {
    type: string
    sql: ${TABLE}.products_sold_c ;;
  }

  dimension: prospectus_sent {
    type: string
    sql: ${TABLE}.prospectus_sent_c ;;
  }

  dimension: qualified_by_sdr {
    type: string
    sql: ${TABLE}.qualified_by_sdr_c ;;
  }

  dimension: rating {
    type: string
    sql: ${TABLE}.rating ;;
  }

  dimension: reason_disqualified_sfdc {
    type: string
    sql: ${TABLE}.reason_disqualified_sfdc_c ;;
  }

  dimension: reassign_lead_trigger {
    type: yesno
    sql: ${TABLE}.reassign_lead_trigger_c ;;
  }

  dimension_group: received {
    type: time
    timeframes: [time, fiscal_month_num, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.received_at ;;
  }

  dimension: record_type_id {
    type: string
    sql: ${TABLE}.record_type_id ;;
  }

  dimension_group: recycled {
    type: time
    timeframes: [time, fiscal_month_num, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.recycled_date_c ;;
  }

  dimension: recycled_from_stage {
    type: string
    sql: ${TABLE}.recycled_from_stage_c ;;
  }

  dimension: recycled_reason {
    type: string
    sql: ${TABLE}.recycled_reason_c ;;
  }

  dimension: referral_contact {
    type: string
    sql: ${TABLE}.referral_contact_c ;;
  }

  dimension: region {
    type: string
    sql: ${TABLE}.region_c ;;
  }

  dimension: rejection_comments {
    type: string
    sql: ${TABLE}.rejection_comments_c ;;
  }

  dimension: salaccepted {
    type: yesno
    sql: ${TABLE}.salaccepted_c ;;
    hidden: yes  # No longer used. See https://docker.atlassian.net/browse/MS-2306
  }

  dimension_group: salaccepted_date {
    type: time
    timeframes: [time, fiscal_month_num, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.salaccepted_date_c ;;
    hidden: yes  # No longer used. See https://docker.atlassian.net/browse/MS-2306
  }

  dimension: salcompleted {
    type: yesno
    sql: ${TABLE}.salcompleted_c ;;
    hidden: yes  # No longer used. See https://docker.atlassian.net/browse/MS-2306
  }

  dimension_group: salcompleted_date {
    type: time
    timeframes: [time, fiscal_month_num, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.salcompleted_date_c ;;
    hidden: yes  # No longer used. See https://docker.atlassian.net/browse/MS-2306
  }

  dimension: sales_confirmed {
    type: yesno
    sql: ${TABLE}.sales_confirmed_c ;;
  }

  dimension: sales_confirmed_docker_expertise_scale {
    type: string
    sql: ${TABLE}.sales_confirmed_docker_expertise_scale_c ;;
  }

  dimension: sales_confirmed_storage {
    type: string
    sql: ${TABLE}.sales_confirmed_storage_c ;;
  }

  dimension: sales_confirmed_supported_os {
    type: string
    sql: ${TABLE}.sales_confirmed_supported_os_c ;;
  }

  dimension: sales_confirmed_timeframe {
    type: string
    sql: ${TABLE}.sales_confirmed_timeframe_c ;;
  }

  dimension: sales_contacted {
    type: yesno
    sql: ${TABLE}.sales_contacted_c ;;
  }

  dimension: salutation {
    type: string
    sql: ${TABLE}.salutation ;;
  }

  dimension: in_sla {
    description: "Is a Lead within SLA?  Definition dependent on lifecycle stage (e.g. MQL = 48h)"
    type: yesno
    sql:
    CASE
        -- 48 hours
        WHEN ${lead_lifecycle_stage} = 'MQL' THEN CASE WHEN datediff(day, ${became_mqldate_date}, CURRENT_DATE()) <= 2 THEN true ELSE false END

        -- 30 days
        WHEN ${lead_lifecycle_stage} = 'SAL' THEN CASE WHEN datediff(day, ${became_sal_date_date}, CURRENT_DATE()) <= 30 THEN true ELSE false END
        ELSE Null
    END ;;
  }

  dimension: sponsorship_level {
    type: string
    sql: ${TABLE}.sponsorship_level_c ;;
  }

  dimension_group: sql_meeting_completed_date {
    type: time
    timeframes: [time, fiscal_month_num, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.sql_meeting_completed_date_c ;;
    hidden: yes  # No longer used. See https://docker.atlassian.net/browse/MS-2306
  }

  dimension_group: sql_meeting_completed_date_del {
    type: time
    timeframes: [time, fiscal_month_num, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.sql_meeting_completed_date_del_c ;;
    hidden: yes  # No longer used. See https://docker.atlassian.net/browse/MS-2306
  }

  dimension_group: sql_meeting_scheduled_date {
    type: time
    timeframes: [time, fiscal_month_num, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.sql_meeting_scheduled_date_c ;;
    hidden: yes  # No longer used. See https://docker.atlassian.net/browse/MS-2306
  }

  dimension_group: sql_meeting_scheduled_date_del {
    type: time
    timeframes: [time, fiscal_month_num, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.sql_meeting_scheduled_date_del_c ;;
    hidden: yes  # No longer used. See https://docker.atlassian.net/browse/MS-2306
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: state_code {
    type: string
    sql: ${TABLE}.state_code ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: street {
    type: string
    sql: ${TABLE}.street ;;
  }

  dimension: sub_region {
    description: "Sub-Region for the lead (sales territory)"
    type: string
    sql: ${TABLE}.sub_region_c ;;
  }

  dimension: subscription_name {
    type: string
    sql: ${TABLE}.subscription_name_c ;;
  }

  dimension: subscription_status {
    type: string
    sql: ${TABLE}.subscription_status_c ;;
  }

  dimension_group: system_modstamp {
    type: time
    timeframes: [time, fiscal_month_num, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.system_modstamp ;;
  }

  dimension: technology_partner_del {
    type: yesno
    sql: ${TABLE}.technology_partner_del_c ;;
  }

  dimension: title {
    type: string
    sql: ${TABLE}.title ;;
  }

  dimension: tradeshow_lead_priority {
    type: string
    sql: ${TABLE}.tradeshow_lead_priority_c ;;
  }

  dimension: tu_aws_linked {
    type: yesno
    sql: ${TABLE}.tu_aws_linked_c ;;
  }

  dimension: tu_azure_linked {
    type: yesno
    sql: ${TABLE}.tu_azure_linked_c ;;
  }

  dimension: tu_digitalocean_linked {
    type: yesno
    sql: ${TABLE}.tu_digitalocean_linked_c ;;
  }

  dimension: tu_github_linked {
    type: yesno
    sql: ${TABLE}.tu_github_linked_c ;;
  }

  dimension: tu_keyvaas_user {
    type: yesno
    sql: ${TABLE}.tu_keyvaas_user_c ;;
  }

  dimension: tu_node_docker_upgrade {
    type: number
    sql: ${TABLE}.tu_node_docker_upgrade_c ;;
  }

  dimension: tu_nodes_byon_total {
    type: number
    sql: ${TABLE}.tu_nodes_byon_total_c ;;
  }

  dimension: tu_nodes_total {
    type: number
    sql: ${TABLE}.tu_nodes_total_c ;;
  }

  dimension: tu_packet_linked {
    type: yesno
    sql: ${TABLE}.tu_packet_linked_c ;;
  }

  dimension: tu_services_total {
    type: number
    sql: ${TABLE}.tu_services_total_c ;;
  }

  dimension: tu_softlayer_linked {
    type: yesno
    sql: ${TABLE}.tu_softlayer_linked_c ;;
  }

  dimension: tu_stackfile_user {
    type: yesno
    sql: ${TABLE}.tu_stackfile_user_c ;;
  }

  dimension: tu_stacks_total {
    type: number
    sql: ${TABLE}.tu_stacks_total_c ;;
  }

  dimension: tu_total_private_images {
    type: number
    sql: ${TABLE}.tu_total_private_images_c ;;
  }

  dimension: tu_user_activation {
    type: yesno
    sql: ${TABLE}.tu_user_activation_c ;;
  }

  dimension: tu_user_id {
    type: number
    value_format_name: id
    sql: ${TABLE}.tu_user_id_c ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}.type_c ;;
  }

  dimension: uuid {
    type: number
    value_format_name: id
    sql: ${TABLE}.uuid ;;
  }

  dimension_group: uuid_ts {
    type: time
    timeframes: [time, fiscal_month_num, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.uuid_ts ;;
  }

  dimension: website {
    type: string
    sql: ${TABLE}.website ;;
  }

  dimension: years_in_business {
    type: number
    sql: ${TABLE}.years_in_business_c ;;
  }

  dimension: engagio_matched_account_annual_revenue {
    description: ""
    type: number
    value_format: "$#,##0.00"
    sql: ${TABLE}.engagio_matched_account_annual_revenue_c ;;
  }

  dimension: engagio_matched_account {
    description: "Existing SFDC Account that engagio matched to this lead"
    type: string
    sql: ${TABLE}.engagio_matched_account_c ;;
  }

  dimension: engagio_matched_account_employees {
    description: ""
    type: number
    sql: ${TABLE}.engagio_matched_account_employees_c ;;
  }

  dimension: engagio_matched_account_hq_state {
    description: ""
    type: string
    sql: ${TABLE}.engagio_matched_account_hq_state_c ;;
  }

  dimension: engagio_matched_account_industry {
    description: ""
    type: string
    sql: ${TABLE}.engagio_matched_account_industry_c ;;
  }

  dimension: engagio_matched_account_name {
    description: ""
    type: string
    sql: ${TABLE}.engagio_matched_account_name_c ;;
  }

  dimension: engagio_matched_account_owner_name {
    description: ""
    type: string
    sql: ${TABLE}.engagio_matched_account_owner_name_c ;;
  }

  dimension: engagio_matched_account_type {
    description: ""
    type: string
    sql: ${TABLE}.engagio_matched_account_type_c ;;
  }

  dimension: engagio_department {
    description: ""
    type: string
    sql: ${TABLE}.engagio_department_c ;;
  }

  dimension: engagio_engagement_minutes_last_3_months {
    description: ""
    type: number
    sql: ${TABLE}.engagio_engagement_minutes_last_3_months_c ;;
  }

  dimension: engagio_engagement_minutes_last_7_days {
    description: ""
    type: number
    sql: ${TABLE}.engagio_engagement_minutes_last_7_days_c ;;
  }

  dimension_group: engagio_first_engagement_date {
    description: ""
    type: time
    timeframes: [time, fiscal_month_num, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.engagio_first_engagement_date_c ;;
  }

  dimension: engagio_matched_account_engage_mins_last_3_months {
    description: ""
    type: number
    sql: ${TABLE}.engagio_matched_account_engage_mins_last_3_months_c ;;
  }

  dimension: engagio_matched_account_engage_mins_last_7_days {
    description: ""
    type: number
    sql: ${TABLE}.engagio_matched_account_engage_mins_last_7_days_c ;;
  }

  dimension: engagio_matched_account_engagio_status {
    description: ""
    type: string
    sql: ${TABLE}.engagio_matched_account_engagio_status_c ;;
  }

  dimension: engagio_role {
    description: ""
    type: string
    sql: ${TABLE}.engagio_role_c ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  set: detail {
    fields: [
      id,
      company,
      name,
      title,
      email,
      status,

      lead_lifecycle_stage,

      became_mel_date_date,
      became_mqldate_date,
      became_sal_date_date,
      became_sql_date_date,

      recycled_date,
      recycled_from_stage,

      disqualified_date,
      disqualified_from_stage,

      city,
      state,
      postal_code,

      geo,
      region,
      sub_region,
      country,
      marketo_leads.lead_source,

      # Lead Owners Join
      lead_owners.title,
      lead_owners.department,
      lead_owners.name,
      lead_owners.sales_rep_type,
    ]
  }
}
