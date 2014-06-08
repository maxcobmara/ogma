// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.ui.autocomplete
//= require jquery_ujs
//= require bootstrap.min
//= require bootstrap-datepicker
//= require bootstrap-select
//= require bootstrap-switch
//= require bigtext
//= require mlpushmenu
//= require jsapi
//= require chartkick
//= require nicEdit
//= require classie


$('.tenant').tooltip( {placement: 'right', container: 'body'});

$(document).ready(function () {
    //pill tooltips
  $('.tipsy').tooltip({ placement: 'right'});

  $('.btn').tooltip( {placement: 'bottom', container: 'body'});
  $(".bogus").click(function (e) {
      alert("Sorry! Feature not yet implemented");
  });
  
  
  $('[data-behaviour=datepicker_today]').datepicker({
    format: "yyyy/mm/dd",
    endDate: "today + 1",
    todayBtn: "linked",
    autoclose: true
  });

  $('[data-behaviour=datetimepicker]').datetimepicker({
    format: "dd MM yyyy - HH:ii P",
    showMeridian: true,
    autoclose: true,
    todayBtn: true
  });  

  //Use this for picking only dates in the past
  $('[data-behaviour=datepicker_before]').datepicker({
    format: "yyyy/mm/dd",
    endDate: "today + 1",
    todayBtn: "linked",
    autoclose: true
  });


  //Use this for picking only future dates
  $('[data-behaviour=datepicker_after]').datepicker({
    format: "yyyy/mm/dd",
    startDate: "today",
    autoclose: true,
    todayBtn: true
  });
  
  $('[data-behaviour=datepicker_std]').datepicker({
    format: "yyyy-mm-dd",
    autoclose: true,
    todayBtn: true
  });
  
  //Use this for birthdays
  $('[data-behaviour=datepicker_dob]').datepicker({
    format: "yyyy/mm/dd",
    autoclose: true,
    startView: 2
  });
  
  $(".input-daterange").datepicker({
    todayBtn: "linked", 
    todayHighlight: true
  });
  
  $('.datetimepicker').datetimepicker({pickSeconds: false});
  $('.selectpicker').selectpicker();
  
  $('.toga').click(function() {	   
     $('.search_bar').toggle();
     $('.search_row').toggleClass('hidden'); 
  });
  
  $("[id='my_checkbox']").bootstrapSwitch();
  
  $('.bigtext').bigtext();
  
  $('#quote-carousel').carousel({
    interval: 10000,
  });
});

