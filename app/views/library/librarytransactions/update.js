$('#row_<%=@librarytransaction.id%>').remove();  
$('#onload_count').remove();
$('#onchange_count').html('<%= j render("books_count") %>');
$('#new_link').show();