$(document).ready(function(){
  $('#student_race2').change(function() {
    if($(this).val() == 21) {
      $('.bong').show();
    }else {
         $('.bong').hide();
   }
   });
});