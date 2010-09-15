$(document).ready(function(){
  // one less click for login
  $("#netid").focus();
  // overlay
  $("a[rel=#help]").overlay({onBeforeLoad: function(){var wrap = this.getContent().find(".contentWrap"); wrap.load(this.getTrigger().attr("href"), "format=js");}, expose: {color: '#fff', loadSpeed: 200, opacity: 0.5}});
  $("a[rel=#database-language]").overlay({expose: {color: '#fff', loadSpeed: 200, opacity: 0.5}});
  // scrollable
  $("div.panes").scrollable({size: 1}).navigator({navi: "ul.tabs", naviItem: "a", activeClass: "current"});
  // flash (messages)
  $("#flash .close").click(function(){$("#flash").fadeOut(300);});
  // video
  flowplayer("player", "/media/flowplayer-3.2.2.swf", {clip: {autoPlay: false}, canvas: {backgroundColor: '#dddddd', backgroundGradient: 'medium'}});
});