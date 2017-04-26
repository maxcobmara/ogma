# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  $('#studentsearch_icno').autocomplete
    minLength: 3
    source: $('#studentsearch_icno').data('autocomplete-source') 
    
  $('#studentsearch_name').autocomplete
    minLength: 3
    source: $('#studentsearch_name').data('autocomplete-source') 
    
  $('#studentsearch_matrixno').autocomplete
    minLength: 3
    source: $('#studentsearch_matrixno').data('autocomplete-source') 

  #start
  $('#studentsearch_course_id').each ->
    $('#studentsearch_intake').empty
    $('#studentsearch_intake').parent().hide()
    $('.intake_label').hide()
    
  #selection occur
  intake = $('#studentsearch_intake').html()
  $('#studentsearch_course_id').change ->
    programme = $('#studentsearch_course_id :selected').text()
    escaped_programme = programme.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(intake).filter("optgroup[label=#{escaped_programme}]").html()
    if options
      $('#studentsearch_intake').html(options)
      $('#studentsearch_intake').parent().show('slide')
      $('.intake_label').show('slide')
    else
      $('#studentsearch_intake').empty
      $('#studentsearch_intake').parent().hide('slide')
      $('.intake_label').hide('slide')