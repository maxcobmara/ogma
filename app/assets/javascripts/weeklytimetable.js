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

});

//$j(document).ready(function(){

				
		//HOD endorse
		/*
		$j("input[id='check_hod_accept']").change(function() {  
		 if($j('#check_hod_accept').is(':checked')) { 
		    $j("#span_hod_endorse").show("highlight"); 
		 }else		{
		    $j("#span_hod_endorse").hide(""); 
		 }	
		});
		
		$j("input[id='check_hod_accept']").each(function() {  
		 if($j('#check_hod_accept').is(':checked')) { 
		    $j("#span_hod_endorse").show("highlight"); 
		 }else		{
		    $j("#span_hod_endorse").hide(""); 
		 }	
		}); */
		
		//HOD reject
		/*
		$j("input[id='check_hod_reject']").change(function() {  
		 if($j('#check_hod_reject').is(':checked')) { 
		   $j("#span_hod_endorse2").show("highlight"); 
		 }else		{
		    $j("#span_hod_endorse2").hide(""); 
		 }	
		});
		
		$j("input[id='check_hod_reject']").each(function() {  
		 if($j('#check_hod_reject').is(':checked')) { 
		    $j("#span_hod_endorse2").show("highlight"); 
		 }else		{
		    $j("#span_hod_endorse2").hide(""); 
		 }	
		});

});*/