connection: "snowflake_production"

include: "job_config.view.lkml"

# # Select the views that should be a part of this model,
# # and define the joins that connect them together.
#
explore: status {
  from: job_config
}
