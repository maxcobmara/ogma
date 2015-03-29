jQuery ->
  $('form').on 'click', '.remove_fields', (event) ->
    $(this).closest('input[type=hidden]').val('1')
    $(this).closest('fieldset').hide()
    event.preventDefault()

  $('form').on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).before($(this).data('fields').replace(regexp, time))
    event.preventDefault()

  $(".load_search_bar").click ->
    $(".search_bar").toggle()
    return

  $ ->
  $("#q_reset").click ->
    $(".search-field").val('')

    
      
  $ ()->
    $("form.new_post").on "ajax:success", (event, data, status, xhr) ->
      $('#new-post-modal').modal('hide')
      
  $('#search_staff_name').autocomplete
    minLength: 3
    source: $('#search_staff_name').data('autocomplete-source')
    
  $('#search_student_icno_location').autocomplete
    minLength: 3
    source: $('#search_student_icno_location').data('autocomplete-source')
    
  $('#search_staff_icno_location').autocomplete
    minLength: 3
    source: $('#search_staff_icno_location').data('autocomplete-source')
    
$('#librarytransaction_accession_acc_book').autocomplete
  minLength: 2
  source: $('#librarytransaction_accession_acc_book').data('autocomplete-source')
  
  
  
  