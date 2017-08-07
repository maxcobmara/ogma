# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  
  #start
  $('#examanalysissearch_programme_details').each ->
    $('#examanalysissearch_subject_id').empty
    $('#examanalysissearch_subject_id').parent().hide()
    
 #selection occur
  selsubject = $('#examanalysissearch_subject_id').html()
  $('#examanalysissearch_programme_details').change ->
    aprogramme = $('#examanalysissearch_programme_details').val()
    escaped_aprogramme = aprogramme.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(selsubject).filter("optgroup[label=#{escaped_aprogramme}]").html()
    if options
      $('#examanalysissearch_subject_id').html(options)
      $('#examanalysissearch_subject_id').parent().show()
    else
      $('#examanalysissearch_subject_id').empty
      $('#examanalysissearch_subject_id').parent().hide()