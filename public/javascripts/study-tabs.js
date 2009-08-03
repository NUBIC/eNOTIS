$(document).ready(function(){
	// instantiate jQueryUITabs
	$("#study").tabs(); 
	// switch tab to match the anchor
	switchTab();

	$(document).click(function(e){
		// this event catches clicks on links to this document itself, closes the facebox, and switches the tab
		// clicks on links to other documents don't bubble up to the document element
		if($(e.target).is('a')){
			$.facebox.close();
			document.location = $(e.target).attr("href");
			switchTab();
		}
	});
	
	function switchTab(){
		// http://articles.rootsmith.ca/mod_python/how-to-make-jquery-ui-tabs-linkable-or-bookmarkable#comment-10188
		var anchor = $(document).attr('location').hash; // the anchor in the URL
		var index = $('#study div.ui-tabs-panel').index($(anchor)); // in tab index of the anchor in the URL
		$('#study').tabs('select', index); // select the tab
		$('#study').bind('tabsshow', function(event, ui){document.location = $(document).attr('location').pathname + "#" + ui.panel.id;}); // change the url anchor when we click on a tab
	}
  
});