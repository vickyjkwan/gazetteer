connection: "snowflake_production"

include: "gh_*"

fiscal_month_offset: -11 # Looker syntax to allow FQ to be mapped to +1Y and 1M

explore: gh_jobs {
  label: "Greenhouse Jobs"
  view_label: "Jobs"
  join: gh_applications_latest {
    view_label: "Applications"
    relationship: one_to_many
    sql_on: ${gh_jobs.id} = ${gh_applications_latest.job_id} ;;
  }

  join: gh_candidates {
    view_label: "Candidates"
    relationship: many_to_one
    sql_on: ${gh_applications_latest.candidate_id} = ${gh_candidates.candidate_id} ;;
  }

  join: gh_job_posts {
    view_label: "Job Board"
    relationship: one_to_many
    sql_on: ${gh_applications_latest.job_id} = ${gh_job_posts.job_id} ;;
  }

  join: gh_offers {
    view_label: "Offers"
    relationship: one_to_many
    sql_on: ${gh_applications_latest.application_id} = ${gh_offers.application_id}  ;;
  }
}
explore: gh_candidates {
  label: "Greenhouse Candidates"
  view_label: "Candidates"
  join: gh_applications_latest {
    view_label: "Applications"
    relationship: many_to_one
    sql_on: ${gh_candidates.candidate_id} = ${gh_applications_latest.candidate_id} ;;
  }
}
explore: gh_applications_history {
  label: "Greenhouse Applications History"
}
