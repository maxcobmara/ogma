jQuery ->
  $('#tenant_student_icno').autocomplete
    minLength: 2
    source: $('#tenant_student_icno').data('autocomplete-source')
    
  $('#tenant_staff_icno').autocomplete
    minLength: 2
    source: $('#tenant_staff_icno').data('autocomplete-source')