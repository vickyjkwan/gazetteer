connection: "snowflake_medium"

include: "aws_cloudfront*[!.][!.z].view.lkml"
include : "docker_www_pages.view.lkml"

# Include just Docker Hub Usage LookML dashboard
include: "docker_hub_usage.dashboard.lookml"

explore: edition_access_logs {
  from: aws_cloudfront_edition_access_logs
}

explore: registry_access_logs {
  from: aws_cloudfront_registry_access_logs
}

explore: store_access_logs {
  from: aws_cloudfront_store_pkg_repo_access_logs
}

explore: get_docker_logs {
  from:  aws_cloudfront_get_docker_logs

  join: docker_www_pages {
    view_label: "Page Views"
    relationship: one_to_one
    sql_on: ${docker_www_pages.context_ip} = ${get_docker_logs.ip_address} ;;
  }

}
