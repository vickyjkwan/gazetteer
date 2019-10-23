connection: "data_warehouse"

# include all views in this project
include: "slack_docker_community_history.view.lkml"

# # Select the views that should be a part of this model,
# # and define the joins that connect them together.
#
explore: docker_community_history {
  from: slack_docker_community_history
}
