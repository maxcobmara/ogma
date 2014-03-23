jQuery ->
  $('form').on 'click', '.remove_fields', (event) ->
    $(this).prev('input[type=hidden]').val('1')
    $(this).closest('fieldset').hide()
    event.preventDefault()

  $('form').on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).before($(this).data('fields').replace(regexp, time))
    event.preventDefault()
    
  $('#librarytransaction_accession_acc_book').autocomplete
      source: $('#librarytransaction_accession_acc_book').data('autocomplete-source')

      
  $ ()->
    $("form.new_post").on "ajax:success", (event, data, status, xhr) ->
      $('#new-post-modal').modal('hide')
      
  $('#search_staff_name').autocomplete
    minLength: 3
    source: $('#search_staff_name').data('autocomplete-source')
    
  $('#search_student_icno').autocomplete
    minLength: 3
    source: $('#search_student_icno').data('autocomplete-source')
    
  $('#librarytransaction_accession_id').autocomplete
    minLength: 2
    source: $('#librarytransaction_accession_id').data('autocomplete-source')
  
  
  
  