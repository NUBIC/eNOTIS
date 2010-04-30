$(document).ready(function() {
  // livesearch
  $('input[name="query"]').liveSearch({url: '/search?format=js&query=', id: "livesearch-results"});

	// flash messages
  $("#flash .close").click(function(){$("#flash").fadeOut(300); return false;});
	
	// studies index
  $("#my_studies a[rel=#study_information]").overlay({ 
    onBeforeLoad: function() { var wrap = $("#study_information .contentWrap"); wrap.html(this.getTrigger().next('.study_information').html()); },
    expose: { color: '#fff', loadSpeed: 200, opacity: 0.5 }
  });
  // datatables
  $("#my_studies .display").dataTable({"sPaginationType": "full_numbers","aoColumns": [{ "sType": "html" }, null, null, null, null]});
	
	// studies show
    // dataTable
    $("#accrual .display").dataTable({"iDisplayLength": 30, "sPaginationType": "full_numbers", "oLanguage": {"sZeroRecords": "No subjects yet - click 'Add' or 'Import' to get started."},"aoColumns": [null,null,null,null,null,null,null,{ "sType": "html" },{ "sType": "html" }]});
    $("#accrual .display td:empty, #import .display td:empty").html("--");

    // import overlay
    $("a[rel=#import]").overlay({
      onBeforeLoad: function(){ $("#import .wrap").load(this.getTrigger().attr("href"), "format=js"); },
      expose: { color: '#fff', loadSpeed: 200, opacity: 0.5 }
    });
    
    // involvement overlay
    $("a[rel=#involvement]").overlay({
      onBeforeLoad: function(){ $("#involvement .wrap").load(this.getTrigger().attr("href"), "format=js"); },
      expose: { color: '#fff', loadSpeed: 200, opacity: 0.5 },
      onLoad: function(){ $("#involvement input.date").datepicker({changeMonth: true, changeYear: true});
        $("#involvement input.dob").datepicker({
          showButtonPanel: true,
          changeMonth: true,
          changeYear: true,
          onSelect: function(dateText, inst){ inst.stayOpen = true; },
          onChangeMonthYear: function(year, month, inst) {
            inst.currentMonth = inst.selectedMonth = inst.drawMonth = month - 1;
            inst.currentYear = inst.selectedYear = inst.drawYear = year;
            inst.currentDay = inst.selectedDay = inst.selectedDay;
          },
          yearRange: '-120:+0'
        });
      }
    });

    // export overlay
    $("a[rel=#export]").overlay({
     onBeforeLoad: function(){ $("#export .wrap").load(this.getTrigger().attr("href"), "format=js"); },
     expose: { color: '#fff', loadSpeed: 200, opacity: 0.5 }
    });
    
    // study information
    $("#study a[rel=#study_information]").click(function(){
      $('#study_information').slideToggle();
      return false;
    });
});