jQuery ->
  topics = $('#topic_listing').html()
  $('#subject_listing').change ->
    subject = $('#subject_listing :selected').text()
    escaped_subject = subject.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(topics).filter("optgroup[label=#{escaped_subject}]").html()
    if options
      $('#topic_listing').html(options)
      $('#topic_listing').parent().show()
    else
      $('#topic_listing').empty
      $('#topic_listing').parent().hide()

  subjects = $('#subject_listing').html()
  $('#programme_listing').change ->
    programme = $('#programme_listing :selected').text()
    escaped_programme = programme.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(subjects).filter("optgroup[label=#{escaped_programme}]").html()
    if options
      $('#subject_listing').html(options)
      $('#subject_listing').parent().show()
    else
      $('#subject_listing').empty
      $('#subject_listing').parent().hide()
      
  subjects_field = $('#examquestion_subject_id').html()
  $('#examquestion_programme_id').change ->
    programme2 = $('#examquestion_programme_id :selected').text()
    escaped_programme2 = programme2.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(subjects_field).filter("optgroup[label=#{escaped_programme2}]").html()
    if options
      $('#examquestion_subject_id').html(options)
      $('#examquestion_subject_id').parent().show()
    else
      $('#examquestion_subject_id').empty
      $('#examquestion_subject_id').parent().hide()
         
  topics_field = $('#examquestion_topic_id').html()
  $('#examquestion_subject_id').change ->
    subject2 = $('#examquestion_subject_id :selected').text()
    escaped_subject2 = subject2.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(topics_field).filter("optgroup[label=#{escaped_subject2}]").html()
    if options
      $('#examquestion_topic_id').html(options)
      $('#examquestion_topic_id').parent().show()
    else
      $('#examquestion_topic_id').empty
      $('#examquestion_topic_id').parent().hide()     
      
  #for use in Examquestion - 14July2015 (2 first sample, the other 2 - New/Edit)
