$('#row_<%=@librarytransaction.id%>').remove(); 
$('#onload_count').remove();
$('#onchange_count').html('<%= j render("books_count") %>');
$('#onload_links').remove();
$('#onchange_links').html('<%= j render("linknew") %>');
// $('#new_link').show();
$('#changing_panel').removeClass('panel panel-danger');
$('#changing_panel').addClass('panel panel-info');