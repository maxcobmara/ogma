jQuery ->
  $('#repository_vessel').autocomplete
    minLength: 3
    source: $('#repository_vessel').data('autocomplete-source') 
    
  vname = $('#repository_vessel').html()
  $('#repository_vessel_class').change ->
    vclass = $('#repository_vessel_class :selected').text()
    escaped_vclass = vclass.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(vname).filter("optgroup[label=#{escaped_vclass}]").html()
    if options
      $('#repository_vessel').html(options)
      $('#repository_vessel').parent().show()
      $('.ticker_span').show()
    else
      $('#repository_vessel').empty
      $('#repository_vessel').parent().hide()
      $('.ticker_span').hide()
      
   vname = $('#repository_vessel').html()
  $('#repository_vessel_class').each ->
    vclass = $('#repository_vessel_class :selected').text()
    escaped_vclass = vclass.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(vname).filter("optgroup[label=#{escaped_vclass}]").html()
    if options
      $('#repository_vessel').html(options)
      $('#repository_vessel').parent().show()
      $('.ticker_span').show()
    else
      $('#repository_vessel').empty
      $('#repository_vessel').parent().hide()
      $('.ticker_span').hide()
      
  #equipment  
  equipmentname = $('#repository_equipment').html()
  $('#repository_document_subtype').change ->
    docsubtype = $('#repository_document_subtype :selected').text()
    escaped_docsubtype = docsubtype.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(equipmentname).filter("optgroup[label=#{escaped_docsubtype}]").html()
    if options
      $('#repository_equipment').html(options)
      $('#repository_equipment').parent().show()
    else
      $('#repository_equipment').empty
      $('#repository_equipment').parent().hide()
      
  equipmentname = $('#repository_equipment').html()
  $('#repository_document_subtype').each ->
    docsubtype = $('#repository_document_subtype :selected').text()
    escaped_docsubtype = docsubtype.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(equipmentname).filter("optgroup[label=#{escaped_docsubtype}]").html()
    if options
      $('#repository_equipment').html(options)
      $('#repository_equipment').parent().show()
    else
      $('#repository_equipment').empty
      $('#repository_equipment').parent().hide()
     