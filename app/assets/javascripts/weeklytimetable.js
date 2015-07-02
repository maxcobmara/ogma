$(document).ready(function(){
	
			//show submit date
			$("input[id='check_submitted']").change(function() {  
			 if($('#check_submitted').is(':checked')) { 
			    $("#span_submitted").show("highlight"); 
			 }else		{
			    $("#span_submitted").hide(""); 
			 }	
			});

			$("input[id='check_submitted']").each(function() {  
			 if($('#check_submitted').is(':checked')) { 
			    $("#span_submitted").show("highlight"); 
			 }else		{
			    $("#span_submitted").hide(""); 
			 }	
			});

				
		//HOD endorse
		
		$("input[id='check_hod_accept']").change(function() {  
		 if($('#check_hod_accept').is(':checked')) { 
		    $("#span_hod_endorse").show("highlight"); 
		 }else		{
		    $("#span_hod_endorse").hide(""); 
		 }	
		});
		
		$("input[id='check_hod_accept']").each(function() {  
		 if($('#check_hod_accept').is(':checked')) { 
		    $("#span_hod_endorse").show("highlight"); 
		 }else		{
		    $("#span_hod_endorse").hide(""); 
		 }	
		}); 
		
		//HOD reject
		
		$("input[id='check_hod_reject']").change(function() {  
		 if($('#check_hod_reject').is(':checked')) { 
		   $("#span_hod_endorse2").show("highlight"); 
		 }else		{
		    $("#span_hod_endorse2").hide(""); 
		 }	
		});
		
		$("input[id='check_hod_reject']").each(function() {  
		 if($('#check_hod_reject').is(':checked')) { 
		    $("#span_hod_endorse2").show("highlight"); 
		 }else		{
		    $("#span_hod_endorse2").hide(""); 
		 }	
		});

});