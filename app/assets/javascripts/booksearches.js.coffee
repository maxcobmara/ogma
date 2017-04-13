jQuery ->
  $('#booksearch_title').autocomplete
    minLength: 3
    source: $('#booksearch_title').data('autocomplete-source') 

  $('#booksearch_author').autocomplete
    minLength: 3
    source: $('#booksearch_author').data('autocomplete-source') 

  $('#booksearch_isbn').autocomplete
    minLength: 3
    source: $('#booksearch_isbn').data('autocomplete-source') 
    
  $('#booksearch_accessionno').autocomplete
    minLength: 3
    source: $('#booksearch_accessionno').data('autocomplete-source') 
    
  $('#booksearch_publisher').autocomplete
    minLength: 3
    source: $('#booksearch_publisher').data('autocomplete-source') 
