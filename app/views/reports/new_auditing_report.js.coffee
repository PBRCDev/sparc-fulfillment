$("#modal_area").html("<%= escape_javascript(render(:partial =>'new_auditing_report_modal')) %>")
$("#modal_place").modal('show')
$('#start_date').datetimepicker(format: 'MM-DD-YYYY')
$('#end_date').datetimepicker(format: 'MM-DD-YYYY')
$("#protocol_ids").selectpicker()
$("#organization_ids").selectpicker()
