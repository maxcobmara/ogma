# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  
  #start
  $('#evaluatecoursesearch_programme_details').each ->
    $('#evaluatecoursesearch_visitor_id').empty
    $('#evaluatecoursesearch_visitor_id').parent().hide()
    $('#evaluatecoursesearch_lecturer_id').empty
    $('#evaluatecoursesearch_lecturer_id').parent().hide()
    $('#evaluatecoursesearch_subject_id').empty
    $('#evaluatecoursesearch_subject_id').parent().hide()
    $('#span_visitor').hide()
    $('#span_staff').hide()
    $('#span_subject').hide()

  
  college=$('#evaluatecoursesearch_college_id').val()
  
  #selection occur
  avisitor = $('#evaluatecoursesearch_visitor_id').html()
  astaff = $('#evaluatecoursesearch_lecturer_id').html()

  $('#evaluatecoursesearch_programme_details').change ->
    aprogramme = $('#evaluatecoursesearch_programme_details').val()
    escaped_aprogramme = aprogramme.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')

    if aprogramme==""
      $('#evaluatecoursesearch_visitor_id').empty
      $('#evaluatecoursesearch_lecturer_id').empty
      $('#evaluatecoursesearch_subject_id').empty
      $('#span_visitor').hide()
      $('#span_staff').hide()
      $('#span_subject').hide()
    else    
      if college=='2'
        alert('amsas')
        #isstaff=$('#evaluatecoursesearch_is_staff').val()
        #if isstaff == 'true'
        options = $(avisitor).filter("optgroup[label=#{escaped_aprogramme}]").html()
        if options
          $('#evaluatecoursesearch_visitor_id').html(options)
          $('#evaluatecoursesearch_visitor_id').parent().show()
          $('#span_visitor').show()
        else
          $('#evaluatecoursesearch_visitor_id').empty
          $('#evaluatecoursesearch_visitor_id').parent().hide()
          $('#span_visitor').hide()
    
      if college=='1'
        alert('kskbjb')
        if $('#is_astaff').is(':checked') 
          options = $(astaff).filter("optgroup[label=#{escaped_aprogramme}]").html()
          if options
            $('#evaluatecoursesearch_lecturer_id').html(options)
            $('#evaluatecoursesearch_lecturer_id').parent().show()
            $('#span_staff').show()
            $('#evaluatecoursesearch_visitor_id').empty
            $('#evaluatecoursesearch_visitor_id').parent().hide()
            $('#span_visitor').hide()
          else
            $('#evaluatecoursesearch_lecturer_id').empty
            $('#evaluatecoursesearch_lecturer_id').parent().hide()
            $('#span_staff').hide()
        else
          options = $(avisitor).filter("optgroup[label=#{escaped_aprogramme}]").html()
          if options
            $('#evaluatecoursesearch_visitor_id').html(options)
            $('#evaluatecoursesearch_visitor_id').parent().show()
            $('#span_visitor').show()
            $('#evaluatecoursesearch_lecturer_id').empty
            $('#evaluatecoursesearch_lecturer_id').parent().hide()
            $('#span_staff').hide()
            $('#evaluatecoursesearch_subject_id').empty
            $('#evaluatecoursesearch_subject_id').parent().hide()
            $('#span_subject').hide()
          else
            $('#evaluatecoursesearch_visitor_id').empty
            $('#evaluatecoursesearch_visitor_id').parent().hide()
            $('#span_visitor').hide()
 

  #selection occur
  asubject = $('#evaluatecoursesearch_subject_id').html()
  $('#evaluatecoursesearch_lecturer_id').change ->
    alecturer = $('#evaluatecoursesearch_lecturer_id').val()
    escaped_alecturer = alecturer.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    
    options = $(asubject).filter("optgroup[label=#{escaped_alecturer}]").html()
    if options
      $('#evaluatecoursesearch_subject_id').html(options)
      $('#evaluatecoursesearch_subject_id').parent().show()
      $('#span_subject').show()
    else
      $('#evaluatecoursesearch_subject_id').empty
      $('#evaluatecoursesearch_subject_id').parent().hide()
      $('#span_subject').hide()
      
      
