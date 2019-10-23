connection: "data_warehouse"

include: "store/storedb*.view.lkml"

explore: edition {
  from: storedb_edition
}

explore: edition_addon {
  from: storedb_edition_addon
}

explore: edition_plan {
  from: storedb_edition_plan
}

explore: edition_plan_addon {
  from: storedb_edition_plan_addon
}

explore: email_notification {
  from: storedb_email_notification
}

explore: plan {
  from: storedb_plan
  join: storedb_rate_plan_draft {
    type: inner
    sql_on: ${plan.uuid} = ${storedb_rate_plan_draft.rate_plan_id} ;;
    relationship: one_to_one
  }
}

explore: product {
  from: storedb_product

  join: storedb_publisher {
    type: left_outer
    sql_on: ${product.publisher_id} = ${storedb_publisher.id} ;;
    relationship: many_to_one
  }

  join: storedb_plan{
    type: left_outer
    sql_on: ${product.id} = ${storedb_plan.product_id};;
    relationship: one_to_many
  }

  join: storedb_product_draft {
    type: left_outer
    sql_on: ${product.id} = ${storedb_product_draft.id} ;;
    relationship: one_to_one
  }

}

explore: product_draft {
  from: storedb_product_draft

  join: storedb_publisher {
    type: left_outer
    sql_on: ${product_draft.publisher_id} = ${storedb_publisher.id} ;;
    relationship: many_to_one
  }

  join: storedb_product {
    type: left_outer
    sql_on: ${product_draft.id} = ${storedb_product.id} ;;
    relationship: one_to_one
  }

}

explore: publisher {
  from: storedb_publisher

  join: storedb_product {
    type:  left_outer
    sql_on: ${publisher.id} = ${storedb_product.publisher_id};;
    relationship: one_to_many
  }
}

explore: new_products {
  from: storedb_publisher_product_repo_info
  sql_always_where: ${storedb_product.uuid} is null ;;

  join: storedb_product_draft {
    type: inner
    sql_on: ${new_products.product_id} = ${storedb_product_draft.uuid} ;;
    relationship: many_to_one
  }

  join: storedb_product {
    type: left_outer
    sql_on: ${new_products.product_id} = ${storedb_product.uuid} ;;
    relationship: many_to_one
  }

  join: storedb_publisher {
    type: left_outer
    sql_on: ${storedb_product_draft.publisher_id} = ${storedb_publisher.id} ;;
    relationship: many_to_one
  }
}

explore: updated_products {
  from: storedb_publisher_product_repo_info
  sql_always_where: ${storedb_product.uuid} is not null ;;

  join: storedb_product_draft {
    type: inner
    sql_on: ${updated_products.product_id} = ${storedb_product_draft.uuid} ;;
    relationship: many_to_one
  }

  join: storedb_product {
    type: left_outer
    sql_on: ${updated_products.product_id} = ${storedb_product.uuid} ;;
    relationship: many_to_one
  }

  join: storedb_publisher {
    type: left_outer
    sql_on: ${storedb_product_draft.publisher_id} = ${storedb_publisher.id} ;;
    relationship: many_to_one
  }
}

explore: published_no_updates {
  from: storedb_product
  sql_always_where: ${storedb_product_draft.uuid} is null ;;

  join: storedb_publisher {
    type: inner
    sql_on: ${published_no_updates.publisher_id} = ${storedb_publisher.id} ;;
    relationship: many_to_one
  }

  join: storedb_product_draft {
    type: left_outer
    sql_on: ${published_no_updates.uuid} = ${storedb_product_draft.uuid} ;;
    relationship: one_to_one
  }
}


explore: publisher_product_repo_info {
  from: storedb_publisher_product_repo_info
}

explore: publisher_signup {
  from: storedb_publisher_signup
}

explore: rate_plan_draft {
  from: storedb_rate_plan_draft
}

explore: repository {
  from: storedb_repository
}

explore: review {
  from: storedb_review
}

explore: review_stats {
  from: storedb_review_stats
}

explore: reviewers {
  from: storedb_reviewers
}

explore: store_administrator {
  from: storedb_store_administrator
}

explore: publisher_signup_funnel {
  from: storedb_publisher_signup_funnel
}
