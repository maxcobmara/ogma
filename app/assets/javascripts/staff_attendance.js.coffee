jQuery ->
  staffs = $('#staff').html()
  $('#unit_department').change ->
    unitdepartment = $('#unit_department :selected').text()
    escaped_unitdepartment = unitdepartment.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(staffs).filter("optgroup[label=#{escaped_unitdepartment}]").html()
    if options
      $('#staff').html(options)
      $('#staff').parent().show()
    else
      $('#staff').empty
      $('#staff').parent().hide()