connection: "data_warehouse"

include: "stripe*[!.][!z].view.lkml"

# # Select the views that should be a part of this model,
# # and define the joins that connect them together.
#
explore: stripe_charges {}

explore: stripe_transfers {}
