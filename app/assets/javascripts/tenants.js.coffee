jQuery ->
  $('#tenant_student_name').autocomplete
    source: $('#tenant_student_name').data('autocomplete-source')