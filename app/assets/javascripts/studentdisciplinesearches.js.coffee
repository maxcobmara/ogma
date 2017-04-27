# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  $('#studentdisciplinesearch_name').autocomplete
    minLength: 3
    source: $('#studentdisciplinesearch_name').data('autocomplete-source') 
  
  $('#studentdisciplinesearch_icno').autocomplete
    minLength: 3
    source: $('#studentdisciplinesearch_icno').data('autocomplete-source') 
    
  $('#studentdisciplinesearch_matrixno').autocomplete
    minLength: 3
    source: $('#studentdisciplinesearch_matrixno').data('autocomplete-source') 

  #start
  $('#studentdisciplinesearch_programme').each ->
    $('#studentdisciplinesearch_intake').empty
    $('#studentdisciplinesearch_intake').parent().hide()
    $('.intake_span').hide()
    
  #selection occur
  intake = $('#studentdisciplinesearch_intake').html()
  $('#studentdisciplinesearch_programme').change ->
    programme = $('#studentdisciplinesearch_programme :selected').text()
    escaped_programme = programme.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(intake).filter("optgroup[label=#{escaped_programme}]").html()
    if options
      $('#studentdisciplinesearch_intake').html(options)
      $('#studentdisciplinesearch_intake').parent().show('slide')
      $('.intake_span').show('slide')
    else
      $('#studentdisciplinesearch_intake').empty
      $('#studentdisciplinesearch_intake').parent().hide('slide')
      $('.intake_span').hide('slide')
      