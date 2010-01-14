var arr = [["Ethnicity", "Quantity"], ["hispanic or latino", 3], ["not hispanic or latino", 1], ["unknown", 1], ["not reported", 2]];
var data = new DataSet(arr);
var graph = new EGraph(data);
var elem = new IntervalElement(null,"Quantity");
var xscale = new CategoricalScale("Ethnicity")
var yscale = new LinearScale("Quantity");
var rect = new RectCoord(null, yscale);
var cframe = new CategoricalColorFrame("Ethnicity");
elem.colorFrame = cframe;
elem.collisionModifier = GraphElement.STACK_SYMMETRIC;
yscale.scaleRange = new StackRange();
var polar = new PolarCoord(rect);
polar.type = PolarCoord.THETA;
yscale.axisSpec.labelVisible = false;
yscale.axisSpec.lineVisible = false;
yscale.axisSpec.tickVisible = false;
// var tframe = new DefaultTextFrame("Ethnicity");
// elem.textFrame = tframe;
// cframe.legendSpec.visible = false;
elem.setHint(GraphElement.HINT_EXPLODED,true)
graph.setCoordinate(polar);
graph.addElement(elem);


