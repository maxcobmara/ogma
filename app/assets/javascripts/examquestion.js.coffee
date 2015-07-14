#WYSIWUG - textarea - question
#bkLib.onDomLoaded ->
#  nicEditors.editors.push new nicEditor(fullPanel: true).panelInstance(document.getElementById("myNicEditor"))
#  nicEditors.editors.push new nicEditor(fullPanel: true).panelInstance(document.getElementById("examquestion_shortessays_attributes_0_subanswer"))
#  nicEditors.editors.push new nicEditor(fullpanel: true).panelInstance(document.getElementById("examquestion_shortessays_attributes_1_subanswer"))
#  nicEditors.editors.push new nicEditor(fullpanel: true).panelInstance(document.getElementById("examquestion_shortessays_attributes_2_subanswer"))
#  return

# above got error somewhere if enable, but where?



$(document).ready ->
  
  #onload, hide DIV questions of all types  
  $('.box').hide();	#use this or 3 below lines
  #$("#MCQ").show();
  #$("#MEQ").hide();
  #$("#SEQ").hide();
  
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
        $("#main_question2").show()
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

  $("#examquestion_activate").change ->
    if $(this).prop("checked")
      $(".span_activate").show()
    else
      $(".span_activate").hide()
    return

#  PreviewImage = ->
#    oFReader = new FileReader()
#    oFReader.readAsDataURL document.getElementById("examquestion_diagram").files[0]
#    oFReader.onload = (oFREvent) ->
#      document.getElementById("uploadPreview").src = oFREvent.target.result
#    return
#    document.getElementById("examquestion_diagram").addEventListener "change", PreviewImage, false

#prev disable coz - hostel / residence - student / staff selection akan error - Jan-Mac 2015