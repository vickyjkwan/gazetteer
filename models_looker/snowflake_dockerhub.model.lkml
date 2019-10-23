connection: "snowflake_medium"

include: "snowflake_metrics_apilog.view.lkml"
include: "reghub_repositories.view.lkml"
include: "weekly_report.view.lkml"
include: "snowflake_reghub_dockeruser.view.lkml"
include: "metrics_apilog_operatingsystems.view.lkml"
include: "snowflake_metrics_apilog_repos.view.lkml"
include: "snowflake_docker_active_hosts.view.lkml"
include: "official_repos_pull_12_weeks.view.lkml"
include: "metrics.view.lkml"
include: "metrics_api_repo_action_counts.view.lkml"
include: "docker_user*"
include: "highland_build*"
include: "ucp_usage_pdt.z.view.lkml"  # PDT specific to Snowflake
include: "ucp_usage.view.lkml"
include: "ucp_licensing.view.lkml"
include: "billforward/billforward_*.view.lkml"
include: "store/store*.view.lkml"
include: "sf__accounts.view.lkml"

explore: metrics_apilog_operatingsystems {}

explore: weekly_report {}

explore: raw_metrics_apilog {
  from: snowflake_metrics_apilog
}

explore: reghub_dockeruser {
  from:  snowflake_reghub_dockeruser
  label: "User Lookup"
  view_label: "User Lookup"
  description: "Find all the actions by username"

  join: metrics_apilog {
    from:  snowflake_docker_active_hosts
    sql_on: metrics_apilog.user_id = replace(reghub_dockeruser.uuid, '-','') ;;
    relationship: one_to_one
  }

  join: repositories {
    from: reghub_repositories
    sql_on: repositories.hub_user_id = reghub_dockeruser.uuid ;;
    relationship: many_to_one
  }
}

explore: metrics {}

explore: metrics_apilog {
  from:  snowflake_docker_active_hosts
  persist_for: "24 hours"

  join: docker_users {
    from: snowflake_reghub_dockeruser
    relationship: many_to_one
    sql_on: metrics_apilog.user_id = replace(docker_users.uuid, '-','') ;;
  }

  join: repositories {
    from: reghub_repositories
    sql_on: repositories.repo_name = metrics_apilog.repo_name AND repositories.tag_name = metrics_apilog.tag_name ;;
    relationship: many_to_one
  }
}


explore:store_eid1_docker_downloaded  {
  label: "Desktop Downloads and Hub Usage"
  sql_table_name: SEGMENT.STORE.EID1_DOCKER_DOWNLOADED ;;
  join: snowflake_metrics_apilog {
    sql_on: ${store_eid1_docker_downloaded.user_id} = ${snowflake_metrics_apilog.user_id};;
    type: left_outer
    relationship: many_to_many
  }
}


explore: metrics_apilog_repos {
  from: snowflake_metrics_apilog_repos
}

explore: official_repos_pull_12_weeks {
  hidden: yes
}

explore: docker_active_hosts {
  from: snowflake_docker_active_hosts
  hidden: yes
}

explore: metrics_api_repo_action_counts {}

#NEW


explore: free_product_subscriptions {
  from: store_free_product_subscriptions
}

explore: product_subscriptions {
  from: store_product_subscriptions
}

explore: storebits_download {
  from: store_storebits_download
}

explore: docker_downloads {
  from: store_docker_download

  join: docker_users {
    from: snowflake_reghub_dockeruser
    sql_on: ${docker_downloads.user_id} = replace(${docker_users.uuid}, '-','') ;;
    relationship: many_to_one
  }
}


explore: tracked_events {
  sql_table_name: SEGMENT.STORE.TRACKS ;;
  from: store_tracks
  sql_always_where: ${page_url} LIKE '%https://store.docker.com%' OR  ${page_url} LIKE '%https://hub.docker.com%';;

  join: docker_users {
    from: snowflake_reghub_dockeruser
    sql_on: ${tracked_events.docker_id} = replace(${docker_users.uuid}, '-','') ;;
    relationship: many_to_one
  }

  join: repositories {
    from: reghub_repositories
    sql_on: ${repositories.hub_user_id} = ${docker_users.uuid} ;;
    relationship: many_to_one
    required_joins: [docker_users]
  }

  join: docker_user_activities {
    sql_on: ${docker_user_activities.user_uuid} = ${docker_users.uuid} ;;
    relationship: many_to_one
    required_joins: [docker_users]
  }

  join: highland_build_requests {
    sql_on: ${highland_build_requests.docker_repo} = ${repositories.repo_name} ;;
    relationship: many_to_one
    required_joins: [repositories]
  }

  join: ucp_licenses {
    from: ucp_licensing
    sql_on: ${ucp_licenses.hub_uuid} = replace(${docker_users.uuid}, '-','') ;;
    relationship: many_to_one
    required_joins: [docker_users]
  }

  join: ucp_usage {
    sql_on: ${ucp_usage.license_key} = ${ucp_licenses.license_key} ;;
    relationship: many_to_one
    required_joins: [ucp_licenses]
  }

  join: docker_downloads {
    from: store_docker_download
    sql_table_name: SEGMENT.STORE.DOCKER_DOWNLOAD ;;
    required_joins: [docker_users]
    sql_on: ${docker_downloads.user_id} = replace(${docker_users.uuid}, '-','') ;;
    relationship: many_to_one
  }

  join:  sf__accounts{
    sql_table_name: SEGMENT.SALESFORCE.ACCOUNTS ;;
    view_label: "SFDC Accounts"
    sql_on: ${docker_users.domain_name} = ${sf__accounts.domain} ;;
    relationship: many_to_one
  }
}

explore: searches {
  from: store_search
  sql_table_name: SEGMENT.STORE.SEARCH ;;
  sql_always_where: ${page_url} LIKE '%https://store.docker.com%' OR ${page_url} LIKE '%https://hub.docker.com%' ;;

  join: docker_users {
    from: snowflake_reghub_dockeruser
    sql_on: ${searches.docker_id} = replace(${docker_users.uuid}, '-','') ;;
    relationship: many_to_one
  }

  join: repositories {
    from: reghub_repositories
    sql_on: ${repositories.hub_user_id} = ${docker_users.uuid} ;;
    relationship: many_to_one
  }

  join: docker_user_activities {
    sql_on: ${docker_user_activities.user_uuid} = ${docker_users.uuid} ;;
    relationship: many_to_one
  }

  join: highland_build_requests {
    sql_on: ${highland_build_requests.docker_repo} = ${repositories.repo_name} ;;
    relationship: many_to_one
  }

  join: ucp_licenses {
    from: ucp_licensing
    sql_on: ${ucp_licenses.hub_uuid} = replace(${docker_users.uuid}, '-','') ;;
    relationship: many_to_one
  }

}

explore: page_views {
  from: store_pages
  sql_always_where: ${page_url} LIKE '%https://store.docker.com%' OR ${page_url} LIKE '%https://hub.docker.com%' ;;

  join: docker_users {
    from: snowflake_reghub_dockeruser
    sql_on: ${page_views.docker_id} = replace(${docker_users.uuid}, '-','') ;;
    relationship: many_to_one
  }

  join: repositories {
    from: reghub_repositories
    sql_on: ${repositories.hub_user_id} = ${docker_users.uuid} ;;
    relationship: many_to_one
  }

  join: docker_user_activities {
    sql_on: ${docker_user_activities.user_uuid} = ${docker_users.uuid} ;;
    relationship: many_to_one
  }

  join: highland_build_requests {
    sql_on: ${highland_build_requests.docker_repo} = ${repositories.repo_name} ;;
    relationship: many_to_one
  }

  join: ucp_licenses {
    from: ucp_licensing
    sql_on: ${ucp_licenses.hub_uuid} = replace(${docker_users.uuid}, '-','') ;;
    relationship: many_to_one
  }

}



explore: storedb_product {
  label: "Store Products and Subscriptions"

  join: billforward_products {
    sql_on: ${storedb_product.uuid} = ${billforward_products.meta_store_product_id} ;;
    relationship: one_to_one
  }

  join: billforward_subscriptions {
    sql_on: ${billforward_products.id} = ${billforward_subscriptions.product_id} ;;
    relationship: one_to_many
  }

  join: billforward_mrr_movements {
    sql_on: ${billforward_subscriptions.subscription_id} = ${billforward_mrr_movements.subscription_id} ;;
    relationship: one_to_many
  }

  join: storedb_plan {
    from: storedb_plan
    sql_on:  ${storedb_product.id}=${storedb_plan.product_id};;
    relationship: one_to_many
  }

  join: storedb_publisher {
    sql_on: ${storedb_product.publisher_id} = ${storedb_publisher.id} ;;
    relationship: many_to_one
  }

  join: storedb_publisher_policy {
    sql_on: ${storedb_publisher.id} = ${storedb_publisher_policy.publisher_id} ;;
    relationship: one_to_one
  }

  join: accounts {
    view_label: "Subscribers / Accounts"
    from: billforward_accounts
    sql_on: ${billforward_subscriptions.account_id} = ${accounts.account_id} ;;
    relationship: many_to_one
  }


}

explore: store_authorizer_pull {
  label: "Authorizer Pull"
  view_label: "Authorizer Pull"
  sql_table_name: SEGMENT.STORE.STORE_AUTHORIZER_PULL;;
  join: docker_users {
    from: snowflake_reghub_dockeruser
    sql_on: ${store_authorizer_pull.user_id} = replace(${docker_users.uuid}, '-','') ;;
    relationship: many_to_one
  }

  join: storedb_product {
    sql_on: ${store_authorizer_pull.product_id} = ${storedb_product.uuid} ;;
    relationship: many_to_one
  }

  join: storedb_product_draft {
    sql_on: ${storedb_product_draft.uuid} = ${storedb_product.uuid} ;;
    relationship: one_to_one
  }

  #plan should be joined directly with pull to get separate counts for plans
  join: storedb_plan {
    from: storedb_plan
    sql_on:  ${store_authorizer_pull.rate_plan_id}=${storedb_plan.uuid};;
    relationship: one_to_many
  }

  join: storedb_publisher {
    sql_on: ${storedb_product.publisher_id} = ${storedb_publisher.id} ;;
    relationship: many_to_one
  }

  join: storedb_publisher_policy {
    sql_on: ${storedb_publisher.id} = ${storedb_publisher_policy.publisher_id} ;;
    relationship: one_to_one
  }

}
