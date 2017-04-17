# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  $('#repositorysearch_title').autocomplete
    minLength: 3
    source: $('#repositorysearch_title').data('autocomplete-source') 

