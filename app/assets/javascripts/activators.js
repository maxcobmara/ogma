$(document).ready(function(e) {
  $('.btn').tooltip( {placement: 'bottom', container: 'body'});
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
  $('.datetime_picker').datetimepicker({
    timepicker:true,
    format: "Y-m-d H:i",
    step: 15,
    defaultSeconds: 0,
    autoclose: true
  });
  $('.datetime_picker2').datetimepicker({
    timepicker:true,
    format: "Y-m-d H:i",
    step: 1,
    defaultSeconds: 0,
    autoclose: true
  });
  $('.time_picker').datetimepicker({
     datepicker:false,
       format:'H:i',
       step:5,
    });
  $(".bogus").click(function (e) {
      alert("Sorry! Feature not yet implemented");
  });
   

});