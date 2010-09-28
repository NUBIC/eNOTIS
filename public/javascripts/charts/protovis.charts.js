function donut(fig, data, labels){
  var w = 238,
      h = 150,
      a = pv.Scale.linear(0, pv.sum(data)).range(0, 2 * Math.PI),
      colors = pv.Colors.category10();
  new pv.Panel()
    .def("i", -1)
    .canvas(fig)
    .width(w)
    .height(h)
  .add(pv.Wedge)
    .data(data)
    .left(70)
    .top(72)
    .outerRadius(70)
    .innerRadius(35)
    .angle(a)
    .fillStyle(pv.Colors.category10().by(function() this.index))
    .event("mouseover", function() this.parent.i(this.index))
    .event("mouseout", function() this.parent.i(-1))
  .anchor("center").add(pv.Label)
    .visible(function(d){ return jQuery.browser.msie ? a(d) > 0.15 : this.parent.i() == this.index;})
    .textAngle(0)
    .text(function(d) d)
    .textStyle("white")
    .font("15px sans-serif")
  .parent.add(pv.Dot)
    .data(data)
    .top(function() this.index * 16 + 7)
    .left(150)
    .strokeStyle(null)
    .fillStyle(function() colors(this.index))
  .anchor("right").add(pv.Label)
    .events("all")
    .text(function() labels[this.index])
    .event("mouseover", function() this.parent.i(this.index))
    .event("mouseout", function() this.parent.i(-1))
    .font("12px sans-serif")
    .textStyle("#999")
  .parent.add(pv.Label)
    .text(fig)
    .left(70)
    .top(77)
    .textAlign("center")
    .font("15px sans-serif")
    .textStyle("#666")
  .root.render();
}
function months(fig, title, labels, monthly, totals){
  /* Scales. */
  var w = 327, // 30 px added by left margin
      h = 160, // 40 px added by top/bottom margin
      x = pv.Scale.ordinal(labels).splitBanded(0, w, 4/5),
      y = pv.Scale.linear(0, pv.max(totals)).range(0, h).nice();

  var vis = new pv.Panel()
      .def("i", -1)
      .width(w)
      .height(h)
      .top(25)
      .bottom(15)
      .left(30)
      .canvas(fig);

  /* title */
  vis.add(pv.Label)
    .text(title)
    .font("15px sans-serif")
    .left(w/2)
    .top(-8)
    .textStyle("#666")
    .textAlign("center");

  /* y-axis ticks, labels */
  vis.add(pv.Rule)
       .data(y.ticks(7))
       .bottom(y)
       .left(-10)
       .right(-10)
       .strokeStyle("#ccc")
     .anchor("left").add(pv.Label)
       .textStyle("#999")
       .text(y.tickFormat);

   /* totals */        
   vis.add(pv.Line)
     .data(totals)
     .left(function(d) x(labels[this.index]) + (x.range().band * this.index/labels.length)) // make the line stretch to cover the bars
     .bottom(function(d) y(d))
     .lineWidth(3)
     .event("mouseover", function() this.parent.i('line'))
     .event("mouseout", function() this.parent.i(-1))
     .anchor("top").add(pv.Label)
       .visible(function() this.parent.i() == 'line')
       .text(function(d) d)
       .textStyle("#666")

  /* monthly bars, x-axis labels */
  var monthly = vis.add(pv.Bar)
    .data(monthly)
    .left(function(d) x(labels[this.index]))
    .width(x.range().band)
    .bottom(0)
    .height(function(d) y(d))
    .event("mouseover", function() this.parent.i('bars'))
    .event("mouseout", function() this.parent.i(-1))
    .anchor("bottom").add(pv.Label)
      .textBaseline("top")
      .text(function(d) labels[this.index])
      .textStyle("#999")
    .anchorTarget().anchor("top").add(pv.Label)
      .visible(function() this.parent.i() == 'bars')
      .textBaseline("bottom")
      .text(function(d) d)
      .textStyle("#666");

  vis.render();
}
function dots(fig, title, zvalues){
  /* Scales. */
  var days = "Sun Mon Tue Wed Thu Fri Sat".split(" ");
  var months = "Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec".split(" ");
  
  /* Sizing and scales. */
  var w = 332, // 25 px added by left margin
      h = 170, // 30px added by top and bottom margins
      x = pv.Scale.ordinal(months).split(0, w),
      y = pv.Scale.ordinal(days).split(0, h),
      s = pv.Scale.linear(zvalues).range(0, 100),
      c = pv.Scale.linear(zvalues).range("#1f77b4", "#ff7f0e");

  /* The root panel. */
  var vis = new pv.Panel()
      .width(w)
      .height(h)
      .top(15)
      .right(0)
      .bottom(15)
      .left(25)
      .canvas(fig);

  /* title */
  vis.add(pv.Label)
    .text(title)
    .font("15px sans-serif")
    .left(w/2)
    .top(0)
    .textStyle("#666")
    .textAlign("center");

  /* y-axis labels */
  vis.add(pv.Rule)
      .data(days)
      .bottom(function(d) y(d))
      .strokeStyle("#fff")
    .anchor("left").add(pv.Label)
      .textStyle("#999")

  /* x-axis labels */
  vis.add(pv.Rule)
      .data(months)
      .left(function(d) x(d))
      .strokeStyle("#fff")
    .anchor("bottom").add(pv.Label)
      .textStyle("#999")

  /* The dot plot! */
  /* The dot plot! */
  vis.add(pv.Panel)
      .def("i", -1)
      .data(zvalues)
    .add(pv.Dot)
      .left(function() x(this.parent.index%12))
      .bottom(function() y(Math.floor(this.parent.index/12)))
      .strokeStyle(function(d) c(d))
      .fillStyle(function() this.strokeStyle().alpha(.2))
      .size(function(d) s(d))
      .title(function(d) d.toFixed(0))
  vis.render();
}