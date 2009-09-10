$(document).ready(function() {
	// save the width of the flash since changing it from absolute positioning at 40% to relative positioning (to slide up) decreases the width
	var flashWidth = $("#flash").css('width');
	$("#flash").animate({width: flashWidth}, 3000).slideUp(1000);
})