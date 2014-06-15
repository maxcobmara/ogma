$(document).ready ->
  
  #show submit date
  $("#option_fixed").click ->
    $("#fixed_selector").show()
    $("#inventory_selector").hide()
    return

  $("#option_inventory").click ->
    $("#fixed_selector").hide()
    $("#inventory_selector").show()
    return

  $("#closeme").click ->
    $("#new-post-modal").modal "hide"
    return

  return