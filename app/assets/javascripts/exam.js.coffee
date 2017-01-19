jQuery ->
  staffs = $('#subjects').html()
  staffs2 = $('#topics').html()
  $('#course_name').change ->
    unitdepartment = $('#course_name :selected').text()
    escaped_unitdepartment = unitdepartment.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(staffs).filter("optgroup[label=#{escaped_unitdepartment}]").html()
    if options
      $('#subjects').html(options)
      $('#subjects').parent().show()
    else
      $('#subjects').empty
      $('#subjects').parent().hide()

  $('#subjects').change ->
    selectedsubject = $('#subjects :selected').val()
    escaped_subject=selectedsubject.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options2 = $(staffs2).filter("optgroup[label=#{escaped_subject}]").html()
    if options2
      $('#topics').html(options2)
      $('#topics').parent().show()
    else
      $('#topics').empty
      $('#topics').parent().hide() 
      
  $('#topics').change ->
    selectedtopic = $('#topics :selected').val()
    curr_exam=$('#current_exam').val()
    $('.display_link').remove()
    $('#question_list').hide()
    $('#question_title').html("<b><a href='/fetch_items?id="+curr_exam+"&topicid="+selectedtopic+")' data-remote='true' class='display_link btn btn-info'><i class='fa fa-search fa-1x'></a></b>")  
    #$('#question_title').html("<b><a href='/fetch_items?id="+curr_exam+"&topicid="+selectedtopic+")' data-remote='true' class='display_link'><img src='/assets/logo_kerajaan.png'></a></b>")  
    #$('#testing').val(selectedtopic)
    #on change display link ('Display question' for selected topic_id), but retrieve this SELECTED TOPIC ID first
    
  staffs3 = $('#exam_subject_id').html()
  $('#exam_course_id').change ->
    unitdepartment = $('#exam_course_id :selected').val()
    escaped_unitdepartment = unitdepartment.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(staffs3).filter("optgroup[label=#{escaped_unitdepartment}]").html()
    if options
      $('#exam_subject_id').html(options)
      $('#exam_subject_id').parent().show()
    else
      $('#exam_subject_id').empty
      $('#exam_subject_id').parent().hide()

  $('#exam_name').change ->
    papertype=$('#exam_name').val()
    if papertype=="R"
      $('#span_desc').show()
      $('#span_desc2').show()
      $('#span_subject').hide()
      $('#span_subject2').hide()
      $('#span_programme2').hide()
      $('#span_programme').hide()
    else
      $('#span_desc').hide()
      $('#span_desc2').hide()
      $('#span_subject').show()
      $('#span_subject2').show()
      $('#span_programme2').show()
      $('#span_programme').show()
      
  $('#exam_name').each ->
    papertype=$('#exam_name').val()
    
    if papertype=="R"
      $('#span_desc').show()
      $('#span_desc2').show()
      $('#span_subject').hide()
      $('#span_subject2').hide()
      $('#span_programme2').hide()
      $('#span_programme').hide()
    else
      $('#span_desc').hide()
      $('#span_desc2').hide()
      $('#span_subject').show()
      $('#span_subject2').show()
      $('#span_programme2').show()
      $('#span_programme').show()
    
   


   
     