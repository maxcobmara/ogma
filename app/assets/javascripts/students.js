$(document).ready(function(){
  $('#student_race2').change(function() {
    if($(this).val() == 21) {
      $('.bong').show();
    }else {
         $('.bong').hide();
   }
   });
  
  $('#student_sstatus').change(function() {
    if($(this).val() == "Transfer College") {
      $('.bong2').show();
    }else {
      $('.bong2').hide();
    }
  });
  $('#student_sstatus').each(function() {
    if($(this).val() == "Transfer College") {
      $('.bong2').show();
    }else {
      $('.bong2').hide();
    }
  });
  
  $('#student_sstatus').change(function() {
    if($(this).val() == "Repeat") {
      $('.bong3').show();
    }else {
      $('.bong3').hide();
    }
  });
  $('#student_sstatus').each(function() {
    if($(this).val() == "Repeat") {
      $('.bong3').show();
    }else {
      $('.bong3').hide();
    }
  });

});