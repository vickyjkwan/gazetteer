connection: "snowflake_production"

include: "billforward/billforward*.view.lkml"
include: "reghub*[!.][!z].view.lkml"
include: "date_dimension.view.lkml"
include: "docker_user_repo_count.view.lkml"
include: "sf__cases.view.lkml"

fiscal_month_offset: -11

explore: accounts {
  from: billforward_accounts

  join: docker_users {
    from: reghub_dockeruser
    sql_on: ${accounts.docker_id} = replace(docker_users.uuid, '-','') ;;
    relationship: one_to_one
  }
}

explore: daily_active_subscriptions {
  from: billforward_subscription_activity_days

  join: subscriptions {
    from: billforward_subscriptions
    relationship: one_to_many
    sql_on: (DATE_TRUNC('day', ${subscriptions.initial_period_start_raw}) <= ${daily_active_subscriptions.day}) AND
            ((${subscriptions.subscription_end_raw} IS NULL AND ${subscriptions.cancellation_raw} IS NULL) OR
            (DATE_TRUNC('day', ${subscriptions.subscription_end_raw}) >= ${daily_active_subscriptions.day}) OR
            (DATE_TRUNC('day', ${subscriptions.cancellation_raw}) >= ${daily_active_subscriptions.day})) ;;
  }
}

explore: billforward_account_repo_map {
  join: docker_user_repo_count {
    sql_on: ${docker_user_repo_count.uuid} = ${billforward_account_repo_map.docker_id} ;;
    relationship: one_to_one
  }
  join: support_tickets {
    sql_table_name: SEGMENT.SALESFORCE.cases ;;
    from: sf__cases
    sql_on: ${billforward_account_repo_map.email} = ${support_tickets.contact_email} ;;
    relationship: many_to_one
  }
}

explore: products{
  from:  billforward_products
}

explore: subscriptions {
  from: billforward_subscriptions

  join: accounts {
    from: billforward_accounts
    sql_on: ${subscriptions.account_id} = ${accounts.account_id} ;;
    relationship: many_to_one
  }

  join: docker_users {
    from: reghub_dockeruser
    sql_on: ${accounts.docker_id} = replace(docker_users.uuid, '-','') ;;
    relationship: one_to_one
  }
}

explore: issued_invoices {
  from: billforward_invoiced
  sql_always_where: ${issued_invoices.product_name} <> 'Test Product 1' ;;

  join: subscriptions {
    from: billforward_subscriptions
    sql_on: ${subscriptions.subscription_id} = ${issued_invoices.child_subscription_id} ;;
    relationship: many_to_one
  }

  join: accounts {
    from: billforward_accounts
    sql_on: ${subscriptions.account_id} = ${accounts.account_id} ;;
    relationship: many_to_one
  }

  join: docker_users {
    from: reghub_dockeruser
    sql_on: ${accounts.docker_id} = replace(docker_users.uuid, '-','') ;;
    relationship: one_to_one
  }
}

explore: fulfilled_invoices {
  from: billforward_fulfilled
  sql_always_where: ${fulfilled_invoices.product_name} <> 'Test Product 1' ;;

  join: subscriptions {
    from: billforward_subscriptions
    sql_on: ${subscriptions.subscription_id} = ${fulfilled_invoices.child_subscription_id} ;;
    relationship: many_to_one
  }

  join: accounts {
    from: billforward_accounts
    sql_on: ${subscriptions.account_id} = accounts.account_id ;;
    relationship: many_to_one
  }

  join: docker_users {
    from: reghub_dockeruser
    sql_on: ${accounts.docker_id} = replace(docker_users.uuid, '-','') ;;
    relationship: one_to_one
  }
}

explore: mrr_movements {
  from: billforward_mrr_movements
  persist_for: "24 hours"
  label: "MRR Movements"

  join: subscriptions {
    from: billforward_subscriptions
    sql_on: ${subscriptions.subscription_id} = ${mrr_movements.subscription_id} ;;
    relationship: many_to_one
  }

  join: accounts {
    from: billforward_accounts
    sql_on: ${mrr_movements.account_id} = ${accounts.account_id} ;;
    relationship: many_to_one
  }

  join: docker_users {
    from: reghub_dockeruser
    sql_on: ${accounts.docker_id} = replace(docker_users.uuid, '-','') ;;
    relationship: one_to_one
  }

  join: customers_with_active_subscriptions {
    from: billforward_subscriber_snapshot
    sql_on: ${mrr_movements.account_id} = ${customers_with_active_subscriptions.account_id} ;;
    relationship: many_to_one
  }

  join: repositories {
    relationship: many_to_one
    from: reghub_repositories
    sql_on: ${repositories.hub_user_id} = docker_users.uuid ;;
    required_joins: [docker_users]
  }
}

explore: billforward_quarterly_subscriber_snapshot{}

explore: customers_churn {
  label: "Customers Churn"
  from: billforward_subscription_snapshot_churn

  join: accounts {
    from: billforward_accounts
    sql_on: ${customers_churn.account_id} = ${accounts.account_id} ;;
    relationship: many_to_one
  }

  join: docker_users {
    from: reghub_dockeruser
    sql_on: ${accounts.docker_id} = replace(docker_users.uuid, '-','') ;;
    relationship: one_to_one
  }
}
