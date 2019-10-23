view: sf__cases {
  extends: [sfbase__cases]
}

view: sfbase__cases {
  sql_table_name: salesforce.cases ;;

  dimension: id {
    link: {
      label: "SFDC Case"
      url: "https://docker.my.salesforce.com/{{value}}"
      icon_url: "https://docker.my.salesforce.com/favicon.ico"
    }
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension: case_sfdc_link {
    label: "Link to SFDC Case"
    type: string
    sql: CONCAT('https://docker.my.salesforce.com/', ${TABLE}.id) ;;
  }

  dimension: access_to_customer_network_c {
    type: string
    sql: ${TABLE}.access_to_customer_network_c ;;
  }

  dimension: access_to_customer_pii_c {
    type: string
    sql: ${TABLE}.access_to_customer_pii_c ;;
  }

  dimension: account_c {
    type: string
    sql: ${TABLE}.account_c ;;
  }

  dimension: account_id {
    type: string
    # hidden: yes
    sql: ${TABLE}.account_id ;;
  }

  dimension: account_management_c {
    type: yesno
    sql: ${TABLE}.account_management_c ;;
  }

  dimension: account_name_c {
    type: string
    sql: ${TABLE}.account_name_c ;;
  }

  dimension: amount_c {
    type: string
    sql: ${TABLE}.amount_c ;;
  }

  dimension: amount_of_initial_purchase_c {
    type: string
    sql: ${TABLE}.amount_of_initial_purchase_c ;;
  }

  dimension: assigned_to_c {
    type: string
    sql: ${TABLE}.assigned_to_c ;;
  }

  dimension: associated_contract_record_c {
    type: string
    sql: ${TABLE}.associated_contract_record_c ;;
  }

  dimension: automation_prompted_c {
    type: yesno
    sql: ${TABLE}.automation_prompted_c ;;
  }

  dimension: billing_c {
    type: yesno
    sql: ${TABLE}.billing_c ;;
  }

  dimension: business_hours_id {
    type: string
    sql: ${TABLE}.business_hours_id ;;
  }

  dimension: case_comment_c {
    type: string
    sql: ${TABLE}.case_comment_c ;;
  }

  dimension: case_number {
    type: string
    sql: ${TABLE}.case_number ;;
  }

  dimension: category_c {
    type: string
    sql: ${TABLE}.category_c ;;
  }

  dimension_group: close_date_c {
    type: time
    timeframes: [
      raw,
      time, fiscal_quarter, fiscal_year,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.close_date_c ;;
  }

  dimension_group: closed {
    type: time
    timeframes: [
      raw,
      time, fiscal_quarter, fiscal_year,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.closed_date ;;
  }

  dimension: consulting_services_included_c {
    type: string
    sql: ${TABLE}.consulting_services_included_c ;;
  }

  dimension: contact_docker_hub_email_address_c {
    type: string
    sql: ${TABLE}.contact_docker_hub_email_address_c ;;
  }

  dimension: contact_docker_hub_org_name_c {
    type: string
    sql: ${TABLE}.contact_docker_hub_org_name_c ;;
  }

  dimension: contact_docker_hub_user_name_c {
    type: string
    sql: ${TABLE}.contact_docker_hub_user_name_c ;;
  }

  dimension: contact_email {
    type: string
    sql: ${TABLE}.contact_email ;;
  }

  dimension: contact_email_address_c {
    type: string
    sql: ${TABLE}.contact_email_address_c ;;
  }

  dimension: contact_email_c {
    type: string
    sql: ${TABLE}.contact_email_c ;;
  }

  dimension: contact_fax {
    type: string
    sql: ${TABLE}.contact_fax ;;
  }

  dimension: contact_id {
    type: string
    # hidden: yes
    sql: ${TABLE}.contact_id ;;
  }

  dimension: contact_mobile {
    type: string
    sql: ${TABLE}.contact_mobile ;;
  }

  dimension: contact_phone {
    type: string
    sql: ${TABLE}.contact_phone ;;
  }

  dimension: created_by_id {
    type: string
    sql: ${TABLE}.created_by_id ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time, fiscal_quarter, fiscal_year,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_date ;;
  }

  dimension: critsit_c {
    type: yesno
    sql: ${TABLE}.critsit_c ;;
  }

  dimension: currency_iso_code {
    type: string
    sql: ${TABLE}.currency_iso_code ;;
  }

  dimension: days_to_extend_c {
    type: number
    sql: ${TABLE}.days_to_extend_c ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}.description ;;
  }

  dimension: direct_touch_c {
    type: yesno
    sql: ${TABLE}.direct_touch_c ;;
  }

  dimension: docker_cloud_c {
    type: yesno
    sql: ${TABLE}.docker_cloud_c ;;
  }

  dimension: docker_hub_account_c {
    type: string
    sql: ${TABLE}.docker_hub_account_c ;;
  }

  dimension: docker_hub_c {
    type: yesno
    sql: ${TABLE}.docker_hub_c ;;
  }

  dimension: docker_personnel_on_site_c {
    type: string
    sql: ${TABLE}.docker_personnel_on_site_c ;;
  }

  dimension: email_c {
    type: string
    sql: ${TABLE}.email_c ;;
  }

  dimension: enterprise_247_c {
    type: yesno
    sql: ${TABLE}.enterprise_247_c ;;
  }

  dimension: enterprise_email_c {
    type: yesno
    sql: ${TABLE}.enterprise_email_c ;;
  }

  dimension: enterprise_none_c {
    type: yesno
    sql: ${TABLE}.enterprise_none_c ;;
  }

  dimension: enterprise_standard_c {
    type: yesno
    sql: ${TABLE}.enterprise_standard_c ;;
  }

  dimension: entitlement_id {
    type: string
    sql: ${TABLE}.entitlement_id ;;
  }

  dimension: entitlement_name_custom_c {
    type: string
    sql: ${TABLE}.entitlement_name_custom_c ;;
  }

  dimension: git_hub_ticket_c {
    type: string
    sql: ${TABLE}.git_hub_ticket_c ;;
  }

  dimension: group_c {
    type: string
    sql: ${TABLE}.group_c ;;
  }

  dimension: handle_with_care_c {
    type: yesno
    sql: ${TABLE}.handle_with_care_c ;;
  }

  dimension: index_ticket_c {
    type: yesno
    sql: ${TABLE}.index_ticket_c ;;
  }

  dimension_group: initial_response_c {
    type: time
    timeframes: [
      raw,
      time, fiscal_quarter, fiscal_year,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.initial_response_c ;;
  }

  dimension: is_closed {
    type: yesno
    sql: ${TABLE}.is_closed ;;
  }

  dimension: is_deleted {
    type: yesno
    sql: ${TABLE}.is_deleted ;;
  }

  dimension: is_escalated {
    type: yesno
    sql: ${TABLE}.is_escalated ;;
  }

  dimension: last_email_c {
    type: string
    sql: ${TABLE}.last_email_c ;;
  }

  dimension: last_modified_by_id {
    type: string
    sql: ${TABLE}.last_modified_by_id ;;
  }

  dimension_group: last_modified {
    type: time
    timeframes: [
      raw,
      time, fiscal_quarter, fiscal_year,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.last_modified_date ;;
  }

  dimension_group: last_referenced {
    type: time
    timeframes: [
      raw,
      time, fiscal_quarter, fiscal_year,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.last_referenced_date ;;
  }

  dimension_group: last_viewed {
    type: time
    timeframes: [
      raw,
      time, fiscal_quarter, fiscal_year,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.last_viewed_date ;;
  }

  dimension_group: latest_public_case_comment_c {
    type: time
    timeframes: [
      raw,
      time, fiscal_quarter, fiscal_year,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.latest_public_case_comment_c ;;
  }

  dimension: lead_name_c {
    type: string
    sql: ${TABLE}.lead_name_c ;;
  }

  dimension: license_extension_c {
    type: yesno
    sql: ${TABLE}.license_extension_c ;;
  }

  dimension: license_trial_c {
    type: yesno
    sql: ${TABLE}.license_trial_c ;;
  }

  dimension: milestone_status {
    type: string
    sql: ${TABLE}.milestone_status ;;
  }

  dimension: n_2_de_is_distributed_c {
    type: yesno
    sql: ${TABLE}.n_2_de_is_distributed_c ;;
  }

  dimension: n_2_de_is_reassigned_c {
    type: yesno
    sql: ${TABLE}.n_2_de_is_reassigned_c ;;
  }

  dimension: n_2_de_is_trigger_enabled_c {
    type: yesno
    sql: ${TABLE}.n_2_de_is_trigger_enabled_c ;;
  }

  dimension: n_2_de_is_triggered_c {
    type: yesno
    sql: ${TABLE}.n_2_de_is_triggered_c ;;
  }

  dimension: next_steps_c {
    type: string
    sql: ${TABLE}.next_steps_c ;;
  }

  dimension: noclose_c {
    type: yesno
    sql: ${TABLE}.noclose_c ;;
  }

  dimension: nosurvey_c {
    type: yesno
    sql: ${TABLE}.nosurvey_c ;;
  }

  dimension: onboarding_c {
    type: yesno
    sql: ${TABLE}.onboarding_c ;;
  }

  dimension: opportunity_c {
    type: string
    sql: ${TABLE}.opportunity_c ;;
  }

  dimension: origin {
    type: string
    sql: ${TABLE}.origin ;;
  }

  dimension: ownedby_running_user_c {
    type: yesno
    sql: ${TABLE}.ownedby_running_user_c ;;
  }

  dimension: owner_id {
    type: string
    sql: ${TABLE}.owner_id ;;
  }

  dimension: paper_c {
    type: string
    sql: ${TABLE}.paper_c ;;
  }

  dimension: person_name_c {
    type: string
    sql: ${TABLE}.person_name_c ;;
  }

  dimension: pinata_beta_c {
    type: yesno
    sql: ${TABLE}.pinata_beta_c ;;
  }

  dimension: plan_cloud_metered_c {
    type: yesno
    sql: ${TABLE}.plan_cloud_metered_c ;;
  }

  dimension: plan_micro_c {
    type: yesno
    sql: ${TABLE}.plan_micro_c ;;
  }

  dimension: plan_small_c {
    type: yesno
    sql: ${TABLE}.plan_small_c ;;
  }

  dimension: priority {
    type: string
    sql: ${TABLE}.priority ;;
  }

  dimension: product_c {
    type: string
    sql: ${TABLE}.product_c ;;
  }

  dimension: product_to_be_purchased_c {
    type: string
    sql: ${TABLE}.product_to_be_purchased_c ;;
  }

  dimension: reason {
    type: string
    sql: ${TABLE}.reason ;;
  }

  dimension: reason_for_extension_c {
    type: string
    sql: ${TABLE}.reason_for_extension_c ;;
  }

  dimension_group: received {
    type: time
    timeframes: [
      raw,
      time, fiscal_quarter, fiscal_year,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.received_at ;;
  }

  dimension: record_type_id {
    type: string
    sql: ${TABLE}.record_type_id ;;
  }

  dimension: record_type_id_c {
    type: string
    sql: ${TABLE}.record_type_id_c ;;
  }

  dimension: request_object_c {
    type: string
    sql: ${TABLE}.request_object_c ;;
  }

  dimension: reseller_details_c {
    type: string
    sql: ${TABLE}.reseller_details_c ;;
  }

  dimension: reseller_involved_c {
    type: string
    sql: ${TABLE}.reseller_involved_c ;;
  }

  dimension: sales_c {
    type: yesno
    sql: ${TABLE}.sales_c ;;
  }

  dimension_group: scheduled_meeting_date_c {
    type: time
    timeframes: [
      raw,
      time, fiscal_quarter, fiscal_year,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.scheduled_meeting_date_c ;;
  }

  dimension: scheduled_meeting_time_c {
    type: string
    sql: ${TABLE}.scheduled_meeting_time_c ;;
  }

  dimension: set_case_comment_close_other_nosurvey_c {
    type: yesno
    sql: ${TABLE}.set_case_comment_close_other_nosurvey_c ;;
  }

  dimension: set_case_comment_com_support_cloud_c {
    type: yesno
    sql: ${TABLE}.set_case_comment_com_support_cloud_c ;;
  }

  dimension: set_case_comment_com_support_personal_c {
    type: yesno
    sql: ${TABLE}.set_case_comment_com_support_personal_c ;;
  }

  dimension: set_case_comment_deactivate_org_c {
    type: yesno
    sql: ${TABLE}.set_case_comment_deactivate_org_c ;;
  }

  dimension: set_case_comment_deactivate_user_c {
    type: yesno
    sql: ${TABLE}.set_case_comment_deactivate_user_c ;;
  }

  dimension: set_case_comment_dmca_takedown_c {
    type: yesno
    sql: ${TABLE}.set_case_comment_dmca_takedown_c ;;
  }

  dimension: set_case_comment_dsinfo_c {
    type: yesno
    sql: ${TABLE}.set_case_comment_dsinfo_c ;;
  }

  dimension: set_case_comment_no_active_subs_solve_c {
    type: yesno
    sql: ${TABLE}.set_case_comment_no_active_subs_solve_c ;;
  }

  dimension: set_case_comment_no_active_subscriptio_c {
    type: yesno
    sql: ${TABLE}.set_case_comment_no_active_subscriptio_c ;;
  }

  dimension: set_case_comment_rename_user_c {
    type: yesno
    sql: ${TABLE}.set_case_comment_rename_user_c ;;
  }

  dimension: set_case_comment_request_aws_acct_id_c {
    type: yesno
    sql: ${TABLE}.set_case_comment_request_aws_acct_id_c ;;
  }

  dimension: set_case_comment_sec_rpt_scriptkiddie_c {
    type: yesno
    sql: ${TABLE}.set_case_comment_sec_rpt_scriptkiddie_c ;;
  }

  dimension: set_case_comment_spam_c {
    type: yesno
    sql: ${TABLE}.set_case_comment_spam_c ;;
  }

  dimension: set_case_comment_support_biz_critical_c {
    type: yesno
    sql: ${TABLE}.set_case_comment_support_biz_critical_c ;;
  }

  dimension: set_case_comment_support_biz_day_c {
    type: yesno
    sql: ${TABLE}.set_case_comment_support_biz_day_c ;;
  }

  dimension: set_case_comment_support_dtr_trial_c {
    type: yesno
    sql: ${TABLE}.set_case_comment_support_dtr_trial_c ;;
  }

  dimension: set_case_comment_support_email_only_c {
    type: yesno
    sql: ${TABLE}.set_case_comment_support_email_only_c ;;
  }

  dimension: set_case_comment_ticket_handoff_c {
    type: yesno
    sql: ${TABLE}.set_case_comment_ticket_handoff_c ;;
  }

  dimension: set_case_comment_trial_extension_c {
    type: yesno
    sql: ${TABLE}.set_case_comment_trial_extension_c ;;
  }

  dimension: set_case_comment_ucp_biz_critical_c {
    type: yesno
    sql: ${TABLE}.set_case_comment_ucp_biz_critical_c ;;
  }

  dimension: set_case_comment_ucp_dtr_cs_biz_critic_c {
    type: yesno
    sql: ${TABLE}.set_case_comment_ucp_dtr_cs_biz_critic_c ;;
  }

  dimension: set_case_comment_ucp_dtr_cs_biz_day_c {
    type: yesno
    sql: ${TABLE}.set_case_comment_ucp_dtr_cs_biz_day_c ;;
  }

  dimension: set_case_comment_ucp_only_biz_day_c {
    type: yesno
    sql: ${TABLE}.set_case_comment_ucp_only_biz_day_c ;;
  }

  dimension: set_owner_to_current_user_c {
    type: yesno
    sql: ${TABLE}.set_owner_to_current_user_c ;;
  }

  dimension: silent_close_c {
    type: yesno
    sql: ${TABLE}.silent_close_c ;;
  }

  dimension_group: sla_start {
    type: time
    timeframes: [
      raw,
      time, fiscal_quarter, fiscal_year,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.sla_start_date ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: subcontracting_consulting_services_c {
    type: string
    sql: ${TABLE}.subcontracting_consulting_services_c ;;
  }

  dimension: subject {
    type: string
    sql: ${TABLE}.subject ;;
  }

  dimension: supplied_company {
    type: string
    sql: ${TABLE}.supplied_company ;;
  }

  dimension: supplied_email {
    type: string
    sql: ${TABLE}.supplied_email ;;
  }

  dimension: supplied_name {
    type: string
    sql: ${TABLE}.supplied_name ;;
  }

  dimension: supplied_phone {
    type: string
    sql: ${TABLE}.supplied_phone ;;
  }

  dimension: surveysent_c {
    type: yesno
    sql: ${TABLE}.surveysent_c ;;
  }

  dimension_group: system_modstamp {
    type: time
    timeframes: [
      raw,
      time, fiscal_quarter, fiscal_year,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.system_modstamp ;;
  }

  dimension: tam_account_c {
    type: yesno
    sql: ${TABLE}.tam_account_c ;;
  }

  dimension: tam_email_address_c {
    type: string
    sql: ${TABLE}.tam_email_address_c ;;
  }

  dimension: tam_first_name_c {
    type: string
    sql: ${TABLE}.tam_first_name_c ;;
  }

  dimension: tam_included_c {
    type: string
    sql: ${TABLE}.tam_included_c ;;
  }

  dimension: ticket_acknowledged_c {
    type: yesno
    sql: ${TABLE}.ticket_acknowledged_c ;;
  }

  dimension: timeframe_c {
    type: string
    sql: ${TABLE}.timeframe_c ;;
  }

  dimension: trial_extention_c {
    type: yesno
    sql: ${TABLE}.trial_extention_c ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}.type ;;
  }

  dimension: uuid {
    type: number
    value_format_name: id
    sql: ${TABLE}.uuid ;;
  }

  dimension_group: uuid_ts {
    type: time
    timeframes: [
      raw,
      time, fiscal_quarter, fiscal_year,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.uuid_ts ;;
  }

  dimension: welcometosupport_c {
    type: yesno
    sql: ${TABLE}.welcometosupport_c ;;
  }

  dimension: zendesk_id_c {
    type: string
    sql: ${TABLE}.zendesk_id_c ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
    link: {
      url: "/dashboards/215"
      icon_url: "http://looker.com/favicon.ico"
      label: "Support Dashboard"
    }
  }

  measure: count_closed {
    type: count

    filters: {
      field: is_closed
      value: "Yes"
    }
    drill_fields: [detail*]
    link: {
      url: "/dashboards/215"
      icon_url: "http://looker.com/favicon.ico"
      label: "Support Dashboard"
    }
  }

  measure: count_open {
    type: count

    filters: {
      field: is_closed
      value: "No"
    }
    drill_fields: [detail*]
    link: {
      url: "/dashboards/215"
      icon_url: "http://looker.com/favicon.ico"
      label: "Support Dashboard"
    }
  }

  measure: case_ids {
    description: "List of case ids"
    type: list
    list_field: id
  }

  measure: case_sfdc_links {
    description: "List of SFDC links to Cases"
    type: list
    list_field: case_sfdc_link
  }

  measure: average_days_open {
    type: average
    sql: DATEDIFF(days, ${TABLE}.created_date, COALESCE(${TABLE}.closed_date, GETDATE()));;
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      sf__accounts.name,
      id,
      contact_email,
      sf__contacts.name,
      created_date,
      last_modified_date,
      priority,
      status,
      sf__opportunities.total_subscription_revenue,
      sf__opportunity_products.total_quantity,
    ]
  }
}
