/***
@title:
Live Search

@version:
2.0

@author:
Andreas Lagerkvist

@date:
2008-08-31

@url:
http://andreaslagerkvist.com/jquery/live-search/

@license:
http://creativecommons.org/licenses/by/3.0/

@copyright:
2008 Andreas Lagerkvist (andreaslagerkvist.com)

@requires:
jquery, jquery.liveSearch.css

@does:
Use this plug-in to turn a normal form-input in to a live ajax search widget. The plug-in displays any HTML you like in the results and the search-results are updated live as the user types.

@howto:
jQuery('#q').liveSearch({url: '/ajax/search.php?q='}); would add the live-search container next to the input#q element and fill it with the contents of /ajax/search.php?q=THE-INPUTS-VALUE onkeyup of the input.

@exampleHTML:
<form method="post" action="/search/">

	<p>
		<label>
			Enter search terms<br />
			<input type="text" name="q" />
		</label> <input type="submit" value="Go" />
	</p>

</form>

@exampleJS:
jQuery('#jquery-live-search-example input[name="q"]').liveSearch({url: WEBROOT +'?module=SearchResults&q='});
***/
jQuery.fn.liveSearch = function (conf) {
	var config = jQuery.extend({
		url:			'/search?q=', 
		id:				'jquery-live-search', 
		duration:		200, 
		typeDelay:		200,
		loadingClass:	'loading', 
		onSlideUp:		function () {}
	}, conf);
	var liveSearch	= jQuery('#' + config.id);

	if (!liveSearch.length) {
		liveSearch = jQuery('<div id="' + config.id + '"></div>').appendTo(document.body).hide().slideUp(0);

		jQuery(document.body).click(function(event) {
			var clicked = jQuery(event.target);

			if (!(clicked.is('#' + config.id) || clicked.parents('#' + config.id).length || clicked.is('input'))) {
				liveSearch.slideUp(config.duration, function () {
					config.onSlideUp();
				});
			}
		});
	}

	return this.each(function () {
		var input		= jQuery(this).attr('autocomplete', 'off');
		var resultsShift	= parseInt(liveSearch.css('paddingLeft'), 10) + parseInt(liveSearch.css('paddingRight'), 10) + parseInt(liveSearch.css('borderLeftWidth'), 10) + parseInt(liveSearch.css('borderRightWidth'), 10);
		input
			.focus(function () {
				if (this.value !== '') {
					if (liveSearch.html() == '') {
						this.lastValue = '';
						input.keyup();
					}
					else {
						liveSearch.slideDown(config.duration);
						jQuery('#livesearch-results a[rel=#study_information]').tooltip({position: 'center right', offset: [-1*jQuery('#' + config.id).offset().top, -1*jQuery('#' + config.id).offset().left]});
					}
				}
			})
			.keyup(function () {
				if (this.value != this.lastValue) {
					input.addClass(config.loadingClass);

					var q = this.value;

					if (this.timer) {
						clearTimeout(this.timer);
					}
          if(q.length > 2){
  					this.timer = setTimeout(function () {
  						jQuery.get(config.url + q, function (data) {
  							input.removeClass(config.loadingClass);
  							if (data.length) {
  								liveSearch.html(data).filter(":hidden").slideDown(config.duration);
  								jQuery('#livesearch-results a[rel=#study_information]').tooltip({position: 'center right', offset: [-1*jQuery('#' + config.id).offset().top, -1*jQuery('#' + config.id).offset().left]});
  							}
  							else {
  								liveSearch.filter(":visible").slideUp(config.duration, function(){ config.onSlideUp(); });
  							}
  						});
  					}, config.typeDelay);
          }
          else {
            liveSearch.filter(":visible").slideUp(config.duration, function(){ config.onSlideUp(); });
          }
					this.lastValue = this.value;
				}
			});
	});
};