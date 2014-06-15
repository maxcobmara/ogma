



$(document).ready(function(e) {
  $('.selectpicker').selectpicker();
  $('.tenant').tooltip( {placement: 'right', container: 'body'});
  $('.index_search_bar').click(function() {	   
     $('.search_row').toggleClass('hidden'); 
  });
  $('.date_picker').datetimepicker({
   timepicker:false,
   	format:'Y-m-d',
   	formatDate:'Y-m-d'
  });
   

});