jQuery ->
  $('#staffsearch2_keywords').autocomplete
    minLength: 3
    source: $('#staffsearch2_keywords').data('autocomplete-source') 
