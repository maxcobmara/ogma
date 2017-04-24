jQuery ->

  #start
  $('#staffattendancesearch_department').each ->
    $('#staffattendancesearch_thumb_id').empty
    $('#staffattendancesearch_thumb_id').parent().hide()
    $('#staffattendancesearch_logged_at').parent().hide()
    
  #selection occur
  thumbid = $('#staffattendancesearch_thumb_id').html()
  $('#staffattendancesearch_department').change ->
    departmentname = $('#staffattendancesearch_department :selected').text()
    escaped_departmentname = departmentname.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(thumbid).filter("optgroup[label=#{escaped_departmentname}]").html()
    if options
      $('#staffattendancesearch_thumb_id').html(options)
      $('#staffattendancesearch_thumb_id').parent().show()
      if ($('#staffattendancesearch_thumb_id').children().length > 1)
        $('#staffattendancesearch_logged_at').parent().show()
      else
        $('#staffattendancesearch_logged_at').parent().hide()
    else
      $('#staffattendancesearch_thumb_id').empty
      $('#staffattendancesearch_thumb_id').parent().hide()
