$(document).ready(function() {
    // if the function argument is given to overlay, 
    // it is assumed to be the onBeforeLoad event listener 
    $("a[rel=#overlay]").overlay({ 
      onBeforeLoad: function() { var wrap = this.getContent().find(".contentWrap"); wrap.load(this.getTrigger().attr("href")); },
      expose: { color: '#fff', loadSpeed: 200, opacity: 0.5 }
    }); 
	
	// save the width of the flash since changing it from absolute positioning at 40% to relative positioning (to slide up) decreases the width
	var flashWidth = $("#flash").css('width');
	$("#flash").animate({width: flashWidth}, 3000).slideUp(1000);
})