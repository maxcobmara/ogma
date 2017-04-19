# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  $('#repositorysearch_title').autocomplete
    minLength: 3
    source: $('#repositorysearch_title').data('autocomplete-source') 
    
  $('#repositorysearch_refno').autocomplete
    minLength: 3
    source: $('#repositorysearch_refno').data('autocomplete-source') 
    
  #start
  $('#repositorysearch_vessel').each ->
    $('#repositorysearch_document_type').empty
    $('#repositorysearch_document_type').parent().hide()
    $('#repositorysearch_document_subtype').empty
    $('#repositorysearch_document_subtype').parent().hide()

  #selection occur
  doctypes = $('#repositorysearch_document_type').html()
  $('#repositorysearch_vessel').change ->
    vesselname = $('#repositorysearch_vessel :selected').text()
    escaped_vesselname = vesselname.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(doctypes).filter("optgroup[label=#{escaped_vesselname}]").html()
    if options
      $('#repositorysearch_document_type').html(options)
      $('#repositorysearch_document_type').parent().show()
    else
      $('#repositorysearch_document_type').empty
      $('#repositorysearch_document_type').parent().hide()
   
  docsubtypes = $('#repositorysearch_document_subtype').html()
  $('#repositorysearch_document_type').change ->
    vesselname = $('#repositorysearch_vessel').val()
    documenttype = $('#repositorysearch_document_type :selected').text()
    escaped_documenttype = documenttype.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    combine=vesselname+": "+escaped_documenttype
    #alert(combine)
    options = $(docsubtypes).filter("optgroup[label='#{combine}']").html()
    if options
      $('#repositorysearch_document_subtype').html(options)
      $('#repositorysearch_document_subtype').parent().show()
    else
      $('#repositorysearch_document_subtype').empty
      $('#repositorysearch_document_subtype').parent().hide()
