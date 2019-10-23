connection: "data_warehouse"

include: "docker_for_*[!.][!z].view.lkml"

label: "Docker for Servers/IaaS"

explore: docker_for_servers_iaas_dev {
  from: docker_for_servers_iaas_identifies_dev
  label: "Docker for Servers/IaaS [DEV]"
}

explore: docker_for_servers_iaas_prod {
  from: docker_for_servers_iaas_identifies_prod
  label: "Docker for Servers/IaaS [PROD]"

  join: events {
    from: docker_for_servers_iaas_tracks_prod
    sql_on: events.user_id = docker_for_servers_iaas_prod.user_id ;;
    relationship: many_to_one
  }
}
