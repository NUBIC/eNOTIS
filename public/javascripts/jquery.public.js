$(document).ready(function(){
  // flash (messages)
  $("#flash .close").click(function(){$("#flash").fadeOut(300);});

  // one less click for login
  $("#netid").focus();

  // login help overlay
  $("a[rel=#help]").overlay({
    onBeforeLoad: function(){ $("#help .contentWrap").load(this.getTrigger().attr("href"), "format=js"); },
    expose: {color: '#fff', loadSpeed: 200, opacity: 0.5}
  });
  
  // scrollable
  $("div.panes").scrollable({size: 1}).navigator({navi: "ul.tabs", naviItem: "a", activeClass: "current"});
  
  // db language overlay
  $("a[rel=#database-language]").overlay({expose: {color: '#fff', loadSpeed: 200, opacity: 0.5}});
      
  // video
  if($('#player').length){
    flowplayer("player", "/media/flowplayer-3.2.4.swf", {clip: {autoPlay: false}, canvas: {backgroundColor: '#dddddd', backgroundGradient: 'medium'}});
  }
});