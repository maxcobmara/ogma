$(document).ready(function(e) {
  $('.btn').tooltip( {placement: 'bottom', container: 'body'});
  $('.selectpicker').selectpicker();
  $('.tenant').tooltip( {placement: 'right', container: 'body'});
  $('.index_search_bar').click(function() {	   
     $('.search_row').toggle(); 
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
  $('.datetime_picker3').datetimepicker({
    timepicker:true,
    format: "Y-m-d H:i",
    step: 30,
    defaultSeconds: 0,
    autoclose: true
  });
  $('.time_picker').datetimepicker({
     datepicker:false,
       format:'H:i',
       step:5,
  });
  $('.monthyear_picker').datetimepicker({
      format: "Y-m-d",
      timepicker: false,
      autoclose: true,
      onSelectDate: function(dp, $input) {
        $input.val($input.val().substr(0,8) + '01');
      }
  });
  $('.year_picker').datetimepicker({
      format: "Y-m-d",
      timepicker: false,
      autoclose: true,
      onSelectDate: function(dp, $input) {
        $input.val($input.val().substr(0,4) + '-01-01');
      }
  });
  $(".bogus").click(function (e) {
      alert("Sorry! Feature not yet implemented");
  });
   

});