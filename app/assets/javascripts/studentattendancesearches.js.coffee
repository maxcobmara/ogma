# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  $('#studentattendancesearch_student_id').autocomplete
    minLength: 3
    source: $('#studentattendancesearch_student_id').data('autocomplete-source') 

  #start
  $('#studentattendancesearch_course_id').each ->
    $('#studentattendancesearch_intake_id').empty
    $('#studentattendancesearch_intake_id').parent().hide()
    $('#studentattendancesearch_schedule_id').empty
    $('#studentattendancesearch_schedule_id').parent().hide()
    $('.intake_span').hide()
    $('.schedule_span').hide()
    
  #selection occur
  intake = $('#studentattendancesearch_intake_id').html()
  $('#studentattendancesearch_course_id').change ->
    programme = $('#studentattendancesearch_course_id :selected').text()
    escaped_programme = programme.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(intake).filter("optgroup[label=#{escaped_programme}]").html()
    if options
      $('#studentattendancesearch_intake_id').html(options)
      $('#studentattendancesearch_intake_id').parent().show('slide')
      $('.intake_span').show('slide')
    else
      $('#studentattendancesearch_intake_id').empty
      $('#studentattendancesearch_intake_id').parent().hide('slide')
      $('.intake_span').hide('slide')
      
  schedule = $('#studentattendancesearch_schedule_id').html()
  $('#studentattendancesearch_intake_id').change ->
    intake = $('#studentattendancesearch_intake_id :selected').text()
    escaped_intake = intake.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(schedule).filter("optgroup[label=#{escaped_intake}]").html()
    if options
      $('#studentattendancesearch_schedule_id').html(options)
      $('#studentattendancesearch_schedule_id').parent().show('slide')
      $('.schedule_span').show('slide')
    else
      $('#studentattendancesearch_schedule_id').empty
      $('#studentattendancesearch_schedule_id').parent().hide('slide')
      $('.schedule_span').hide('slide')
