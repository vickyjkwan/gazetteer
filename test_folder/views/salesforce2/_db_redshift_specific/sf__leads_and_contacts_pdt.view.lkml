view: sf__leads_and_contacts_pdt {
  derived_table: {
    distribution_style: all
    datagroup_trigger: sfdc_lead_and_contact_data
    sql:
      WITH leads as (
      SELECT
        'LEAD' as object_type,
        True as is_lead,
        False as is_contact,
        CASE
          WHEN l.converted_contact_id IS NOT NULL THEN True
          ELSE False
        END as is_lead_converted,
        l.id as lead_or_contact_id,
        l.id as lead_id,
        l.created_date,
        l.lead_source,
        l.lead_lifecycle_stage_c as lifecycle_stage,
        l.engagio_matched_account_c as account_id,
        l.became_mel_date_c,
        l.became_mqldate_c,
        l.became_sal_date_c,
        l.became_sql_date_c,
        l.became_mqldate_c as lead_contact_became_mqldate,
        l.became_sal_date_c as lead_contact_became_sal_date,
        l.became_sql_date_c as lead_contact_became_sql_date,
        l.became_mel_date_c as lead_contact_became_mel_date,
        l.created_date as lead_contact_created_date,  -- If the contact was converted, need to know the created date of the lead
        l.converted_opportunity_id as converted_opportunity_id,
        l.converted_contact_id as converted_contact_id,
        l.geo_c,
        l.region_c,
        l.sub_region_c
      FROM
        salesforce.leads as l
      WHERE
        NOT l.is_deleted
      ),
      contacts as (
      SELECT
        'CONTACT' as object_type,
        False as is_lead,
        True as is_contact,
        CASE
          WHEN l.converted_contact_id IS NOT NULL THEN True
          ELSE False
        END as is_lead_converted,
        c.id as lead_or_contact_id,
        l.id as lead_id,  -- Original (converted) lead id in the case of a contact.
        c.created_date,
        c.lead_source,
        c.lifecycle_stage_c as lifecycle_stage,
        c.account_id,
        c.became_mel_date_c,
        c.became_mqldate_c,
        c.became_sal_date_c,
        c.became_sql_date_c,
        COALESCE(l.became_mqldate_c, c.became_mqldate_c) as lead_contact_became_mqldate,
        COALESCE(l.became_sal_date_c, c.became_sal_date_c) as lead_contact_became_sal_date,
        COALESCE(l.became_sql_date_c, c.became_sql_date_c) as lead_contact_became_sql_date,
        COALESCE(l.created_date, c.created_date) as lead_contact_created_date,  -- If the contact was converted, need to know the created date of the lead
        COALESCE(l.became_mel_date_c, c.became_mel_date_c) as lead_contact_became_mel_date,
        l.converted_opportunity_id as converted_opportunity_id,
        l.converted_contact_id as converted_contact_id,
        c.geo_c,
        c.region_c,
        c.sub_region_c
      FROM
        salesforce.contacts c
        LEFT JOIN
        salesforce.leads as l ON (l.converted_contact_id = c.id)
      WHERE
        NOT c.is_deleted
      )
      SELECT l.* FROM leads l
      UNION ALL
      SELECT c.* FROM contacts c
      ;;
  }
}
