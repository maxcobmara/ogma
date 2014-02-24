jQuery ->
  $('#location_staff_name').autocomplete
    minLength: 3
    source: $('#location_staff_name').data('autocomplete-source')
    
  $('#location_parent_code').autocomplete
    minLength: 2
    source: $('#location_parent_code').data('autocomplete-source')
    
  $("#location_lclass").change ->
    $("#form3").hide()
    $("#form" + $(this).find("option:selected").attr("value")).show()
    return
    
  $("#location_lclass").each ->
    $("#form3").hide()
    $("#form" + $(this).find("option:selected").attr("value")).show()
    return
  
  $("#show_assets_link").click ->
    $("#show_assets").toggle()
    return
  