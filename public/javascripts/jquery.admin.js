$(document).ready(function(){
  // flash messages
  $("#flash .close").click(function(){$("#flash").fadeOut(300); return false;});

  // roles.lookup
  $("a[rel=#roles]").overlay({
    fixed: false, // allows user to scroll if overlay extends beyond viewport
    onBeforeLoad: function(){
      var v = this.getTrigger().prev("input").val();
      var s = this.getTrigger().attr("href");
      if(v){ $("#roles .wrap").load("/roles/" + v); }
      else if(s && s != "#"){ $("#roles .wrap").load(s); }
      else{ $("#roles .wrap").html("Please enter a netid.");}
    },
    expose: { color: '#fff', loadSpeed: 200, opacity: 0.5 },
    onClose: function(){$("#roles .wrap").html("");}
  });
  
  // show the Data Tables
  $("#recent_handers .display").dataTable({"sPaginationType": "full_numbers", "aoColumns": [{ "sType": "string", "asSorting": [ "desc", "asc" ] }, null, null, null, null]});
  $("#deadbeats .display").dataTable({"sPaginationType": "full_numbers", "aoColumns": [{ "sType": "string", "asSorting": [ "desc", "asc" ] }, null, null, null, null, null]});
  $("#recent_uploads .display").dataTable({"sPaginationType": "full_numbers", "aoColumns": [{ "sType": "string", "asSorting": [ "desc", "asc" ] }, null, null, null, null, null]});

});
