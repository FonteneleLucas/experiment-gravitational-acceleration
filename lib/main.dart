import 'package:flutter/material.dart';
import './homePage.dart';
import 'showData.dart';
import 'showTable.dart';

void main() => runApp(new MaterialApp(
  debugShowCheckedModeBanner: false,
  routes: <String, WidgetBuilder>{
    '/showData': (BuildContext context) => new ShowData(),
    '/homePage': (BuildContext context) => new HomePage(),
    '/showTable': (BuildContext context) => new ShowTable(),
  },
  home: new HomePage(),
));
