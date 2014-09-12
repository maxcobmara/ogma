$(document).ready ->
  #onload, hide topics,although programme selected, subject not yet selected
  $(".topic_field2").hide();

  
  #onload, hide DIV questions of all types  
  $('.box').hide();	#use this or 3 below lines
  #$("#MCQ").show();
  #$("#MEQ").hide();
  #$("#SEQ").hide();
  
  #onload, show subject if programme is selected only (logged-in by lecturer)
  #if ($('#topicdetail_programme_id option:selected').val()=="")
  if ($('.prog option:selected').val()=="")
    $(".subject_field").hide();
  else
    $(".subject_field").show();
 
  #onload, show topic if subject is selected only (logged-in by lecturer)
  if ($('#topicdetail_subject_id option:selected').val()=="")
    $(".topic_field").hide();
  else
    $(".topic_field").show();
    
  #at any time, if programme is selected, show subject field (subject selection field)	
  #$('#topicdetail_programme_id').on "change", ->
  $('.prog').on "change", ->
    $(".subject_field").show();
    $.ajax
      url: "update_subjects2"
      type: "GET"
      dataType: "script"
      data:
        programme_id: $('.prog option:selected').val()
        #programme_id: $('#topicdetail_programme_id option:selected').val()

  #at any time, if subect is selected, show topic field (topic selection field)
  $('#topicdetail_subject_id').on "change", ->
    $(".topic_field").show();
    $.ajax
      url: "update_topics"
      type: "GET"
      dataType: "script"
      data:
        subject_id: $('#topicdetail_subject_id option:selected').val()
