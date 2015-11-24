jQuery ->
  subjects = $('#grade_subject_id').html()
  students = $('#grade_student_id').html()
  $('#grade_programme_id').change ->
    unitdepartment = $('#grade_programme_id :selected').text()
    escaped_unitdepartment = unitdepartment.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(subjects).filter("optgroup[label=#{escaped_unitdepartment}]").html()
    options2 = $(students).filter("optgroup[label=#{escaped_unitdepartment}]").html()
    if options
      $('#grade_subject_id').html(options)
      $('#grade_subject_id').parent().show()
      $('#grade_student_id').html(options2)
      $('#grade_student_id').parent().show()
    else
      $('#grade_subject_id').empty
      $('#grade_subject_id').parent().hide()
      $('#grade_student_id').empty
      $('#grade_student_id').parent().hide()

