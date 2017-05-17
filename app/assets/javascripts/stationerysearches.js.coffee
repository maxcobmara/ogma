# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


jQuery ->
  $('#stationerysearch_product').autocomplete
    minLength: 3
    source: $('#stationerysearch_product').data('autocomplete-source') 
    
  $('#stationerysearch_document').autocomplete
    minLength: 2
    source: $('#stationerysearch_document').data('autocomplete-source') 
