$("#modal_area").html("<%= escape_javascript(render(partial: 'incomplete_all_modal', locals: { procedure_ids: @procedure_ids, note: @note})) %>")
$("#modal_place").modal 'show'

$(".selectpicker").selectpicker()
$(".modal_incompleted_date_field").datetimepicker(format: 'MM-DD-YYYY')



# $(document).on 'click', "#incomplete_all_modal button.save", ->
#   $(this).addClass("disabled")

  # if $('.modal_incompleted_date_field  .datetimepicker').val() == '' || $('#incomplete_all_modal .performed-by-dropdown').val() == '' || $('#incomplete_all_modal .reason-select').val() == ''
  #   $('#modal_errors').addClass('alert').addClass('alert-danger').html('Please complete required fields')
  # else
  #   $(this).addClass("disabled")
  #   $.ajax
  #     type: 'PUT'
  #     url:  "/multiple_procedures/update_procedures.js"
