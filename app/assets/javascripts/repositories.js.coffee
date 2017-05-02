jQuery ->
  $('#repository_vessel').autocomplete
    minLength: 3
    source: $('#repository_vessel').data('autocomplete-source') 