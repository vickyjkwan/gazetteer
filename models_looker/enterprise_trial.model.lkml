connection: "data_warehouse"

include: "hosted*[!.][!z].view.lkml"

# Explore generic events to understand user behavior
explore: hosted_trial_tracks {

  # Join the identifies table on the user id to query user emails
  join: hosted_trial_identifies {
    view_label: "Identifies"
    sql_on: ${hosted_trial_tracks.user_id} = ${hosted_trial_identifies.user_id} ;;
    relationship: many_to_one
  }
}

# Explore generic events to understand user behavior
explore: hosted_trial_velocity {

  # Join the identifies table on the user id to query user emails
  join: hosted_trial_identifies {
    view_label: "Identifies"
    sql_on: ${hosted_trial_velocity.user_id} = ${hosted_trial_identifies.user_id} ;;
    relationship: many_to_one
  }
}

# Explore generic events to understand user behavior
explore: hosted_trial_pages {

  # Join the identifies table on the user id to query user emails
  join: hosted_trial_identifies {
    view_label: "Identifies"
    sql_on: ${hosted_trial_pages.user_id} = ${hosted_trial_identifies.user_id} ;;
    relationship: many_to_one
  }
}
