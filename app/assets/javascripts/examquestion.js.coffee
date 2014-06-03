#WYSIWUG - textarea - question
bkLib.onDomLoaded ->
  nicEditors.editors.push new nicEditor(fullPanel: true).panelInstance(document.getElementById("myNicEditor"))
  nicEditors.editors.push new nicEditor(fullPanel: true).panelInstance(document.getElementById("examquestion_shortessays_attributes_0_subanswer"))
  nicEditors.editors.push new nicEditor(fullpanel: true).panelInstance(document.getElementById("examquestion_shortessays_attributes_1_subanswer"))
  nicEditors.editors.push new nicEditor(fullpanel: true).panelInstance(document.getElementById("examquestion_shortessays_attributes_2_subanswer"))
  return
	
$(document).ready ->
  #onload, hide topics,although programme selected, subject not yet selected
  #$(".topic_field").hide();  									
  
  #onload, hide DIV questions of all types  
  $('.box').hide();	#use this or 3 below lines
  #$("#MCQ").show();
  #$("#MEQ").hide();
  #$("#SEQ").hide();
  
  #onload, show subject if programme is selected only (logged-in by lecturer)
  if ($('#examquestion_programme_id option:selected').val()=="")
    $(".subject_field").hide();  
  else
    $(".subject_field").show();
 
  #onload, show topic if subject is selected only (logged-in by lecturer)
  if ($('#examquestion_subject_id option:selected').val()=="")
    $(".topic_field").hide();  
  else
    $(".topic_field").show();
    
  #at any time, if programme is selected, show subject field (subject selection field)	
  $('#examquestion_programme_id').on "change", ->
    $(".subject_field").show();
    $.ajax
      url: "update_subjects"
      type: "GET"
      dataType: "script"
      data:
        programme_id: $('#examquestion_programme_id option:selected').val()
		
  #at any time, if subect is selected, show topic field (topic selection field)
  $('#examquestion_subject_id').on "change", ->
    $(".topic_field").show();
    $.ajax
      url: "update_topics"
      type: "GET"
      dataType: "script"
      data:
        subject_id: $('#examquestion_subject_id option:selected').val()
	
  #at any time, display DIV for question according to selected question type 
  $('#examquestion_questiontype').change(->
    $('#examquestion_questiontype option:selected').each ->
      if $(this).val() is ""
        $("#main_question").hide()
        $("#MCQ").hide()
        $("#SEQ").hide()
        $("#MEQ").hide()
        $("#ACQ").hide()
        $("#OSCI").hide()
        $("#OSCII").hide()
        $("#OSCE").hide()
        $("#OSPE").hide()
        $("#VIVA").hide()
        $("#TRUEFALSE").hide()
        $("#others_answer").hide()
        $("#main_question2").hide()
        $("#main_question3").hide()
        $("#others_keyword").hide()
      if $(this).val() is "MCQ"
        $("#main_question").show()
        $("#MCQ").show()
        $("#SEQ").hide()
        $("#MEQ").hide()
        $("#ACQ").hide()
        $("#OSCI").hide()
        $("#OSCII").hide()
        $("#OSCE").hide()
        $("#OSPE").hide()
        $("#VIVA").hide()
        $("#TRUEFALSE").hide()
        $("#others_answer").hide()
        $("#main_question2").show()
        $("#main_question3").hide()
        $("#others_keyword").hide()
      if $(this).attr("value") is "SEQ"
        $("#main_question").show()
        $("#MCQ").hide()
        $("#MEQ").hide()
        $("#SEQ").show()
        $("#ACQ").hide()
        $("#OSCI").hide()
        $("#OSCII").hide()
        $("#OSCE").hide()
        $("#OSPE").hide()
        $("#VIVA").hide()
        $("#TRUEFALSE").hide()
        $("#others_answer").hide()
        $("#main_question2").hide()
        $("#main_question3").show()
        $("#others_keyword").show()
      if $(this).attr("value") is "MEQ"
        $("#main_question").show()
        $("#MCQ").hide()
        $("#SEQ").hide()
        $("#MEQ").show()
        $("#ACQ").hide()
        $("#OSCI").hide()
        $("#OSCII").hide()
        $("#OSCE").hide()
        $("#OSPE").hide()
        $("#VIVA").hide()
        $("#TRUEFALSE").hide()
        $("#others_answer").show()
        $("#main_question2").show()
        $("#main_question3").hide()
        $("#others_keyword").show()
      if $(this).attr("value") is "ACQ"
        $("#main_question").show()
        $("#MCQ").hide()
        $("#SEQ").hide()
        $("#MEQ").hide()
        $("#ACQ").show()
        $("#OSCI").hide()
        $("#OSCII").hide()
        $("#OSCE").hide()
        $("#OSPE").hide()
        $("#VIVA").hide()
        $("#TRUEFALSE").hide()
        $("#others_answer").show()
        $("#main_question2").show()
        $("#main_question3").hide()
        $("#others_keyword").show()
      if $(this).attr("value") is "OSCI"
        $("#main_question").show()
        $("#MCQ").hide()
        $("#SEQ").hide()
        $("#MEQ").hide()
        $("#ACQ").hide()
        $("#OSCI").show()
        $("#OSCII").hide()
        $("#OSCE").hide()
        $("#OSPE").hide()
        $("#VIVA").hide()
        $("#TRUEFALSE").hide()
        $("#others_answer").show()
        $("#main_question2").show()
        $("#main_question3").hide()
        $("#others_keyword").show()
      if $(this).attr("value") is "OSCII"
        $("#main_question").show()
        $("#MCQ").hide()
        $("#SEQ").hide()
        $("#MEQ").hide()
        $("#ACQ").hide()
        $("#OSCI").hide()
        $("#OSCII").show()
        $("#OSCE").hide()
        $("#OSPE").hide()
        $("#VIVA").hide()
        $("#TRUEFALSE").hide()
        $("#others_answer").show()
        $("#main_question2").show()
        $("#main_question3").hide()
        $("#others_keyword").show()
      if $(this).attr("value") is "OSCE"
        $("#main_question").show()
        $("#MCQ").hide()
        $("#SEQ").hide()
        $("#MEQ").hide()
        $("#ACQ").hide()
        $("#OSCI").hide()
        $("#OSCII").hide()
        $("#OSCE").show()
        $("#OSPE").hide()
        $("#VIVA").hide()
        $("#TRUEFALSE").hide()
        $("#others_answer").show()
        $("#main_question2").show()
        $("#main_question3").hide()
        $("#others_keyword").show()
      if $(this).attr("value") is "OSPE"
        $("#main_question").show()
        $("#MCQ").hide()
        $("#SEQ").hide()
        $("#MEQ").hide()
        $("#ACQ").hide()
        $("#OSCI").hide()
        $("#OSCII").hide()
        $("#OSCE").hide()
        $("#OSPE").show()
        $("#VIVA").hide()
        $("#TRUEFALSE").hide()
        $("#others_answer").show()
        $("#main_question2").show()
        $("#main_question3").hide()
        $("#others_keyword").show()
      if $(this).attr("value") is "VIVA"
        $("#main_question").show()
        $("#MCQ").hide()
        $("#SEQ").hide()
        $("#MEQ").hide()
        $("#ACQ").hide()
        $("#OSCI").hide()
        $("#OSCII").hide()
        $("#OSCE").hide()
        $("#OSPE").hide()
        $("#VIVA").show()
        $("#TRUEFALSE").hide()
        $("#others_answer").show()
        $("#main_question2").show()
        $("#main_question3").hide()
        $("#others_keyword").show()
      if $(this).attr("value") is "TRUEFALSE"
        $("#main_question").show()
        $("#MCQ").hide()
        $("#SEQ").hide()
        $("#MEQ").hide()
        $("#ACQ").hide()
        $("#OSCI").hide()
        $("#OSCII").hide()
        $("#OSCE").hide()
        $("#OSPE").hide()
        $("#VIVA").hide()
        $("#TRUEFALSE").show()
        $("#others_answer").show()
        $("#main_question2").show()
        $("#main_question3").hide()
        $("#others_keyword").hide()
      return

    return	  
  ).change()

  $("#check_activate").change ->
    if $(this).prop("checked")
      $(".span_activate").show()
    else
      $(".span_activate").hide()
    return


  