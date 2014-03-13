jQuery ->
  $('#document_to_name').autocomplete
    minLength: 2
    source: $('#document_to_name').data('autocomplete-source')