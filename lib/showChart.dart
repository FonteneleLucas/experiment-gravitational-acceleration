import 'dart:math';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:charts_flutter/src/text_element.dart';
import 'package:charts_flutter/src/text_style.dart' as style;

class ShowChart extends StatefulWidget {
  @override
  _ShowChartState createState() => new _ShowChartState();
}

class LinearSales {
  final double year;
  final double sales;

  LinearSales(this.year, this.sales);
}


class _ShowChartState extends State<ShowChart> {

  @override
  Widget build(BuildContext context) {
    var data = [
      new LinearSales(0, 5),
      new LinearSales(1, 25),
      new LinearSales(2, 100),
      new LinearSales(3, 75),
//      new LinearSales(1, 9.8),
//      new LinearSales(2, 9.9),
//      new LinearSales(3, 10.2),
//      new LinearSales(4, 10.4),
//      new LinearSales(5, 9.5),
//      new LinearSales(6, 10.1),
//      new LinearSales(7, 9.7),
//      new LinearSales(8, 10.3),
//      new LinearSales(9, 10.7),
//      new LinearSales(10, 9.8),
    ];

    var series = [
      new Series(
        id: 'Sales',
        colorFn: (_, __) => MaterialPalette.blue.shadeDefault,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
      ),
    ];




    return new Scaffold(
        body: SingleChildScrollView(

            child: Column(
              children: <Widget>[
                Stack(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(left: 0, top: 40, right: 0, bottom: 0),
//            color: Colors.lightBlue,
                        height: 60,
                        child: Center(
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment(-1, 0),
//                color: Colors.lightBlue,
                                  child: IconButton(
                                    icon: Icon(Icons.arrow_back_ios),
                                    iconSize: 40,
                                    color: Colors.green,
                                    tooltip: 'Voltar',
                                    onPressed: () {
                                      print("Voltar");
                                      Navigator.of(context).pushNamed('/homePage');
                                    },
                                  ),
                                ),
                                Container(
                                  alignment: Alignment(0, 0),
                                  child: Text(
                                    "GRÁFICOS",
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat'
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ),
                      ),
                    ]),
                Container(
                    margin: EdgeInsets.only(top: 10,bottom: 10),
                    child: Text("GRAVIDADE", style: TextStyle(color: Colors.green,fontSize: 18, fontFamily: 'Montserrat' ,
                        fontWeight: FontWeight.bold))
                ),
                Container(
                  child: Material(
                    elevation: 2,
                    child: Padding(
                      padding: new EdgeInsets.all(15),
                      child: new SizedBox(
                        height: 200.0,
                        child: LineChart(series,
                          behaviors: [
                            LinePointHighlighter(
                                symbolRenderer: CustomCircleSymbolRenderer()
                            )
                          ],
                          selectionModels: [
                            SelectionModelConfig(
                                changedListener: (SelectionModel model) {
                                  if(model.hasDatumSelection)
                                    print(model.selectedSeries[0].measureFn(model.selectedDatum[0].index));
                                }
                            )
                          ],
                        )
                      ),
                    ),
                  )
                ),
                Container(
                    margin: EdgeInsets.only(top: 10,bottom: 10),
                    child: Text("TEMPO", style: TextStyle(color: Colors.green,fontSize: 18, fontFamily: 'Montserrat' ,
                        fontWeight: FontWeight.bold))
                ),
                Container(
                    child: Material(
                      elevation: 2,
                      child: Padding(
                        padding: new EdgeInsets.all(15),
                        child: new SizedBox(
                          height: 200.0,
//                          child: charts.LineChart(series, animate: true),
                        ),
                      ),
                    )
                ),
                Container(
                    margin: EdgeInsets.only(top: 10,bottom: 10),
                    child: Text("GRAVIDADE x TEMPO", style: TextStyle(color: Colors.green,fontSize: 18, fontFamily: 'Montserrat' ,
                        fontWeight: FontWeight.bold))
                ),
                Container(
                    child: Material(
                      elevation: 2,
                      child: Padding(
                        padding: new EdgeInsets.all(15),
                        child: new SizedBox(
                          height: 200.0,
//                          child: charts.LineChart(series, animate: true),
                        ),
                      ),
                    )
                ),
              ],
            )


        )
    );
  }
}

class CustomCircleSymbolRenderer extends CircleSymbolRenderer {
  @override
  void paint(ChartCanvas canvas, Rectangle<num> bounds, {List<int> dashPattern, Color fillColor, Color strokeColor, double strokeWidthPx}) {
    super.paint(canvas, bounds, dashPattern: dashPattern, fillColor: fillColor, strokeColor: strokeColor, strokeWidthPx: strokeWidthPx);
    canvas.drawRect(
        Rectangle(bounds.left - 5, bounds.top - 30, bounds.width + 10, bounds.height + 10),
        fill: Color.white
    );
    var textStyle = style.TextStyle();
    textStyle.color = Color.black;
    textStyle.fontSize = 15;
    canvas.drawText(
        TextElement("1", style: textStyle),
        (bounds.left).round(),
        (bounds.top - 28).round()
    );
  }
}

