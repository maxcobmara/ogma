# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  #start
  $('#curriculumsearch_programme_id').each ->
    $('#curriculumsearch_semester').empty
    $('#curriculumsearch_semester').parent().hide()
    $('.span_checkboxes').hide()
    
 #selection occur
  module = $('#curriculumsearch_semester').html()
  $('#curriculumsearch_programme_id').change ->
    selectedprogramme = $('#curriculumsearch_programme_id :selected').text()
    escaped_selectedprogramme = selectedprogramme.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(module).filter("optgroup[label=#{escaped_selectedprogramme}]").html()
    if options
      $('#curriculumsearch_semester').html(options)
      $('#curriculumsearch_semester').parent().show()
      $('.span_checkboxes').show()
    else
      $('#curriculumsearch_semester').empty
      $('#curriculumsearch_semester').parent().hide()
      $('.span_checkboxes').hide()