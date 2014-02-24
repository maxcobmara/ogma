jQuery ->
  $('#tenant_student_name').autocomplete
    minLength: 3
    source: $('#tenant_student_name').data('autocomplete-source')