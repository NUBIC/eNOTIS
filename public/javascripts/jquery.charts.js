$(document).ready(function() {
	var chart = new Highcharts.Chart({
		chart: {
			renderTo: 'foo',
			margin: [25,100,25,25]
		},
		title: {
			text: 'Genders'
		},
		plotArea: {
			shadow: null,
			borderWidth: null,
			backgroundColor: null
		},
		tooltip: {
			formatter: function() {
				return '<b>'+ this.point.name +'</b>: '+ this.y +' %';
			}
		},
		plotOptions: {
			pie: {
				dataLabels: {
					enabled: true,
					formatter: function() {
						if (this.y > 5) return this.point.name;
					},
					color: 'white',
					style: {
						font: '13px Trebuchet MS, Verdana, sans-serif'
					}
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
			name: 'Browser share',
			data: [["female", 2], ["male", 2], ["not reported", 4], ["unknown", 1]]

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
	
	
});
