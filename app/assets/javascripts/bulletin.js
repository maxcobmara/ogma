$(document).ready(function() {
  
  $('#bulletin_content').bind('keyup', function() {
    var content_length = $('#bulletin_content').val().length;
    $('#bulletin-counter').val(500 - content_length);
  });

});