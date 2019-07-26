import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:gravity_sensor/Gravity.dart';

class ShowTable extends StatefulWidget {
  @override
  _ShowTableState createState() => new _ShowTableState();
}

class _ShowTableState extends State<ShowTable> {
  var gravity = Gravity();
//class Episode5State extends State<Episode5> {
  Widget bodyData() => DataTable(

      
      columns: <DataColumn>[
        DataColumn(
          label: Text("Nº"),
          numeric: true,
          onSort: (i, b) {
            print("$i $b");
            setState(() {
//              dados.sort((a, b) => a.tempo.compareTo(b.tempo));
            });
          },
          tooltip: "To display first name of the Name",
        ),
        DataColumn(
          label: Text("Tempo (ms)"),
          numeric: true,

        ),
        DataColumn(
          label: Text("Gravidade"),
          numeric: true,
          onSort: (i, b) {
            print("$i $b");
            setState(() {
//              dados.sort((a, b) => a.gravidade.compareTo(b.gravidade));
            });
          },
          tooltip: "To display last name of the Name",
        ),
      ],
      rows: gravity.dados
          .map(
            (name) => DataRow(
          cells: [
            DataCell(
              Text(name.lancamento.toString()),
              showEditIcon: false,
              placeholder: false,
            ),
            DataCell(
              Text(name.tempo.toString()),
              showEditIcon: false,
              placeholder: false,
            ),
            DataCell(
              Text(name.gravidade.toString()),
              showEditIcon: false,
              placeholder: false,
            )
          ],
        ),
      )
          .toList());

  @override
  Widget build(BuildContext context) {

    gravity.setValues(1, 0.45, 10);
    gravity.setValues(2, 0.47, 9);
    gravity.setValues(3, 0.40, 10);
    return Scaffold(
      appBar: AppBar(
//        title: Text(gravity.dados.toString()),
      ),
      body: Container(
//        child: Text(gravity.getDados()),
        child: bodyData(),
      ),
    );
  }
}

//class Gravity{
//  int lancamento;
//  double tempo;
//  double gravidade;
//
//  Gravity({this.lancamento, this.tempo, this.gravidade});
//}





