jQuery ->
  $('#ptdosearch_staff_name').autocomplete
    minLength: 3
    source: $('#ptdosearch_staff_name').data('autocomplete-source') 
