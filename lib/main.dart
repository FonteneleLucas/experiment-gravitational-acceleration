import 'package:flutter/material.dart';
import './homePage.dart';
import 'showData.dart';
import 'showTable.dart';
import 'showChart.dart';

void main() => runApp(new MaterialApp(
  debugShowCheckedModeBanner: false,
  routes: <String, WidgetBuilder>{
    '/showData': (BuildContext context) => new ShowData(),
    '/homePage': (BuildContext context) => new HomePage(),
    '/showTable': (BuildContext context) => new ShowTable(),
    '/showChart': (BuildContext context) => new ShowChart(),
  },
//  home: new HomePage(),
    home: new ShowData()
));
