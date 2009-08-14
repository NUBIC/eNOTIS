// TODO - eventually change this to nested resources, since clicking on an event and jumping to the right one is pretty complicated, and we're outgrowing the purpose of jquery ui tabs -blc and yoon 2009-08-10
// commented out the code (lines 14, 23) that switches the document location in order to avoid jumping (scrolling) down the page
$(document).ready(function(){
	// instantiate jQueryUITabs
	$("#study").tabs(); 
	// switch tab to match the anchor
	switchTab($(document).attr('location').hash);

	$(document).click(function(e){
		// this event catches clicks on links to this document itself, closes the facebox, and switches the tab
		// clicks on links to other documents don't bubble up to the document element
		if($(e.target).is('a')){
			$.facebox.close();
			// loadLocation($(e.target).attr("href"));
			switchTab(e.target.hash);
		}
		
	});
	
	$("#subjects a[rel=detail]").click(function(event){
		event.stopPropagation();
		event.preventDefault();
		console.log($(event.target).attr('href'));
		$.ajax({
			type: "GET",
			url: $(event.target).attr('href'),
			dataType: "html",
			success: loadSubjectDetail
		})
	});
	
	
	function loadSubjectDetail(data){
		$('#subjects #subject-detail').html(data);		
	}
	function switchTab(anchor){
		// http://articles.rootsmith.ca/mod_python/how-to-make-jquery-ui-tabs-linkable-or-bookmarkable#comment-10188
		var index = $('#study div.ui-tabs-panel').index($(anchor)); // in tab index of the anchor in the URL
		$('#study').tabs('select', index); // select the tab
		// $('#study').bind('tabsshow', function(event, ui){ loadLocation($(document).attr('location').pathname + "#" + ui.panel.id); }); // change the url anchor when we click on a tab
	}
	function loadLocation(loc){
		document.location = loc;
		$('html, body').animate({scrollTop: 0}, 1);
	}
  
});