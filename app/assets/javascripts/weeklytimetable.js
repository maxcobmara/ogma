$(document).ready(function(){
	
			//show submit date
			$("input[id='check_submitted']").change(function() {  
			 if($('#check_submitted').is(':checked')) { 
			    $("#span_submitted").show("highlight"); 
			 }else		{
			    $("#span_submitted").hide(""); 
			 }	
			});

			$j("input[id='check_submitted']").each(function() {  
			 if($('#check_submitted').is(':checked')) { 
			    $("#span_submitted").show("highlight"); 
			 }else		{
			    $("#span_submitted").hide(""); 
			 }	
			});

});