connection: "data_warehouse"

include: "store/store*.view.lkml"
include: "reghub*[!.][!z].view.lkml"
include: "ucp*[!.][!z].view.lkml"
include: "highland*[!.][!z].view.lkml"
include: "docker*[!.][!z].view.lkml"
include: "billforward/billforward_accounts.view.lkml"
include: "billforward/billforward_subscriptions.view.lkml"
include: "billforward/billforward_products.view.lkml"
include: "billforward/billforward_mrr_movements.view.lkml"
include: "sf__accounts.view.lkml"

# Define the Fiscal Year offset
fiscal_month_offset:  -11 # starts in February

# # Select the views that should be a part of this model,
# # and define the joins that connect them together.
#
# - explore: order_items
#   joins:
#     - join: orders
#       sql_on: ${orders.id} = ${order_items.order_id}
#     - join: users
#       sql_on: ${users.id} = ${orders.user_id}

explore: free_product_subscriptions {
  from: store_free_product_subscriptions
}

explore: product_subscriptions {
  from: store_product_subscriptions
}

explore: storebits_download {
  from: store_storebits_download
}

explore: store_eid1_docker_downloaded {
  label: "Store Docker Edition Downloads"
  view_label: "Edition Downloads"
  join: docker_users {
    from: reghub_dockeruser
    sql_on: ${store_eid1_docker_downloaded.user_id} = replace(${docker_users.uuid}, '-','') ;;
    relationship: many_to_one
  }
}

explore: docker_downloads {
  from: store_docker_download

  join: docker_users {
    from: reghub_dockeruser
    sql_on: ${docker_downloads.user_id} = replace(${docker_users.uuid}, '-','') ;;
    relationship: many_to_one
  }
}


explore: tracked_events {
  from: store_tracks
  sql_always_where: ${page_url} LIKE '%https://store.docker.com%' OR  ${page_url} LIKE '%https://hub.docker.com%';;

  join: docker_users {
    from: reghub_dockeruser
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
    required_joins: [docker_users]
    sql_on: ${docker_downloads.user_id} = replace(${docker_users.uuid}, '-','') ;;
    relationship: many_to_one
  }

  join: sf__accounts {
    view_label: "SFDC Accounts"
    sql_on: ${docker_users.domain_name} = ${sf__accounts.domain} ;;
    relationship: many_to_one
  }
}

explore: searches {
  from: store_search
  sql_always_where: ${page_url} LIKE '%https://store.docker.com%' OR ${page_url} LIKE '%https://hub.docker.com%' ;;

  join: docker_users {
    from: reghub_dockeruser
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

  join: ucp_usage {
    from: ucp_mixpanel
    sql_on: ${ucp_usage.license_key} = ${ucp_licenses.license_key} ;;
    relationship: many_to_one
  }
}

explore: page_views {
  from: store_pages
  sql_always_where: ${page_url} LIKE '%https://store.docker.com%' OR ${page_url} LIKE '%https://hub.docker.com%' ;;

  join: docker_users {
    from: reghub_dockeruser
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

  join: ucp_usage {
    from: ucp_mixpanel
    sql_on: ${ucp_usage.license_key} = ${ucp_licenses.license_key} ;;
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
  join: docker_users {
    from: reghub_dockeruser
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

#   joins:
#     - join: ddc_purchase
#       from: store_ddc_purchase
#       sql_on: ${store_users.docker_uuid} = ${ddc_purchase.user_id}
#     - join: ddc_trial_signup
#       from: store_ddc_trial_signup
#       sql_on: ${store_users.docker_uuid} = ${ddc_trial_signup.user_id}
#     - join: download_license
#       from: store_download_license
#       sql_on: ${store_users.docker_uuid} = ${download_license.user_id}
#     - join: account_info_update
#       from: store_account_info_update
#       sql_on: ${store_users.docker_uuid} = ${account_info_update.user_id}
#     - join: searches
#       from: store_search
#       sql_on: ${store_users.docker_uuid} = ${searches.user_id}
#     - join: page_views
#       from: store_pages
#       sql_on: ${store_users.docker_uuid} = ${page_views.user_id}
#     - join: tracked_events
#       from: store_tracks
#       sql_on: ${store_users.docker_uuid} = ${tracked_events.user_id}
#     - join: browse
#       from: store_browse
#       sql_on: ${store_users.docker_uuid} = ${browse.user_id}
#     - join: subscription_created
#       from: store_subscription_created
#       sql_on: ${store_users.docker_uuid} = ${subscription_created.user_id}
#     - join: submitted_product_pricing
#       from: store_submitted_product_pricing
#       sql_on: ${store_users.docker_uuid} = ${submitted_product_pricing.user_id}
#     - join: submitted_product_information
#       from: store_submitted_product_information
#       sql_on: ${store_users.docker_uuid} = ${submitted_product_information.user_id}
#     - join: submitted_product_for_review
#       from: store_submitted_product_for_review
#       sql_on: ${store_users.docker_uuid} = ${submitted_product_for_review.user_id}
#     - join: ddc_login
#       from: store_ddc_login
#       sql_on: ${store_users.docker_uuid} = ${ddc_login.user_id}
#     - join: signed_up_for_private_beta
#       from: store_signed_up_for_private_beta
#       sql_on: ${store_users.docker_uuid} = ${signed_up_for_private_beta.user_id}
#     - join: signed_up_to_become_a_publisher
#       from: store_signed_up_to_become_a_publisher
#       sql_on: ${store_users.docker_uuid} = ${signed_up_to_become_a_publisher.user_id}
#     - join: logged_in_on_beta_page
#       from: store_logged_in_on_beta_page
#       sql_on: ${store_users.docker_uuid} = ${logged_in_on_beta_page.user_id}
