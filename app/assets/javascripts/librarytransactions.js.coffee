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

  return