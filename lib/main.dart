import 'package:flutter/material.dart';
import './homePage.dart';
import 'showData.dart';

void main() => runApp(new MaterialApp(
  debugShowCheckedModeBanner: false,
  routes: <String, WidgetBuilder>{
    '/showData': (BuildContext context) => new ShowData(),
    '/homePage': (BuildContext context) => new HomePage(),
  },
  home: new HomePage(),
));
