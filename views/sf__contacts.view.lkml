view: sf__contacts {
  extends: [sfbase__contacts]

  set: focused {
    fields: [
      sf__contacts.behavior_score,
      sf__contacts.became_mql_date,
      sf__contacts.became_mql_fiscal_quarter,
      sf__contacts.became_sql_date,
      sf__contacts.became_sql_fiscal_quarter,
      sf__contacts.became_sal_date,
      sf__contacts.became_sal_fiscal_quarter,
      sf__contacts.name,
      sf__contacts.lead_source,
      sf__contacts.lead_source_detail,
      sf__contacts.lifecycle_stage,
      sf__contacts.record_type_id,
      sf__contacts.sub_region,
      sf__contacts.region,
      sf__contacts.geo,
      sf__contacts.status,
      sf__contacts.dscorgpkg_company_hq_state,
      sf__contacts.dscorgpkg_company_hq_state_full_name,
      sf__contacts.type,
      sf__contacts.dscorgpkg_company_hq_country_code,
      sf__contacts.dscorgpkg_company_hq_country_full_name,
      sf__contacts.dscorgpkg_company_hq_postal_code,
      sf__contacts.dscorgpkg_company_hq_city,
      sf__contacts.email
    ]
  }
}

view: sfbase__contacts {
  sql_table_name: salesforce.contacts ;;

  dimension: jigsaw_contact_id {
    type: string
    sql: ${TABLE}.jigsaw_contact_id ;;
  }

  dimension: account_id {
    type: string
    # hidden: true
    sql: ${TABLE}.account_id ;;
  }

  dimension: accredi {
    type: string
    sql: ${TABLE}.accredi_c ;;
  }

  dimension: accreditation_types {
    type: string
    sql: ${TABLE}.accreditation_types_c ;;
  }

  dimension: accredited {
    type: yesno
    sql: ${TABLE}.accredited_c ;;
  }

  dimension: agreement_version {
    type: string
    sql: ${TABLE}.agreement_version_c ;;
  }

  dimension: alias {
    type: string
    sql: ${TABLE}.alias_c ;;
  }

  dimension: authentication_type {
    type: string
    sql: ${TABLE}.authentication_type_c ;;
  }

  dimension_group: became_mel {
    type: time
    timeframes: [time, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.became_mel_date_c ;;
  }

  dimension_group: became_mql {
    type: time
    timeframes: [time, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.became_mqldate_c ;;
  }

  dimension_group: became_sal {
    type: time
    timeframes: [time, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.became_sal_date_c ;;
  }

  dimension_group: became_sql {
    type: time
    timeframes: [time, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.became_sql_date_c ;;
  }

  dimension_group: became_sqo {
    type: time
    timeframes: [time, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.became_sqo_date_c ;;
  }

  dimension: behavior_score {
    type: number
    sql: ${TABLE}.behavior_score_c ;;
  }

  dimension: bfwd_bfaccount_id {
    type: string
    sql: ${TABLE}.bfwd_bfaccount_id_c ;;
  }

  dimension: bfwd_is_primary {
    type: yesno
    sql: ${TABLE}.bfwd_is_primary_c ;;
  }

  dimension: bizible_bizible_id {
    type: string
    sql: ${TABLE}.bizible_2_bizible_id_c ;;
  }

  dimension: bizible_landing_page_ft {
    type: string
    sql: ${TABLE}.bizible_2_landing_page_ft_c ;;
  }

  dimension: bizible_landing_page_lc{
    type: string
    sql: ${TABLE}.bizible_2_landing_page_lc_c ;;
  }

  dimension: bizible_marketing_channel_ft {
    type: string
    sql: ${TABLE}.bizible_2_marketing_channel_ft_c ;;
  }

  dimension: bizible_marketing_channel_lc {
    type: string
    sql: ${TABLE}.bizible_2_marketing_channel_lc_c ;;
  }

  dimension: bizible_touchpoint_date_ft {
    type: string
    sql: ${TABLE}.bizible_2_touchpoint_date_ft_c ;;
  }

  dimension: bizible_touchpoint_date_lc {
    type: string
    sql: ${TABLE}.bizible_2_touchpoint_date_lc_c ;;
  }

  dimension: bizible_touchpoint_source_ft {
    type: string
    sql: ${TABLE}.bizible_2_touchpoint_source_ft_c ;;
  }

  dimension: bizible_touchpoint_source_lc {
    type: string
    sql: ${TABLE}.bizible_2_touchpoint_source_lc_c ;;
  }

  dimension: breakout_sessions_c {
    type: string
    sql: ${TABLE}. ;;
  }


  dimension_group: click_to_accept_date {
    type: time
    timeframes: [time, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.click_to_accept_date_c ;;
  }

  dimension: cloudingo_agent_ces {
    type: number
    sql: ${TABLE}.cloudingo_agent_ces_c ;;
  }

  dimension: cloudingo_agent_mas {
    type: number
    sql: ${TABLE}.cloudingo_agent_mas_c ;;
  }

  dimension: cloudingo_agent_oas {
    type: number
    sql: ${TABLE}.cloudingo_agent_oas_c ;;
  }

  dimension: competition {
    type: string
    sql: ${TABLE}.competition_c ;;
  }

  dimension: contact_name_for_flow {
    type: string
    sql: ${TABLE}.contact_name_for_flow_c ;;
  }

  dimension: created_by_id {
    type: string
    sql: ${TABLE}.created_by_id ;;
  }

  dimension_group: created {
    type: time
    timeframes: [time, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.created_date ;;
  }

  dimension: currency_iso_code {
    type: string
    sql: ${TABLE}.currency_iso_code ;;
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
    timeframes: [time, fiscal_quarter, fiscal_year, date, week, month]
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

  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
  }

  dimension: dhe_usage_type {
    type: string
    sql: ${TABLE}.dhe_usage_type_c ;;
  }

  dimension: docker_familiarity {
    type: string
    sql: ${TABLE}.docker_familiarity_c ;;
  }

  dimension: docker_hub_email_address {
    type: string
    sql: ${TABLE}.docker_hub_email_address_c ;;
  }

  dimension: docker_hub_organization_name {
    type: string
    sql: ${TABLE}.docker_hub_organization_name_c ;;
  }

  dimension: docker_hub_user_name {
    type: string
    sql: ${TABLE}.docker_hub_user_name_c ;;
  }

  dimension: docker_id {
    type: string
    sql: ${TABLE}.docker_id_c ;;
  }

  dimension: docker_readiness {
    type: string
    sql: ${TABLE}.docker_readiness_c ;;
  }

  dimension: dps {
    type: string
    sql: ${TABLE}.dps_c ;;
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

  dimension: dscorgpkg_discover_org_id {
    type: string
    sql: ${TABLE}.dscorgpkg_discover_org_id_c ;;
  }

  dimension_group: dscorgpkg_discover_org_last_update {
    type: time
    timeframes: [time, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.dscorgpkg_discover_org_last_update_c ;;
  }

  dimension: dscorgpkg_discover_org_technologies {
    type: string
    sql: ${TABLE}.dscorgpkg_discover_org_technologies_c ;;
  }

  dimension: dscorgpkg_exclude_update {
    type: yesno
    sql: ${TABLE}.dscorgpkg_exclude_update_c ;;
  }

  dimension: dscorgpkg_external_discover_org_id {
    type: string
    sql: ${TABLE}.dscorgpkg_external_discover_org_id_c ;;
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

  dimension: dscorgpkg_reports_to {
    type: string
    sql: ${TABLE}.dscorgpkg_reports_to_c ;;
  }

  dimension: dscorgpkg_twitter_url {
    type: string
    sql: ${TABLE}.dscorgpkg_twitter_url_c ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
    tags: ["email"]
  }

  dimension_group: email_bounced {
    type: time
    timeframes: [time, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.email_bounced_date ;;
  }

  dimension: email_bounced_reason {
    type: string
    sql: ${TABLE}.email_bounced_reason ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: fortune_10k_global {
    description: "Contact belongs to a Global 10k company"
    type: yesno
    sql: ${TABLE}.fortune_10_k_c ;;
  }

  dimension: fortune_2000_global {
    type: yesno
    sql: ${TABLE}.fortune_2000_global_c ;;
  }

  dimension: geo {
    description: "GEO for contact"
    type: string
    sql: ${TABLE}.geo_c ;;
  }

  dimension: global_engagement_score {
    type: string
    sql: ${TABLE}.global_engagement_score_c ;;
  }

  dimension: global_firmographic_score {
    type: string
    sql: ${TABLE}.global_firmographic_score_c ;;
  }

  dimension: has_been_community_enabled {
    type: yesno
    sql: ${TABLE}.has_been_community_enabled_c ;;
  }

  dimension: id {
    description: "Unique SFDC ID for Contact"
    primary_key:  yes
    type: string
    sql: ${TABLE}.id ;;
    link: {
      label: "SFDC Contact"
      url: "https://docker.my.salesforce.com/{{value}}"
      icon_url: "https://docker.my.salesforce.com/favicon.ico"
    }
  }

  dimension: contact_sfdc_link {
    description: "Link to SFDC Contact"
    type: string
    sql: CONCAT('https://docker.my.salesforce.com/', ${TABLE}.id) ;;
  }

  dimension: introduction_to_docker_training {
    type: string
    sql: ${TABLE}.introduction_to_docker_training_c ;;
  }

  dimension: name_email {
    type: string
    sql: ${name} || ' <' || ${email} || '>' ;;
  }

  dimension: is_deleted {
    type: yesno
    sql: ${TABLE}.is_deleted ;;
  }

  dimension: is_email_bounced {
    type: yesno
    sql: ${TABLE}.is_email_bounced ;;
  }

  dimension_group: last_activity {
    type: time
    timeframes: [time, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.last_activity_date ;;
  }

  dimension: last_modified_by_id {
    type: string
    sql: ${TABLE}.last_modified_by_id ;;
  }

  dimension_group: last_modified {
    type: time
    timeframes: [time, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.last_modified_date ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension_group: last_referenced {
    type: time
    timeframes: [time, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.last_referenced_date ;;
  }

  dimension_group: last_updated_date_by_iv {
    type: time
    timeframes: [time, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.last_updated_date_by_iv_c ;;
  }

  dimension_group: last_viewed {
    type: time
    timeframes: [time, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.last_viewed_date ;;
  }

  dimension: lead_quality_rating {
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

  dimension: lifecycle_stage {
    type: string
    sql: ${TABLE}.lifecycle_stage_c ;;
  }

  dimension: mailing_city {
    type: string
    sql: ${TABLE}.mailing_city ;;
  }

  dimension: mailing_country {
    type: string
    sql: ${TABLE}.mailing_country ;;
  }

  dimension: mailing_country_code {
    type: string
    sql: ${TABLE}.mailing_country_code ;;
  }

  dimension: mailing_postal_code {
    type: string
    sql: ${TABLE}.mailing_postal_code ;;
  }

  dimension: mailing_state {
    type: string
    sql: ${TABLE}.mailing_state ;;
  }

  dimension: mailing_state_code {
    type: string
    sql: ${TABLE}.mailing_state_code ;;
  }

  dimension: mailing_street {
    type: string
    sql: ${TABLE}.mailing_street ;;
  }

  dimension: matched_status {
    type: string
    sql: ${TABLE}.matched_status_c ;;
  }

  dimension: mdr_manager_approvied {
    type: string
    sql: ${TABLE}.mdr_manager_approvied_c ;;
  }

  dimension: member {
    type: yesno
    sql: ${TABLE}.member_c ;;
  }

  dimension_group: mkto_2_acquisition_date {
    type: time
    timeframes: [time, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.mkto_2_acquisition_date_c ;;
  }

  dimension: mkto_2_acquisition_program {
    type: string
    sql: ${TABLE}.mkto_2_acquisition_program_c ;;
  }

  dimension: mkto_2_acquisition_program_id {
    type: number
    value_format_name: id
    sql: ${TABLE}.mkto_2_acquisition_program_id_c ;;
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
    timeframes: [time, fiscal_quarter, fiscal_year, date, week, month]
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
    timeframes: [time, fiscal_quarter, fiscal_year, date, week, month]
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

  dimension: mkto_si_sales_insight {
    type: string
    sql: ${TABLE}.mkto_si_sales_insight_c ;;
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

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: netsuite_conn_celigo_update {
    type: yesno
    sql: ${TABLE}.netsuite_conn_celigo_update_c ;;
  }

  dimension: netsuite_conn_net_suite_id {
    type: string
    sql: ${TABLE}.netsuite_conn_net_suite_id_c ;;
  }

  dimension: netsuite_conn_net_suite_sync_err {
    type: string
    sql: ${TABLE}.netsuite_conn_net_suite_sync_err_c ;;
  }

  dimension: netsuite_conn_push_to_net_suite {
    type: yesno
    sql: ${TABLE}.netsuite_conn_push_to_net_suite_c ;;
  }

  dimension: netsuite_conn_sync_in_progress {
    type: yesno
    sql: ${TABLE}.netsuite_conn_sync_in_progress_c ;;
  }

  dimension: owner_id {
    type: string
    sql: ${TABLE}.owner_id ;;
  }

  dimension: partner_interest {
    type: string
    sql: ${TABLE}.partner_interest_c ;;
  }

  dimension: partner_ratings {
    type: string
    sql: ${TABLE}.partner_ratings_c ;;
  }

  dimension: partner_source {
    type: string
    sql: ${TABLE}.partner_source_c ;;
  }

  dimension: partner_type {
    type: string
    sql: ${TABLE}.partner_type_c ;;
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

  dimension: portal_access {
    type: string
    sql: ${TABLE}.portal_access_c ;;
  }

  dimension: product_interest {
    type: string
    sql: ${TABLE}.product_interest_c ;;
  }

  dimension: qualified_by_sdr {
    type: string
    sql: ${TABLE}.qualified_by_sdr_c ;;
  }

  dimension: reason_disqualified {
    type: string
    sql: ${TABLE}.reason_disqualified_c ;;
  }

  dimension_group: received {
    type: time
    timeframes: [time, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.received_at ;;
  }

  dimension: record_type_id {
    type: string
    sql: ${TABLE}.record_type_id ;;
  }

  dimension: recurly_company {
    type: string
    sql: ${TABLE}.recurly_company_c ;;
  }

  dimension: recurly_county {
    type: string
    sql: ${TABLE}.recurly_county_c ;;
  }

  dimension: recurly_state {
    type: string
    sql: ${TABLE}.recurly_state_c ;;
  }

  dimension: recycled_reason_contact {
    type: string
    sql: ${TABLE}.recycled_reason_contact_c ;;
  }

  dimension: region {
    description: "REGION for contact"
    type: string
    sql: ${TABLE}.region_c ;;
  }

  dimension: reports_to_id {
    type: string
    sql: ${TABLE}.reports_to_id ;;
  }

  dimension: ring_lead_dms_status {
    type: string
    sql: ${TABLE}.ring_lead_dms_status_c ;;
  }

  dimension: role {
    type: string
    sql: ${TABLE}.role_c ;;
  }

  dimension: sales_confirmed_docker_expertise_scale {
    type: string
    sql: ${TABLE}.sales_confirmed_docker_expertise_scale_c ;;
  }

  dimension: sales_confirmed_engine_version_cs1_6 {
    type: yesno
    sql: ${TABLE}.sales_confirmed_engine_version_cs1_6_c ;;
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

  dimension: salutation {
    type: string
    sql: ${TABLE}.salutation ;;
  }

  dimension_group: sql_meeting_completed_date {
    type: time
    timeframes: [time, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.sql_meeting_completed_date_c ;;
  }

  dimension_group: sql_meeting_scheduled_date {
    type: time
    timeframes: [time, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.sql_meeting_scheduled_date_c ;;
  }

  dimension: status {
    description: "Contact status"
    type: string
    sql: ${TABLE}.CONTACT_STATUS_C ;;
  }

  dimension: sub_region {
    description: "SUB-REGION for contact"
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
    timeframes: [time, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.system_modstamp ;;
  }

  dimension: title {
    type: string
    sql: ${TABLE}.title ;;
  }

  dimension: tradeshow_lead_priority {
    type: string
    sql: ${TABLE}.tradeshow_lead_priority_c ;;
  }

  dimension: current_csat_feedback {
    label: "Current CSAT Feedback"
    type: string
    sql: ${TABLE}.wootric_current_csat_feedback_c  ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}.type_c ;;
  }

  dimension: nps_contact {
    label: "NPS Contact"
    type: yesno
    sql: ${TABLE}.nps_contact_c ;;
    drill_fields: [detail*]
  }

  dimension: previous_csat_score {
    label: "CSAT Score (previous)"
    type: number
    sql: ${TABLE}.wootric_previous_csat_score_c ;;
    drill_fields: [detail*]
  }

  dimension: current_nps_score {
    label: "NPS Score (current)"
    type: number
    sql: ${TABLE}.wootric_current_nps_score_c ;;
    drill_fields: [detail*]
  }

  dimension: current_csat_score {
    label: "CSAT Score (current)"
    type: number
    sql: ${TABLE}.wootric_current_csat_score_c ;;
    drill_fields: [detail*]
  }

  dimension: uuid {
    type: number
    hidden: yes
    value_format_name: id
    sql: ${TABLE}.uuid ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # Calculations for average have been multiplied by 1.0 to render the decimal values correctly as the value formatting was not functioning as expected.
  measure: avg_current_csat_score {
    label: "Average CSAT Score (current)"
    type: average
    sql: ${TABLE}.wootric_current_csat_score_c*1.0;;
    drill_fields: [detail*]
  }

  measure: avg_previous_csat_score {
    label: "Average CSAT Score (previous)"
    type: average
    sql: ${TABLE}.wootric_previous_csat_score_c*1.0 ;;
    drill_fields: [detail*]
  }

  measure: avg_current_nps_score {
    label: "Average NPS Score (current)"
    type: average
    sql: ${TABLE}.wootric_current_nps_score_c*1.0 ;;
    drill_fields: [detail*]
  }

  measure: net_new_nps_trigger {
    label: "Net New NPS Trigger"
    type: yesno
    sql: ${TABLE}.net_new_nps_trigger_c ;;
    drill_fields: [detail*]
  }

  measure: renewal_nps_trigger {
    label: "Renewal NPS Trigger"
    type: yesno
    sql: ${TABLE}.renewal_nps_trigger_c ;;
    drill_fields: [detail*]
  }

  measure: contact_sfdc_links {
    type: list
    list_field: contact_sfdc_link
  }

  measure: contact_ids {
    type: list
    list_field: id
  }

  measure: contact_names{
    type: list
    list_field: name_email
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      first_name,
      last_name,
      name,
      accounts.account_id_c,
      accounts.name,
      campaign_members.count,
      cases.count,
      opportunity_contact_role.count,
      users.count,
      current_nps_score,
      current_csat_score
    ]
  }
}
