// only outputs if console available and does each argument on its own line
function log() {
  if (window && window.console && window.console.log) {
    var i, len;
    for (i=0, len=arguments.length; i<len; i++) {
      console.log(arguments[i]);
    }
  }
}
 
 
// Pretty output of rails errors when doing ajax requests with jQuery
$(document).bind('ajaxError', function (event, response, options, error) {
  var html, heading, paragraph, pre;
    
  if (response.status == 500) {
    html = $(response.responseText);
    heading = $(html[1]).text();
    paragraph = $(html[3]).text();
    pre = $(html[4]).text();
    log('');
    log('[ERROR] ' + response.status.toString());
    log($.trim(heading));
    log($.trim(paragraph));
    log($.trim(pre));
    log('');
  } else {
    log('');
    log('[ERROR] ' + response.status.toString());
    log(response.responseText);
    log('');
  }
});