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
//= require nicEdit
//= require jsapi
//= require chartkick
//= require chosen-jquery
//= require ckeditor/init
//= require_tree

// See http://stackoverflow.com/a/16984739/64904
// Updated by Larry to setup for fading
$(function() {
  var json, tabsState;
  $('a[data-toggle="pill"], a[data-toggle="tab"]').on('shown.bs.tab', function(e) {
    var href, json, parentId, tabsState;
    tabsState = localStorage.getItem("tabs-state");
    json = JSON.parse(tabsState || "{}");
    parentId = $(e.target).parents("ul.nav.nav-pills, ul.nav.nav-tabs").attr("id");
    href = $(e.target).attr('href');
    json[parentId] = href;
    return localStorage.setItem("tabs-state", JSON.stringify(json));
  });
  tabsState = localStorage.getItem("tabs-state");
  json = JSON.parse(tabsState || "{}");
  $.each(json, function(containerId, href) {
    var a_el = $("#" + containerId + " a[href=" + href + "]");
    $(a_el).parent().addClass("active");
    $(href).addClass("active in");
    return $(a_el).tab('show');
  });
  $("ul.nav.nav-pills, ul.nav.nav-tabs").each(function() {
    var $this = $(this);
    if (!json[$this.attr("id")]) {
      var a_el = $this.find("a[data-toggle=tab]:first, a[data-toggle=pill]:first"),
          href = $(a_el).attr('href');
      $(a_el).parent().addClass("active");
      $(href).addClass("active in");
      return $(a_el).tab("show");
    }
  });
});
