$(document).ready(function() {
  // livesearch
	$('input[name="query"]').liveSearch({url: '/search?format=js&query=', id: "livesearch-results"});

	// flash messages
	var flashWidth = $("#flash").css('width'); // save flash width. changing it to relative positioning (to slide up) decreases width
	$("#flash").animate({width: flashWidth}, 5000).slideUp(1000);
	
	// studies index
    $("#my_studies a[rel=#study_information]").overlay({ 
      onBeforeLoad: function() { var wrap = $("#study_information .contentWrap"); wrap.html(this.getTrigger().next('.study_information').html()); },
      expose: { color: '#fff', loadSpeed: 200, opacity: 0.5 }
    });
    // datatables
    $("#my_studies .display").dataTable({"sPaginationType": "full_numbers","aoColumns": [{ "sType": "html" }, null, null]});
	
	// studies show
    // dataTable
    $("#accrual .display").dataTable({"sPaginationType": "full_numbers","aoColumns": [{ "sType": "html" },{ "sType": "html" },{ "sType": "html" },{ "sType": "html" }]});

    // study overlay
    $("#study a[rel=#study_information]").overlay({ expose: { color: '#fff', loadSpeed: 200, opacity: 0.5 } });

    // subject overlay
    $("#study a[rel=#subject_information]").overlay({ 
      onBeforeLoad: function(){ $("#subject_information .contentWrap").html(this.getTrigger().next('.subject_information').html()); },
      onStart: function(){ var trigger = this.getTrigger(); $('#subject_information').css({'top': trigger.offset().top - 14, 'left': trigger.offset().left + trigger.outerWidth() }); },
      expose: { color: '#fff', loadSpeed: 200, opacity: 0.5 }
    });
    
    // involvement overlay
    $("#study a[rel=#involvement_information]").overlay({ 
      onBeforeLoad: function(){ $("#involvement_information .contentWrap").html(this.getTrigger().next('.involvement_information').html()); },
      onStart: function() {
        var trigger = this.getTrigger();
        $('#involvement_information').css({'top': trigger.offset().top, 'left': trigger.offset().left + trigger.outerWidth() + 5});
      },
      expose: { color: '#fff', loadSpeed: 200, opacity: 0.5 }
    });
  
    // import overlay
    $("a[rel=#import]").overlay({expose: { color: '#fff', loadSpeed: 200, opacity: 0.5 }});	

    // add overlay
    // $("a[rel=#add_subject]").overlay({
    //   onBeforeLoad: function() { var wrap = this.getContent().find(".contentWrap"); wrap.load(this.getTrigger().attr("href"), "format=js"); },
    //   onStart: function(){ var trigger = this.getTrigger(); $('#subject_information').css({'top': trigger.offset().top - 14, 'left': trigger.offset().left + trigger.outerWidth() }); },
    //   expose: { color: '#fff', loadSpeed: 200, opacity: 0.5 }
    // });
});