connection: "snowflake_production"

include: "snowflake_docker_active_hosts.view.lkml"

# include Docker Hub Usage dashboard
include: "docker_hub_usage.dashboard.lookml"

# # Select the views that should be a part of this model,
# # and define the joins that connect them together.
#
# - explore: order_items
#   joins:
#     - join: orders
#       sql_on: ${orders.id} = ${order_items.order_id}
#     - join: users
#       sql_on: ${users.id} = ${orders.user_id}

explore: docker_active_hosts {
  from: snowflake_docker_active_hosts
  sql_always_where: ${repo_name} LIKE '%microsoft/%' ;;
  hidden: yes
}
