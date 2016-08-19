$(document).ready ->
  
  #show submit date
  $("#option_student").click ->
    $(".student_search").show()
    $(".staff_search").hide()
    return

  $("#option_staff").click ->
    $(".student_search").hide()
    $(".staff_search").show()
    return

  $("#closeme").click ->
    $("#new-post-modal").modal "hide"
    return
  
  #librarytransactions/book_list
  $('.edit_loan input[type=submit]').remove()
  $('.edit_loan input[type=checkbox]').click ->
    ###alert("Nak return!"); ###
    $(this).parent('form').submit()
    return
  
  $('.extend_loan input[type=submit]').remove()
  $('.extend_loan input[type=checkbox]').click ->
    ###alert("Nak extend!"); ###
    $(this).parent('form').submit()
    return

  return