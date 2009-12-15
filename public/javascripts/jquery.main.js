$(document).ready(function() {
  // overlay  
  $("a[rel=#overlay]").overlay({ 
    onBeforeLoad: function() { var wrap = this.getContent().find(".contentWrap"); wrap.load(this.getTrigger().attr("href"), "format=js"); },
    expose: { color: '#fff', loadSpeed: 200, opacity: 0.5 }
  }); 
  // livesearch
	$('input[name="query"]').liveSearch({url: '/search?format=js&query=', id: "livesearch-results"});
	// flash messages
	var flashWidth = $("#flash").css('width'); // save flash width. changing it to relative positioning (to slide up) decreases width
	$("#flash").animate({width: flashWidth}, 5000).slideUp(1000);
	
	// studies index
	// tooltip
  $("#my_studies a.study").tooltip({position: 'bottom right', predelay: 800});
  // dataTable
  // $("#study_list .display").dataTable({"sPaginationType": "full_numbers",bServerSide: true, sAjaxSource: '/studies.json' });
  $("#my_studies .display").dataTable({"sPaginationType": "full_numbers","aoColumns": [{ "sType": "html" }, null, null]});
	
	// studies show
	// overlay
  $("a[rel=#overlay]").overlay({expose: { color: '#fff', loadSpeed: 200, opacity: 0.5 }});
  $("a[rel=#import]").overlay({expose: { color: '#fff', loadSpeed: 200, opacity: 0.5 }});
  $('#overlay').css({'width': '955px'});
  // tooltip
  $("#study a.study").tooltip({position: 'bottom left', offset: [0, 955], predelay: 800});
  $("#accrual a.involvement").tooltip({position: 'bottom right', predelay: 800});
  $("#accrual a.subject").tooltip({position: 'bottom right', predelay: 800});
  // dataTable
  $("#accrual .display").dataTable({"sPaginationType": "full_numbers","aoColumns": [{ "sType": "html" },{ "sType": "html" },{ "sType": "html" },{ "sType": "html" }]});
	
});