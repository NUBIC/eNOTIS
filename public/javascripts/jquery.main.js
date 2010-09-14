$(document).ready(function() {
  // Study Information Tooltips
  $('#results a[rel=#study_information]').live('mouseover', function(event) {
   jQuery('#results a[rel=#study_information]').tooltip({position: 'center right', offset: [-1*jQuery('#results').offset().top, -1*jQuery('#results').offset().left]});
  });
  
 // flash messages
  $("#flash .close").click(function(){$("#flash").fadeOut(300); return false;});
 
 // studies index
  $("#my_studies a[rel=#study_information]").overlay({ 
    onBeforeLoad: function() { var wrap = $("#study_information .contentWrap"); wrap.html(this.getTrigger().next('.study_information').html()); },
    expose: { color: '#fff', loadSpeed: 200, opacity: 0.5 }
  });
 
 // My Studies
 $('#my_studies .display').dataTable( {
   "oLanguage": {
     "sProcessing": '/images/spinner.gif'
   },
   "bProcessing": true,
   "bServerSide": true,
   "bRetrieve": true,
   "sPaginationType": "full_numbers",
   "sAjaxSource": "studies.json"
 });

 // Searching Studies
 $('#study_results .display').dataTable( {
   "oLanguage": {
     "sProcessing": '/images/spinner.gif'
   },
   "bProcessing": true,
   "bServerSide": true,
   "bRetrieve": true,
   "sPaginationType": "full_numbers",
   "sAjaxSource": "search.json?" + $.param({query: $.getUrlVar('query')})
  });

 // search page
 jQuery('#results a[rel=#study_information]').tooltip({position: 'center right', offset: [-1*jQuery('#results').offset().top, -1*jQuery('#results').offset().left]});
  $("#subject_results .subject_display").dataTable({"aoColumns": [{ "sType": "html" }]});
 
 // studies show
    // dataTable
    $("#accrual .display").dataTable({"fnDrawCallback": activateRows, "iDisplayLength": 30, "sPaginationType": "full_numbers", "oLanguage": {"sZeroRecords": "<p><strong>No subjects yet - click 'Add' or 'Import' to get started. Or watch our <a rel='#intro'>4 minute introduction to eNOTIS</a>.</strong></p>"},"aoColumns": [null,null,null,null,null,null,null,{ "sType": "html" },{ "sType": "html" }]});    
    
    // redraw dashes for empty cells, activate other studies and view/edit overlays
    function activateRows(){
      $("#accrual .display td:empty, #import .display td:empty").html("--");
      
      // other studies overlay
      $("a[rel=#other_studies]").overlay({
        onBeforeLoad: function(){ $("#other_studies .wrap").load(this.getTrigger().attr("href"), "format=js", activateAccept) },
        expose: { color: '#fff', loadSpeed: 200, opacity: 0.5 },
        onClose: function(){$("#other_studies .wrap").html("");}
      });
      
      // involvement overlay
      $("table.display a[rel=#involvement]").overlay({
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
    }

    // add involvement overlay
    $("#actions a[rel=#involvement]").overlay({
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
    
    // introduction overlay
    $("a[rel=#intro]").overlay({
      expose: { color: '#fff', loadSpeed: 200, opacity: 0.5 },
    });
    
    // import overlay
    $("#actions a[rel=#import]").overlay({
      onBeforeLoad: function(){ $("#import .wrap").load(this.getTrigger().attr("href"), "format=js"); },
      expose: { color: '#fff', loadSpeed: 200, opacity: 0.5 }
    });

    // export overlay
    $("#actions a[rel=#export]").overlay({
      onBeforeLoad: function(){ $("#export .wrap").load(this.getTrigger().attr("href"), "format=js"); },
      expose: { color: '#fff', loadSpeed: 200, opacity: 0.5 }
    });
    
    // report overlay
    $("a[rel=#report]").overlay({
      expose: { color: '#fff', loadSpeed: 200, opacity: 0.5 },
    });
        
    // bind an event onto the accept link that loads the other studies view into the same overlay
    function activateAccept(){
      $("#other_studies .wrap a.accept").click(function(e){
        $("#other_studies .wrap").load($(e.target).attr("href"), "format=js");
        e.preventDefault();
      });
    }
        
    // study information
    $("#study a[rel=#study_information]").click(function(){
      $('#study_information').slideToggle();
      return false;
    });
});