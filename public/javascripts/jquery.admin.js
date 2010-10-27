$(document).ready(function(){
  // flash messages
  $("#flash .close").click(function(){$("#flash").fadeOut(300); return false;});

  // show the Data Tables
  $("#active_users .display").dataTable({"sPaginationType": "full_numbers"});
  $("#active_studies .display").dataTable({"sPaginationType": "full_numbers"});
  $("#recent_uploads .display").dataTable({"sPaginationType": "full_numbers", "aoColumns": [{ "sType": "string", "asSorting": [ "desc", "asc" ] }, null, null, null, null, null]});

  // easter egg
  $("img.hub").fadeIn(10000);

});
