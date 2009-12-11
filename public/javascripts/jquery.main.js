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
	$("#flash").animate({width: flashWidth}, 3000).slideUp(1000);
	// shortcut keys - http://net.tutsplus.com/javascript-ajax/how-to-create-a-keypress-navigation-using-jquery
	$(document).keypress(function(e) { // alert(e.which);
    switch(e.which){
			case 47: // user presses "/"
	      $('#query').focus(); break;	
		}
	});
});