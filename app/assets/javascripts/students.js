$j(document).ready(function(){
  $j('#student_race2').change(function() {
    if($j(this).val() == 21) {
      $j('.bong').show();
    }else {
         $j('.bong').hide();
   }
   });
});