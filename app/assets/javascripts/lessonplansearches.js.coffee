# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  $('#lessonplansearch_intake_programme').autocomplete
    minLength: 3
    source: $('#lessonplansearch_intake_programme').data('autocomplete-source') 
    
  #start
  $('#lessonplansearch_intake_programme').each ->
    $('#lessonplansearch_lecturer').empty
    $('#lessonplansearch_lecturer').parent().hide()
    $('#lessonplansearch_subject').empty
    $('#lessonplansearch_subject').parent().hide()
    
 #selection occur
  preparer = $('#lessonplansearch_lecturer').html()
  $('#lessonplansearch_intake_programme').change ->
    intakeprogramme = $('#lessonplansearch_intake_programme').val()
    escaped_intakeprogramme = intakeprogramme.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(preparer).filter("optgroup[label=#{escaped_intakeprogramme}]").html()
    if options
      $('#lessonplansearch_lecturer').html(options)
      $('#lessonplansearch_lecturer').parent().show()
    else
      $('#lessonplansearch_lecturer').empty
      $('#lessonplansearch_lecturer').parent().hide()
      
  #selection occur
  subjects = $('#lessonplansearch_subject').html()
  $('#lessonplansearch_lecturer').change ->
    lecturer = $('#lessonplansearch_lecturer').val()
    escaped_lecturer = lecturer.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(subjects).filter("optgroup[label=#{escaped_lecturer}]").html()
    if options
      $('#lessonplansearch_subject').html(options)
      $('#lessonplansearch_subject').parent().show()
    else
      $('#lessonplansearch_subject').empty
      $('#lessonplansearch_subject').parent().hide()
