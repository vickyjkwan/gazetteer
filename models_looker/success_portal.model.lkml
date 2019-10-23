connection: "data_warehouse"

include: "success*[!.][!z].view.lkml"

# See https://segment.com/docs/destinations/#warehouse-schemas
explore: success_users {
  label: "Users"
  description: "Success Portal Users"
  join: success_identifies {
    sql_on: ${success_users.id} = ${success_identifies.user_id} ;;
    relationship: one_to_many
  }
}
explore: success_pages {
  label: "Page Visits"
  description: "Success Portal Page Visits"
  join: success_identifies {
    view_label: "Identify Calls"
    sql_on: ${success_pages.anonymous_id} = ${success_identifies.anonymous_id}
            OR
            ${success_pages.user_id} = ${success_identifies.user_id};;
    relationship: one_to_many
  }
  join: success_users {
    view_label: "Users"
    sql_on: ${success_users.id} = ${success_identifies.user_id} ;;
    relationship: one_to_one
  }
}
explore: success_tracks {
  label: "Track Events"
  view_label: "Track Events"
  description: "Success Portal Track calls including Thumbs-up/down"
  join: success_identifies {
    view_label: "Identify Calls"
    sql_on: ${success_tracks.anonymous_id} = ${success_identifies.anonymous_id}
            OR
            ${success_tracks.user_id} = ${success_identifies.user_id};;
    relationship: one_to_many
  }
  join: success_users {
    view_label: "Users"
    sql_on: ${success_users.id} = ${success_identifies.user_id} ;;
    relationship: one_to_one
  }
  join: success_thumbs_up {
    view_label: "Thumbs-up Events"
    sql_on: ${success_tracks.id} = ${success_thumbs_up.id} ;;
    relationship: one_to_one
  }
  join: success_thumbs_down {
    view_label: "Thumbs-down Events"
    sql_on: ${success_tracks.id} = ${success_thumbs_down.id} ;;
    relationship: one_to_one
  }
}
