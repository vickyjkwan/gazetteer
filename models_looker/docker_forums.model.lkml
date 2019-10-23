connection: "snowflake_production"

include: "docker_forums_*.view.lkml"

explore: docker_forums_pages {
  description: "Segment Page Calls (see segment.com/docs/spec/page/)"
  label: "Page Views"
  view_label: "Page View"
}


test: test_there_exist_page_views {
  explore_source: docker_forums_pages {
    column: count {}
  }
  assert: page_views_exists {
    expression: ${docker_forums_pages.count} > 0 ;;
  }
}
