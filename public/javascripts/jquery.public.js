$.urlParam = function(name){
  var results = new RegExp('[\\?&]' + name + '=([^&#]*)').exec(window.location.href) || [];
  return results[1] || 0;
}
$(document).ready(function(){
  // flash (messages)
  $("#flash .close").click(function(){$("#flash").fadeOut(300);});
  
  // cas login iframe
  if ($.browser.msie) {
    // ie does not properly handle the iframe load event. after login, it doesn't reload to the proper page.
    // ie also has a weird cas logout issue, fixed by including any P3P header in the cas post response
    // alert( $.browser.version );
  } else {
    var shouldOpenLoginWindow = ($.urlParam('logout') == "true") || ($.urlParam('return') != 0);
    // ie has a js error from the cas focus event inside the hidden iframe, load iframe content here instead of on the page itself
    $("#loginframe iframe").attr('src', $('#login a[rel=#loginframe]').attr('href').replace("?service=","?compact&service="));
    $("a[rel=#loginframe]").overlay({ load: shouldOpenLoginWindow }); 
    $("#loginframe iframe").load(function (){
      // do something once the iframe is loaded
      try{
        $(this.contentDocument);
        // console.log($(this.contentDocument).attr('location'));
        $(window).attr('location', $(this.contentDocument).attr('location'));
      }catch(err){
        // console.log("different domain");
      }
      // console.log($(window).attr('location').hostname);
    });
  }

  // login help overlay
  $("a[rel=#help]").overlay({
    fixed: false, // allows user to scroll if overlay extends beyond viewport
    onBeforeLoad: function(){ $("#help .contentWrap").load(this.getTrigger().attr("href"), "format=js"); },
    expose: {color: '#fff', loadSpeed: 200, opacity: 0.5}
  });
  
  // scrollable
  $("div.panes").scrollable({size: 1}).navigator({navi: "ul.tabs", naviItem: "a", activeClass: "current"});
        
  // video
  if($('#player').length){
    flowplayer("player", "/media/flowplayer-3.2.4.swf", {clip: {autoPlay: false}, canvas: {backgroundColor: '#dddddd', backgroundGradient: 'medium'}});
  }
});