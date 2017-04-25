# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  $('#documentsearch_refno').autocomplete
    minLength: 3
    source: $('#documentsearch_refno').data('autocomplete-source') 
    
  $('#documentsearch_title').autocomplete
    minLength: 3
    source: $('#documentsearch_title').data('autocomplete-source') 
