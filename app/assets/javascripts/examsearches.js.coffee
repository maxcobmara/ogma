# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  
  #start
  $('#examsearch_programme_details').each ->
    $('#examsearch_subject_id').empty
    $('#examsearch_subject_id').parent().hide()
    $('#examsearch_created_by').empty
    $('#examsearch_created_by').parent().hide()
    $('#examsearch_examtype').empty
    $('#examsearch_examtype').parent().hide()
    $('#examsearch_klass_id').empty
    $('#examsearch_klass_id').parent().hide()
    
 #selection occur
  selsubject = $('#examsearch_subject_id').html()
  $('#examsearch_programme_details').change ->
    aprogramme = $('#examsearch_programme_details').val()
    escaped_aprogramme = aprogramme.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(selsubject).filter("optgroup[label=#{escaped_aprogramme}]").html()
    if options
      $('#examsearch_subject_id').html(options)
      $('#examsearch_subject_id').parent().show()
    else
      $('#examsearch_subject_id').empty
      $('#examsearch_subject_id').parent().hide()
      
 #selection occur
  creator = $('#examsearch_created_by').html()
  $('#examsearch_subject_id').change ->
    asubject = $('#examsearch_subject_id').val()
    escaped_asubject = asubject.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(creator).filter("optgroup[label=#{escaped_asubject}]").html()
    if options
      $('#examsearch_created_by').html(options)
      $('#examsearch_created_by').parent().show()
    else
      $('#examsearch_created_by').empty
      $('#examsearch_created_by').parent().hide()
      
 #selection occur
  examtype = $('#examsearch_examtype').html()
  $('#examsearch_created_by').change ->
    acreator = $('#examsearch_created_by').val()
    escaped_acreator = acreator.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(examtype).filter("optgroup[label=#{escaped_acreator}]").html()
    if options
      $('#examsearch_examtype').html(options)
      $('#examsearch_examtype').parent().show()
    else
      $('#examsearch_examtype').empty
      $('#examsearch_examtype').parent().hide()

 #selection occur
  papertype = $('#examsearch_klass_id').html()
  $('#examsearch_examtype').change ->
    aexamtype = $('#examsearch_examtype').val()
    escaped_aexamtype = aexamtype.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(papertype).filter("optgroup[label=#{escaped_aexamtype}]").html()
    if options
      $('#examsearch_klass_id').html(options)
      $('#examsearch_klass_id').parent().show()
    else
      $('#examsearch_klass_id').empty
      $('#examsearch_klass_id').parent().hide()
      