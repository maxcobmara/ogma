# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  $('#assetsearch_assetcode').autocomplete
    minLength: 3
    source: $('#assetsearch_assetcode').data('autocomplete-source') 
    
  $('#assetsearch_name').autocomplete
    minLength: 3
    source: $('#assetsearch_name').data('autocomplete-source') 