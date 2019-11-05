view: sf__users {
  extends: [sfbase__users]

  filter: name_select {
    suggest_dimension: name
  }

  dimension_group: created {
    type: time
    timeframes: [time, fiscal_quarter, fiscal_year, date, week, month, quarter, raw]
    sql: ${TABLE}.created_date ;;
  }

  dimension: age_in_months {
    type: number
    sql: datediff(days,${created_raw},current_date) ;;
  }
}

view: sfbase__users {
  sql_table_name: salesforce.users ;;

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
    link: {
      label: "SFDC Users"
      url: "https://docker.my.salesforce.com/{{value}}"
      icon_url: "https://docker.my.salesforce.com/favicon.ico"
    }
  }

  dimension: about_me {
    type: string
    sql: ${TABLE}.about_me ;;
  }

  dimension: account {
    type: string
    sql: ${TABLE}.account_c ;;
  }

  dimension: account_id {
    type: string
    # hidden: true
    sql: ${TABLE}.account_id ;;
  }

  dimension: alias {
    type: string
    sql: ${TABLE}.alias ;;
  }

  dimension: badge_text {
    type: string
    sql: ${TABLE}.badge_text ;;
  }

  dimension: banner_photo_url {
    type: string
    sql: ${TABLE}.banner_photo_url ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: community_nickname {
    type: string
    sql: ${TABLE}.community_nickname ;;
  }

  dimension: company_name {
    type: string
    sql: ${TABLE}.company_name ;;
  }

  dimension: contact_id {
    type: string
    # hidden: true
    sql: ${TABLE}.contact_id ;;
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
    timeframes: [time, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.created_date ;;
  }

  dimension: currency_iso_code {
    type: string
    sql: ${TABLE}.currency_iso_code ;;
  }

  dimension: default_currency_iso_code {
    type: string
    sql: ${TABLE}.default_currency_iso_code ;;
  }

  dimension: default_group_notification_frequency {
    type: string
    sql: ${TABLE}.default_group_notification_frequency ;;
  }

  dimension: delegated_approver_id {
    type: string
    sql: ${TABLE}.delegated_approver_id ;;
  }

  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
  }

  dimension: digest_frequency {
    type: string
    sql: ${TABLE}.digest_frequency ;;
  }

  dimension: division {
    type: string
    sql: ${TABLE}.division ;;
  }

  dimension: dsfs_dspro_sfmembership_status {
    type: string
    sql: ${TABLE}.dsfs_dspro_sfmembership_status_c ;;
  }

  dimension: dsfs_dspro_sfusername {
    type: string
    sql: ${TABLE}.dsfs_dspro_sfusername_c ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: email_encoding_key {
    type: string
    sql: ${TABLE}.email_encoding_key ;;
  }

  dimension: email_preferences_auto_bcc {
    type: yesno
    sql: ${TABLE}.email_preferences_auto_bcc ;;
  }

  dimension: email_preferences_auto_bcc_stay_in_touch {
    type: yesno
    sql: ${TABLE}.email_preferences_auto_bcc_stay_in_touch ;;
  }

  dimension: email_preferences_stay_in_touch_reminder {
    type: yesno
    sql: ${TABLE}.email_preferences_stay_in_touch_reminder ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: forecast_enabled {
    type: yesno
    sql: ${TABLE}.forecast_enabled ;;
  }

  dimension: full_photo_url {
    type: string
    sql: ${TABLE}.full_photo_url ;;
  }

  dimension: is_active {
    type: yesno
    sql: ${TABLE}.is_active ;;
  }

  dimension: is_portal_enabled {
    type: yesno
    sql: ${TABLE}.is_portal_enabled ;;
  }

  dimension: is_prm_super_user {
    type: yesno
    sql: ${TABLE}.is_prm_super_user ;;
  }

  dimension: is_profile_photo_active {
    type: yesno
    sql: ${TABLE}.is_profile_photo_active ;;
  }

  dimension: jigsaw_import_limit_override {
    type: number
    sql: ${TABLE}.jigsaw_import_limit_override ;;
  }

  dimension: language_locale_key {
    type: string
    sql: ${TABLE}.language_locale_key ;;
  }

  dimension_group: last_login {
    type: time
    timeframes: [time, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.last_login_date ;;
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

  dimension_group: last_password_change {
    type: time
    timeframes: [time, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.last_password_change_date ;;
  }

  dimension_group: last_referenced {
    type: time
    timeframes: [time, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.last_referenced_date ;;
  }

  dimension_group: last_viewed {
    type: time
    timeframes: [time, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.last_viewed_date ;;
  }

  dimension: locale_sid_key {
    type: string
    sql: ${TABLE}.locale_sid_key ;;
  }

  dimension: manager_id {
    type: string
    sql: ${TABLE}.manager_id ;;
  }

  dimension: mkto_si_is_caching_anon_web_activity_list {
    type: yesno
    sql: ${TABLE}.mkto_si_is_caching_anon_web_activity_list_c ;;
  }

  dimension: mkto_si_is_caching_best_bets {
    type: yesno
    sql: ${TABLE}.mkto_si_is_caching_best_bets_c ;;
  }

  dimension: mkto_si_is_caching_email_activity_list {
    type: yesno
    sql: ${TABLE}.mkto_si_is_caching_email_activity_list_c ;;
  }

  dimension: mkto_si_is_caching_grouped_web_activity_list {
    type: yesno
    sql: ${TABLE}.mkto_si_is_caching_grouped_web_activity_list_c ;;
  }

  dimension: mkto_si_is_caching_interesting_moments_list {
    type: yesno
    sql: ${TABLE}.mkto_si_is_caching_interesting_moments_list_c ;;
  }

  dimension: mkto_si_is_caching_scoring_list {
    type: yesno
    sql: ${TABLE}.mkto_si_is_caching_scoring_list_c ;;
  }

  dimension: mkto_si_is_caching_stream_list {
    type: yesno
    sql: ${TABLE}.mkto_si_is_caching_stream_list_c ;;
  }

  dimension: mkto_si_is_caching_watch_list {
    type: yesno
    sql: ${TABLE}.mkto_si_is_caching_watch_list_c ;;
  }

  dimension: mkto_si_is_caching_web_activity_list {
    type: yesno
    sql: ${TABLE}.mkto_si_is_caching_web_activity_list_c ;;
  }

  dimension: mkto_si_sales_insight_counter {
    type: number
    sql: ${TABLE}.mkto_si_sales_insight_counter_c ;;
  }

  dimension: mobile_phone {
    type: string
    sql: ${TABLE}.mobile_phone ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: name_assigned_to {
    description: "This is the owner field on Event page. To be joined with sf__events.owner_id"
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: created_by_name {
    description: "This is the created by field on Event page. To be joined with sf__events.created_by_id"
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: phone {
    type: string
    sql: ${TABLE}.phone ;;
  }

  dimension: postal_code {
    type: string
    sql: ${TABLE}.postal_code ;;
  }

  dimension: profile_id {
    type: string
    # hidden: true
    sql: ${TABLE}.profile_id ;;
  }

  dimension_group: received {
    type: time
    timeframes: [time, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.received_at ;;
  }

  dimension: receives_admin_info_emails {
    type: yesno
    sql: ${TABLE}.receives_admin_info_emails ;;
  }

  dimension: receives_info_emails {
    type: yesno
    sql: ${TABLE}.receives_info_emails ;;
  }

  dimension: sales_rep_type {
    description: "Rep type: Field, ISR, MDR (if user is a sales rep)"
    type: string
    sql:
      case
        when NOT ${is_active} THEN 'Inactive'
        when ${title} IN ('Regional Account Executive', 'Director of Enterprise Sales', 'Director, Sales', 'Director, Strategic Alliances','Sr Director, Sales','Regional Sales Director','Regional Sales Director, UKI','Regional Sales Manager','VP, Sales-Central','VP, Sales-East','VP, Sales-West') THEN 'Field'
        when ${title} IN ('Account Executive', 'Account Executive, Inside Sales', 'Sr Account Executive', 'Director, Inside Sales','Sr Manager, Inside Sales') then 'ISR'
        when ${title} IN ('BDR', 'Manager, Business Development') then 'BDR'
        when ${title} is null then 'No Owner -- Queue'
        else 'Unknown'
      end ;;
  }

  dimension: sender_email {
    type: string
    sql: ${TABLE}.sender_email ;;
  }

  dimension: signature {
    type: string
    sql: ${TABLE}.signature ;;
  }

  dimension: small_photo_url {
    type: string
    sql: ${TABLE}.small_photo_url ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: state_code {
    type: string
    sql: ${TABLE}.state_code ;;
  }

  dimension: street {
    type: string
    sql: ${TABLE}.street ;;
  }

  dimension_group: system_modstamp {
    type: time
    timeframes: [time, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.system_modstamp ;;
  }

  dimension: time_zone_sid_key {
    type: string
    sql: ${TABLE}.time_zone_sid_key ;;
  }

  dimension: title {
    type: string
    sql: ${TABLE}.title ;;
  }

  dimension: user_permissions_avantgo_user {
    type: yesno
    sql: ${TABLE}.user_permissions_avantgo_user ;;
  }

  dimension: user_permissions_call_center_auto_login {
    type: yesno
    sql: ${TABLE}.user_permissions_call_center_auto_login ;;
  }

  dimension: user_permissions_chatter_answers_user {
    type: yesno
    sql: ${TABLE}.user_permissions_chatter_answers_user ;;
  }

  dimension: user_permissions_interaction_user {
    type: yesno
    sql: ${TABLE}.user_permissions_interaction_user ;;
  }

  dimension: user_permissions_jigsaw_prospecting_user {
    type: yesno
    sql: ${TABLE}.user_permissions_jigsaw_prospecting_user ;;
  }

  dimension: user_permissions_knowledge_user {
    type: yesno
    sql: ${TABLE}.user_permissions_knowledge_user ;;
  }

  dimension: user_permissions_marketing_user {
    type: yesno
    sql: ${TABLE}.user_permissions_marketing_user ;;
  }

  dimension: user_permissions_mobile_user {
    type: yesno
    sql: ${TABLE}.user_permissions_mobile_user ;;
  }

  dimension: user_permissions_offline_user {
    type: yesno
    sql: ${TABLE}.user_permissions_offline_user ;;
  }

  dimension: user_permissions_sfcontent_user {
    type: yesno
    sql: ${TABLE}.user_permissions_sfcontent_user ;;
  }

  dimension: user_permissions_support_user {
    type: yesno
    sql: ${TABLE}.user_permissions_support_user ;;
  }

  dimension: user_permissions_work_dot_com_user_feature {
    type: yesno
    sql: ${TABLE}.user_permissions_work_dot_com_user_feature ;;
  }

  dimension: user_preferences_activity_reminders_popup {
    type: yesno
    sql: ${TABLE}.user_preferences_activity_reminders_popup ;;
  }

  dimension: user_preferences_apex_pages_developer_mode {
    type: yesno
    sql: ${TABLE}.user_preferences_apex_pages_developer_mode ;;
  }

  dimension: user_preferences_cache_diagnostics {
    type: yesno
    sql: ${TABLE}.user_preferences_cache_diagnostics ;;
  }

  dimension: user_preferences_dis_comment_after_like_email {
    type: yesno
    sql: ${TABLE}.user_preferences_dis_comment_after_like_email ;;
  }

  dimension: user_preferences_dis_mentions_comment_email {
    type: yesno
    sql: ${TABLE}.user_preferences_dis_mentions_comment_email ;;
  }

  dimension: user_preferences_dis_prof_post_comment_email {
    type: yesno
    sql: ${TABLE}.user_preferences_dis_prof_post_comment_email ;;
  }

  dimension: user_preferences_disable_all_feeds_email {
    type: yesno
    sql: ${TABLE}.user_preferences_disable_all_feeds_email ;;
  }

  dimension: user_preferences_disable_bookmark_email {
    type: yesno
    sql: ${TABLE}.user_preferences_disable_bookmark_email ;;
  }

  dimension: user_preferences_disable_change_comment_email {
    type: yesno
    sql: ${TABLE}.user_preferences_disable_change_comment_email ;;
  }

  dimension: user_preferences_disable_endorsement_email {
    type: yesno
    sql: ${TABLE}.user_preferences_disable_endorsement_email ;;
  }

  dimension: user_preferences_disable_feedback_email {
    type: yesno
    sql: ${TABLE}.user_preferences_disable_feedback_email ;;
  }

  dimension: user_preferences_disable_file_share_notifications_for_api {
    type: yesno
    sql: ${TABLE}.user_preferences_disable_file_share_notifications_for_api ;;
  }

  dimension: user_preferences_disable_followers_email {
    type: yesno
    sql: ${TABLE}.user_preferences_disable_followers_email ;;
  }

  dimension: user_preferences_disable_later_comment_email {
    type: yesno
    sql: ${TABLE}.user_preferences_disable_later_comment_email ;;
  }

  dimension: user_preferences_disable_like_email {
    type: yesno
    sql: ${TABLE}.user_preferences_disable_like_email ;;
  }

  dimension: user_preferences_disable_mentions_post_email {
    type: yesno
    sql: ${TABLE}.user_preferences_disable_mentions_post_email ;;
  }

  dimension: user_preferences_disable_message_email {
    type: yesno
    sql: ${TABLE}.user_preferences_disable_message_email ;;
  }

  dimension: user_preferences_disable_profile_post_email {
    type: yesno
    sql: ${TABLE}.user_preferences_disable_profile_post_email ;;
  }

  dimension: user_preferences_disable_share_post_email {
    type: yesno
    sql: ${TABLE}.user_preferences_disable_share_post_email ;;
  }

  dimension: user_preferences_disable_work_email {
    type: yesno
    sql: ${TABLE}.user_preferences_disable_work_email ;;
  }

  dimension: user_preferences_enable_auto_sub_for_feeds {
    type: yesno
    sql: ${TABLE}.user_preferences_enable_auto_sub_for_feeds ;;
  }

  dimension: user_preferences_event_reminders_checkbox_default {
    type: yesno
    sql: ${TABLE}.user_preferences_event_reminders_checkbox_default ;;
  }

  dimension: user_preferences_hide_chatter_onboarding_splash {
    type: yesno
    sql: ${TABLE}.user_preferences_hide_chatter_onboarding_splash ;;
  }

  dimension: user_preferences_hide_csndesktop_task {
    type: yesno
    sql: ${TABLE}.user_preferences_hide_csndesktop_task ;;
  }

  dimension: user_preferences_hide_csnget_chatter_mobile_task {
    type: yesno
    sql: ${TABLE}.user_preferences_hide_csnget_chatter_mobile_task ;;
  }

  dimension: user_preferences_hide_s1_browser_ui {
    type: yesno
    sql: ${TABLE}.user_preferences_hide_s1_browser_ui ;;
  }

  dimension: user_preferences_hide_second_chatter_onboarding_splash {
    type: yesno
    sql: ${TABLE}.user_preferences_hide_second_chatter_onboarding_splash ;;
  }

  dimension: user_preferences_jigsaw_list_user {
    type: yesno
    sql: ${TABLE}.user_preferences_jigsaw_list_user ;;
  }

  dimension: user_preferences_lightning_experience_preferred {
    type: yesno
    sql: ${TABLE}.user_preferences_lightning_experience_preferred ;;
  }

  dimension: user_preferences_path_assistant_collapsed {
    type: yesno
    sql: ${TABLE}.user_preferences_path_assistant_collapsed ;;
  }

  dimension: user_preferences_reminder_sound_off {
    type: yesno
    sql: ${TABLE}.user_preferences_reminder_sound_off ;;
  }

  dimension: user_preferences_show_city_to_external_users {
    type: yesno
    sql: ${TABLE}.user_preferences_show_city_to_external_users ;;
  }

  dimension: user_preferences_show_city_to_guest_users {
    type: yesno
    sql: ${TABLE}.user_preferences_show_city_to_guest_users ;;
  }

  dimension: user_preferences_show_country_to_external_users {
    type: yesno
    sql: ${TABLE}.user_preferences_show_country_to_external_users ;;
  }

  dimension: user_preferences_show_country_to_guest_users {
    type: yesno
    sql: ${TABLE}.user_preferences_show_country_to_guest_users ;;
  }

  dimension: user_preferences_show_email_to_external_users {
    type: yesno
    sql: ${TABLE}.user_preferences_show_email_to_external_users ;;
  }

  dimension: user_preferences_show_email_to_guest_users {
    type: yesno
    sql: ${TABLE}.user_preferences_show_email_to_guest_users ;;
  }

  dimension: user_preferences_show_fax_to_external_users {
    type: yesno
    sql: ${TABLE}.user_preferences_show_fax_to_external_users ;;
  }

  dimension: user_preferences_show_fax_to_guest_users {
    type: yesno
    sql: ${TABLE}.user_preferences_show_fax_to_guest_users ;;
  }

  dimension: user_preferences_show_manager_to_external_users {
    type: yesno
    sql: ${TABLE}.user_preferences_show_manager_to_external_users ;;
  }

  dimension: user_preferences_show_manager_to_guest_users {
    type: yesno
    sql: ${TABLE}.user_preferences_show_manager_to_guest_users ;;
  }

  dimension: user_preferences_show_mobile_phone_to_external_users {
    type: yesno
    sql: ${TABLE}.user_preferences_show_mobile_phone_to_external_users ;;
  }

  dimension: user_preferences_show_mobile_phone_to_guest_users {
    type: yesno
    sql: ${TABLE}.user_preferences_show_mobile_phone_to_guest_users ;;
  }

  dimension: user_preferences_show_postal_code_to_external_users {
    type: yesno
    sql: ${TABLE}.user_preferences_show_postal_code_to_external_users ;;
  }

  dimension: user_preferences_show_postal_code_to_guest_users {
    type: yesno
    sql: ${TABLE}.user_preferences_show_postal_code_to_guest_users ;;
  }

  dimension: user_preferences_show_profile_pic_to_guest_users {
    type: yesno
    sql: ${TABLE}.user_preferences_show_profile_pic_to_guest_users ;;
  }

  dimension: user_preferences_show_state_to_external_users {
    type: yesno
    sql: ${TABLE}.user_preferences_show_state_to_external_users ;;
  }

  dimension: user_preferences_show_state_to_guest_users {
    type: yesno
    sql: ${TABLE}.user_preferences_show_state_to_guest_users ;;
  }

  dimension: user_preferences_show_street_address_to_external_users {
    type: yesno
    sql: ${TABLE}.user_preferences_show_street_address_to_external_users ;;
  }

  dimension: user_preferences_show_street_address_to_guest_users {
    type: yesno
    sql: ${TABLE}.user_preferences_show_street_address_to_guest_users ;;
  }

  dimension: user_preferences_show_title_to_external_users {
    type: yesno
    sql: ${TABLE}.user_preferences_show_title_to_external_users ;;
  }

  dimension: user_preferences_show_title_to_guest_users {
    type: yesno
    sql: ${TABLE}.user_preferences_show_title_to_guest_users ;;
  }

  dimension: user_preferences_show_work_phone_to_external_users {
    type: yesno
    sql: ${TABLE}.user_preferences_show_work_phone_to_external_users ;;
  }

  dimension: user_preferences_show_work_phone_to_guest_users {
    type: yesno
    sql: ${TABLE}.user_preferences_show_work_phone_to_guest_users ;;
  }

  dimension: user_preferences_sort_feed_by_comment {
    type: yesno
    sql: ${TABLE}.user_preferences_sort_feed_by_comment ;;
  }

  dimension: user_preferences_task_reminders_checkbox_default {
    type: yesno
    sql: ${TABLE}.user_preferences_task_reminders_checkbox_default ;;
  }

  dimension: user_role_id {
    type: string
    sql: ${TABLE}.user_role_id ;;
  }

  dimension: user_type {
    type: string
    sql: ${TABLE}.user_type ;;
  }

  dimension: username {
    type: string
    sql: ${TABLE}.username ;;
  }

  dimension: uuid {
    type: number
    value_format_name: id
    sql: ${TABLE}.uuid ;;
  }

  dimension_group: uuid_ts {
    type: time
    timeframes: [time, fiscal_quarter, fiscal_year, date, week, month]
    sql: ${TABLE}.uuid_ts ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      community_nickname,
      company_name,
      first_name,
      last_name,
      name,
      username,
      accounts.account_id_c,
      accounts.name,
      contacts.first_name,
      contacts.jigsaw_contact_id,
      contacts.last_name,
      contacts.name,
      profile.id,
      profile.name,
      user_login.count
    ]
  }
}
