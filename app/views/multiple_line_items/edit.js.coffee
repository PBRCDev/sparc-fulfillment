$("#line_item_form").html("<%= escape_javascript(render(:partial =>'protocols/study_schedule/line_item_form', locals: {header_text: 'Remove Services', button_text: 'Remove', services: @services, protocol: @protocol, selected_service: @selected_service})) %>");