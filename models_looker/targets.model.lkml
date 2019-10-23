connection: "data_warehouse"

include: "targets_marketing_by_quarter.view.lkml"

explore: targets_marketing_by_quarter {
  hidden: yes
}
