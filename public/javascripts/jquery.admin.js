$(document).ready(function(){
  // flash messages
  $("#flash .close").click(function(){$("#flash").fadeOut(300); return false;});

  // roles.lookup
  $("a[rel=#roles]").overlay({
    fixed: false, // allows user to scroll if overlay extends beyond viewport
    onBeforeLoad: function(){
      var v = this.getTrigger().prev("input").val();
      if(v){ $("#roles .wrap").load("/roles/" + v); }
      else{ $("#roles .wrap").html("Please enter a netid.");}
    },
    expose: { color: '#fff', loadSpeed: 200, opacity: 0.5 },
    onClose: function(){$("#roles .wrap").html("");}
  });

  // show the Data Tables
  $("#active_users .display").dataTable({"sPaginationType": "full_numbers"});
  $("#active_studies .display").dataTable({"sPaginationType": "full_numbers"});
  $("#recent_uploads .display").dataTable({"sPaginationType": "full_numbers", "aoColumns": [{ "sType": "string", "asSorting": [ "desc", "asc" ] }, null, null, null, null, null]});

  // easter egg
  $("img.hub").fadeIn(10000);

});
