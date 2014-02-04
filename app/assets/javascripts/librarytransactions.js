$(document).ready(function(){

    //show submit date
    $('#option_student').click(function() {
        $('.student_search').show();
        $('.staff_search').hide();
    });

    $('#option_staff').click(function() {
        $('.student_search').hide();
        $('.staff_search').show();
    });
});