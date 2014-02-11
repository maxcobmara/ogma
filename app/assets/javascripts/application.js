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
//= require bigtext
//= require_tree .


$(document).ready(function () {
  $('.btn').tooltip( {placement: 'bottom', container: 'body'});  //pill tooltips
  $('.tipsy').tooltip({ placement: 'right'});
  $('.tenant').tooltip( {placement: 'right', container: 'body'});
  
  $('[data-behaviour=datepicker_before]').datepicker({
    format: "yyyy/mm/dd",
    endDate: "today + 1",
    todayBtn: "linked",
    autoclose: true
  });
  
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
  
  $('select').selectpicker();
  
  $('#bigtext').bigtext();
});

