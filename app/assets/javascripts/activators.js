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
 $('.date_picker_reverse').datetimepicker({
   timepicker:false,
   	format:'d-m-Y',
   	formatDate:'Y-m-d'
  });
 $('.datetime_picker_reverse').datetimepicker({
    timepicker:true,
    format:'d-m-Y H:i',
    formatDate:'Y-m-d H:i',
    step: 15,
    defaultSeconds: 0,
    autoclose: true
  });
  $('.date_picker_after').datetimepicker({
   timepicker:false,
   	format:'Y-m-d',
   	formatDate:'Y-m-d',
        minDate: 0
  });
  $('.date_picker_after_reverse').datetimepicker({
   timepicker:false,
   	format:'d-m-Y',
   	formatDate:'Y-m-d',
        minDate: 0
  });
  var curdt=new Date();
  $curdtfull=curdt.getFullYear()+'-'+curdt.getMonth()+'-'+curdt.getDay();
  $('.date_picker_after_reverse2').datetimepicker({
        timepicker:false,
        format:'d-m-Y',
        formatDate:'Y-m-d',
        minDate: 0,
        maxDate: +$curdtfull
  });
  //tenant - datekeyprovided
  //$tahun = '2010';
  //minDate: $tahun+'-07-01'
  //minDate: '2012-07-01'
  var currentdt = new Date();
  $currentmt = currentdt.getMonth();
  if($currentmt < 6)
    {$tahunbulan = (currentdt.getFullYear() - 3)+'-07';}
  else
    {$tahunbulan = (currentdt.getFullYear() - 2)+'-01';}
  $('.date_picker_before').datetimepicker({
        timepicker:false,
   	format:'Y-m-d',
   	formatDate:'Y-m-d',
        minDate: $tahunbulan+'-01'
  }); 
  $('.date_picker_before_reverse').datetimepicker({
        timepicker:false,
   	format:'d-m-Y',
   	formatDate:'Y-m-d',
        minDate: $tahunbulan+'-01'
  }); 
  
  $('.datetime_picker').datetimepicker({
    timepicker:true,
    format: "Y-m-d H:i",
    step: 15,
    defaultSeconds: 0,
    autoclose: true
  });
  $('.datetime_picker_reverse').datetimepicker({
    timepicker:true,
    format:'d-m-Y H:i',
    formatDate:'Y-m-d H:i',
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
  $('.datetime_picker2_reverse').datetimepicker({
    timepicker:true,
    format:'d-m-Y H:i',
    formatDate:'Y-m-d H:i',
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
  $('.datetime_picker3_reverse').datetimepicker({
    timepicker:true,
    format:'d-m-Y H:i',
    formatDate:'Y-m-d H:i',
    step: 30,
    defaultSeconds: 0,
    autoclose: true
  });
  $('.time_picker').datetimepicker({
     datepicker:false,
       format:'H:i',
       step:5,
  });
  $('.time_picker2').datetimepicker({
     datepicker:false,
     format:'H:i',
     step:15,
     autoclose: true,
     onSelectDate: function(dp, $input) {
        $input.val($input.val()+ ':00');
      }
  });
  $('.time_picker_duration').datetimepicker({
     datepicker:false,
     format:'H:i',
     step:15,
     minTime: '00:15',
     maxTime: '12:00',
     mask: true,
     autoclose: true,
     onSelectDate: function(dp, $input) {
        $input.val($input.val()+ ':00');
      }
  });
  $('.monthyear_picker').datetimepicker({
      format: "Y-m-d",
      timepicker: false,
      autoclose: true,
      onSelectDate: function(dp, $input) {
        $input.val($input.val().substr(0,8) + '01');
      }
  });
  $('.monthyear_picker_reverse').datetimepicker({
      format:'d-m-Y',
      formatDate:'Y-m-d',
      timepicker: false,
      autoclose: true,
      onSelectDate: function(dp, $input) {
        $input.val( '01'+$input.val().substr(2,10));
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
  $(function() {
    $('#myorgchart ul:first').attr('id', 'chart-source');
    $('#myorgchart ul:first').attr('class', 'hide');
    $("#chart-source").orgChart({container: $("#myorgchart")});
    
  });
  
  $(".bogus").click(function (e) {
      alert("Sorry! Feature not yet implemented");
  });
   

});
