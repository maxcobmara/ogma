# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  $('#examresultsearch_intake_programme').autocomplete
    minLength: 3
    source: $('#examresultsearch_intake_programme').data('autocomplete-source') 
    