Array.max = function( array ){
    return Math.max.apply( Math, array );
};

Array.min = function( array ){
    return Math.min.apply( Math, array );
};

function dotChart(data, axisx, axisy){
  var r = Raphael("by_month_and_weekday"), xs = [], ys = [];
  var axisx = axisx || ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
  var axisy = axisy || ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];    
  for( j = axisy.length; j > 0; j--){
    for( i = 0; i < axisx.length; i++){
      xs.push(i); // [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
      ys.push(j); // [7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
    }
  }
  var data = data || [294, 300, 204, 255, 348, 383, 334, 217, 114, 33, 44, 26, 41, 39, 52, 17, 13, 2, 0, 2, 5, 6, 64, 153, 294, 313, 195, 280, 365, 392, 340, 184, 87, 35, 43, 55, 53, 79, 49, 19, 6, 1, 0, 1, 1, 10, 50, 181, 246, 246, 220, 249, 355, 373, 332, 233, 85, 54, 28, 33, 45, 72, 54, 28, 5, 5, 0, 1, 2, 3, 58, 167, 206, 245, 194, 207, 334, 290, 261, 160, 61, 28, 11, 26, 33, 46, 36, 5, 6, 0, 0, 0, 0, 0, 0, 9, 9, 10, 7, 10, 14, 3, 3, 7, 0, 3, 4, 4, 6, 28, 24, 3, 5, 0, 0, 0, 0, 0, 0, 4, 3, 4, 4, 3, 4, 13, 10, 7, 2, 3, 6, 1, 9, 33, 32, 6, 2, 1, 3, 0, 0, 4, 40, 128, 212, 263, 202, 248, 307, 306, 284, 222, 79, 39, 26, 33, 40, 61, 54, 17, 3, 0, 0, 0, 3, 7, 70, 199];
  r.g.txtattr.font = "11px 'Fontin Sans', Fontin-Sans, sans-serif";
  r.g.dotchart(10, 10, 450, 250, xs, ys, data, {symbol: "o", max: 10, heat: true, axis: "0 0 1 1", axisxstep: Array.max(xs), axisystep: Array.max(ys) - 1, axisxlabels: axisx, axisxtype: " ", axisytype: " ", axisylabels: axisy}).hover(function () {
      if(this.value > 0){
        this.tag = this.tag || r.g.tag(this.x, this.y, this.value, 0, this.r + 2).insertBefore(this);
        this.tag.show();
      }
  }, function () {
      this.tag && this.tag.hide();
  });  
}
function dateChart(){

  var divid = "g1"; // change this to match your DIV ID
  var w = 500; // width
  var h = 120; // height
  inetsoft.graph.importPackage(inetsoft.graph)
  inetsoft.graph.importPackage(inetsoft.graph.aesthetic)
  inetsoft.graph.importPackage(inetsoft.graph.coord)
  inetsoft.graph.importPackage(inetsoft.graph.data)
  inetsoft.graph.importPackage(inetsoft.graph.element)
  inetsoft.graph.importPackage(inetsoft.graph.guide)
  inetsoft.graph.importPackage(inetsoft.graph.guide.axis)
  inetsoft.graph.importPackage(inetsoft.graph.guide.form)
  inetsoft.graph.importPackage(inetsoft.graph.scale)
  inetsoft.graph.importPackage(inetsoft.graph.schema)

  // Your chart code
  var arr = [];

  var mname = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep",
               "Oct", "Nov", "Dec"];
  var wname = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
  var ndays = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
  var week = 1;

  for(var m = 0; m < mname.length; m++) {
     var base = (m < 4 || m > 9) ? 0.2 : 0.5;

     for(var d = 0; d < ndays[m]; d++) {
        var date = new Date(2008, m, d + 1);
        var ozone = base * Math.random() * 0.8;
        var color = 0xff0000;

        if(date.getDay() == 0) {
           week++;
        }

        if(ozone < 0.05) {
           color = 0x00ff00;
        }
        else if(ozone < 0.15) {
           color = 0xffff00;
        }
        else if(ozone < 0.25) {
           color = 0xff8800;
        }

        arr.push([mname[m], date, week, wname[date.getDay()], ozone, color]);
     }
  }

  arr.sort(function(a, b) {
     return b[1].getDay() - a[1].getDay();
  });

  arr.unshift(["month","date","week","weekday","ozone","color"]);

  var data = new DataSet(arr);
  var graph = new EGraph(data);
  var xscale = new CategoricalScale("week");
  var yscale = new CategoricalScale("weekday");
  var coord = new RectCoord(xscale, yscale);
  var elem = new PolygonElement("week", "weekday");

  xscale.type = TimeScale.MONTH;
  xscale.axisSpec.textFrame = new DefaultTextFrame();
  xscale.axisSpec.labelVisible = false;
  xscale.axisSpec.lineVisible = false;
  xscale.axisSpec.tickVisible = false;
  yscale.axisSpec.lineVisible = false;
  yscale.axisSpec.tickVisible = false;

  for(var i = 0; i < mname.length; i++) {
     var label = new LabelForm();
     label.label = mname[i];
     label.point = [0.06 + i * 0.95 / 12, 0];
     graph.addForm(label);
  }

  graph.xTitleSpec.label = " ";
  graph.tip = "Date: {1,date}<br>Accruals: {4}";

  elem.colorFrame = new StaticColorFrame();
  elem.colorFrame.field = "color";
  elem.lineFrame = new StaticLineFrame(GraphConstants.THIN_LINE);

  graph.x2TitleSpec.label = "Accruals (fake)";
  graph.x2TitleSpec.textSpec.font = "Verdana-BOLD-12";

  graph.setCoordinate(coord);
  graph.addElement(elem);
  graph.draw(divid,w,h,"http://chart.inetsoft.com/chart/gserver")
}

function pieChart(location, title, data){
  new Highcharts.Chart({
		chart: {
			renderTo: location,
			margin: [25,125,25,0]
		},
		title: {
			text: title
		},
		plotArea: {
			shadow: null,
			borderWidth: null,
			backgroundColor: null
		},
		tooltip: {
			formatter: function() {
				return this.point.name.substring(0,7) +': '+ this.y; // truncate tooltips to fit
			}
		},
		plotOptions: {
			pie: {
				dataLabels: {
					enabled: false
				}
			}
		},
		legend: {
			layout: 'vertical',
			style: {
				left: 'auto',
				bottom: 'auto',
				right: '0px',
				top: '25px'
			}
		},
    series: [{
			type: 'pie',
			name: title,
			data: data
			// data: [["female", 2], ["male", 2], ["not reported", 4], ["unknown", 1]]

      // series: [{
      //       name: 'Tokyo',
      //       dataURL: 'tokyo.json'
      //    }]
      // 
			//[{
			//		name: 'Firefox',
			//		y: 44.2,
			//		sliced: false
			//	},
			//	['IE7', 26.6],
			//	{
			//		name: 'IE6',
			//		y: 20,
			//		sliced: true
			//	},
			//	['Chrome', 3.1],
			//	{
			//		name: 'Safari',
			//		y: 2.7,
			//		sliced: false
			//	},
			//	['Opera', 2.3],
			//	['Mozilla', 0.4]
			//]
			//data: [3.40, 1.05, 2.90, 1.65, 1.35, 2.59, 1.39, 3.07, 2.82]
		}]
	});
  
}