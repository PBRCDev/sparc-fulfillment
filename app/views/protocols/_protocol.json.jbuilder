json.(protocol)

json.sparc_id protocol.sparc_id
json.status protocol.status
json.short_title protocol.short_title
json.irb_approval_date format_date(protocol.irb_approval_date)
json.irb_expiration_date format_date(protocol.irb_expiration_date)
json.udak_project_number protocol.udak_project_number
json.start_date format_date(protocol.start_date)
json.end_date format_date(protocol.end_date)
json.study_cost display_cost(protocol.study_cost)
json.stored_percent_subsidy protocol.stored_percent_subsidy
json.subsidy_committed display_cost(protocol.subsidy_committed)
json.subsidy_expended protocol.subsidy_expended
json.pi protocol.pi.full_name
json.coordinators formatted_coordinators(protocol.coordinators.map(&:full_name))
