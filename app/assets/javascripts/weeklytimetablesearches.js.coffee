# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


jQuery ->
  $('#weeklytimetablesearch_intake_programme').autocomplete
    minLength: 3
    source: $('#weeklytimetablesearch_intake_programme').data('autocomplete-source') 
    
  #start
  $('#weeklytimetablesearch_intake_programme').each ->
    $('#weeklytimetablesearch_preparedby').empty
    $('#weeklytimetablesearch_preparedby').parent().hide()
    
 #selection occur
  preparer = $('#weeklytimetablesearch_preparedby').html()
  $('#weeklytimetablesearch_intake_programme').change ->
    intakeprogramme = $('#weeklytimetablesearch_intake_programme').val()
    escaped_intakeprogramme = intakeprogramme.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(preparer).filter("optgroup[label=#{escaped_intakeprogramme}]").html()
    if options
      $('#weeklytimetablesearch_preparedby').html(options)
      $('#weeklytimetablesearch_preparedby').parent().show()
    else
      $('#weeklytimetablesearch_preparedby').empty
      $('#weeklytimetablesearch_preparedby').parent().hide()
    
