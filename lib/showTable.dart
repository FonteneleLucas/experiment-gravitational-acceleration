import 'dart:async';

import 'package:flutter/material.dart';
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
          label: Text("Nº",style: TextStyle()),
          numeric: true,

        ),
        DataColumn(
          label: Text("Tempo (ms)"),
          numeric: true,

        ),
        DataColumn(
          label: Text("Gravidade"),
          numeric: true,
        ),
      ],
      rows: gravity.dados
          .map(
            (name) => DataRow(
          cells: [
            DataCell(
              Text(name.lancamento.toString(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              showEditIcon: false,
              placeholder: false,
            ),
            DataCell(
              Text(name.tempo.toString(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              showEditIcon: false,
              placeholder: false,
            ),
            DataCell(
              Text(name.gravidade.toString(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
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
    gravity.setValues(3, 0.43, 10);
    gravity.setValues(4, 0.42, 10);
    gravity.setValues(5, 0.49, 10);
    gravity.setValues(6, 0.41, 10);
    gravity.setValues(7, 0.38, 10);
    gravity.setValues(8, 0.59, 10);
    gravity.setValues(9, 0.38, 10);
    gravity.setValues(10, 0.59, 10);


    return Scaffold(
      body: SingleChildScrollView(

        child: Stack(
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
                      "DADOS ESTATÍSTICOS",
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
          Container(
            margin: const EdgeInsets.only(left: 0, top: 100, right: 0, bottom: 0),
//            color: Colors.green,
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
//                    color: Colors.lightBlueAccent,

                    child: Material(
                      color: Colors.white,
                      shadowColor: Colors.white70,
                      elevation: 5,

                      child: bodyData(),
                    ),


                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text("MÉDIA", style: TextStyle(color: Colors.green,fontSize: 18, fontFamily: 'Montserrat' ,
                      fontWeight: FontWeight.bold))
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 15, top: 8, right: 15, bottom: 10),
//                    color: Colors.lightGreen,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 5,
                          child: Container(
                            margin: EdgeInsets.only(right: 5),
//                            color: Colors.black12,
                            child:  Material(
                              color: Colors.white,
                              shadowColor: Colors.white70,
                              elevation: 10,

                              child: Container(
                                  height: 150,
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(top: 20),
                                        alignment: Alignment.topCenter,
                                        child: Text("GRAVIDADE", style: TextStyle(color: Colors.black54,fontSize: 15, fontFamily: 'Montserrat' ,
                                          fontWeight: FontWeight.bold,),),
                                      ),
                                      Container(
                                        alignment:Alignment.centerRight,
                                        padding: EdgeInsets.only(right: 4,bottom: 20),
                                        child: Text(
                                          "m/s²",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green),
                                        ),
                                      ),

                                      Center(
                                        child: Text("10,00",
                                            style: TextStyle(fontSize: 45,fontFamily: 'Montserrat', fontWeight: FontWeight.bold)
                                        ),
                                      )
                                    ],
                                  )

                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Container(
                            margin: EdgeInsets.only(left: 5),
//                            color: Colors.black12,
                            child:  Material(
                              color: Colors.white,
                              shadowColor: Colors.white70,
                              elevation: 10,

                              child: Container(
                                  height: 150,
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(top: 20),
                                        alignment: Alignment.topCenter,
                                        child: Text("TEMPO", style: TextStyle(color: Colors.black54,fontSize: 15, fontFamily: 'Montserrat' ,
                                          fontWeight: FontWeight.bold,),),
                                      ),
                                      Container(
                                        alignment:Alignment.centerRight,
                                        padding: EdgeInsets.only(right: 10,bottom: 20),
                                        child: Text(
                                          "ms",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green),
                                        ),
                                      ),

                                      Center(
                                        child: Text("0.45",
                                            style: TextStyle(fontSize: 45,fontFamily: 'Montserrat', fontWeight: FontWeight.bold)
                                        ),
                                      )
                                    ],
                                  )

                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
//                  Divider(color: Colors.black),
                  Container(
                      child: Text("MEDIANA", style: TextStyle(color: Colors.green,fontSize: 18, fontFamily: 'Montserrat' ,
                          fontWeight: FontWeight.bold))
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 15, top: 8, right: 15, bottom: 10),
//                    color: Colors.lightGreen,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 5,
                          child: Container(
                            margin: EdgeInsets.only(right: 5),
//                            color: Colors.black12,
                            child:  Material(
                              color: Colors.white,
                              shadowColor: Colors.white70,
                              elevation: 10,

                              child: Container(
                                  height: 150,
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(top: 20),
                                        alignment: Alignment.topCenter,
                                        child: Text("GRAVIDADE", style: TextStyle(color: Colors.black54,fontSize: 15, fontFamily: 'Montserrat' ,
                                          fontWeight: FontWeight.bold,),),
                                      ),
                                      Container(
                                        alignment:Alignment.centerRight,
                                        padding: EdgeInsets.only(right: 4,bottom: 20),
                                        child: Text(
                                          "m/s²",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green),
                                        ),
                                      ),

                                      Center(
                                        child: Text("10,00",
                                            style: TextStyle(fontSize: 45,fontFamily: 'Montserrat', fontWeight: FontWeight.bold)
                                        ),
                                      )
                                    ],
                                  )

                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Container(
                            margin: EdgeInsets.only(left: 5),
//                            color: Colors.black12,
                            child:  Material(
                              color: Colors.white,
                              shadowColor: Colors.white70,
                              elevation: 10,

                              child: Container(
                                  height: 150,
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(top: 20),
                                        alignment: Alignment.topCenter,
                                        child: Text("TEMPO", style: TextStyle(color: Colors.black54,fontSize: 15, fontFamily: 'Montserrat' ,
                                          fontWeight: FontWeight.bold,),),
                                      ),
                                      Container(
                                        alignment:Alignment.centerRight,
                                        padding: EdgeInsets.only(right: 10,bottom: 20),
                                        child: Text(
                                          "ms",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green),
                                        ),
                                      ),

                                      Center(
                                        child: Text("0.45",
                                            style: TextStyle(fontSize: 45,fontFamily: 'Montserrat', fontWeight: FontWeight.bold)
                                        ),
                                      )
                                    ],
                                  )

                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
//                  Divider(color: Colors.black),
                  Container(
                      child: Text("DESVIO PADRÃO", style: TextStyle(color: Colors.green,fontSize: 18, fontFamily: 'Montserrat' ,
                          fontWeight: FontWeight.bold))
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 15, top: 8, right: 15, bottom: 10),
//                    color: Colors.lightGreen,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 5,
                          child: Container(
                            margin: EdgeInsets.only(right: 5),
//                            color: Colors.black12,
                            child:  Material(
                              color: Colors.white,
                              shadowColor: Colors.white70,
                              elevation: 10,

                              child: Container(
                                  height: 150,
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(top: 20),
                                        alignment: Alignment.topCenter,
                                        child: Text("GRAVIDADE", style: TextStyle(color: Colors.black54,fontSize: 15, fontFamily: 'Montserrat' ,
                                          fontWeight: FontWeight.bold,),),
                                      ),
                                      Container(
                                        alignment:Alignment.centerRight,
                                        padding: EdgeInsets.only(right: 4,bottom: 20),
                                        child: Text(
                                          "m/s²",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green),
                                        ),
                                      ),

                                      Center(
                                        child: Text("10,00",
                                            style: TextStyle(fontSize: 45,fontFamily: 'Montserrat', fontWeight: FontWeight.bold)
                                        ),
                                      )
                                    ],
                                  )

                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Container(
                            margin: EdgeInsets.only(left: 5),
//                            color: Colors.black12,
                            child:  Material(
                              color: Colors.white,
                              shadowColor: Colors.white70,
                              elevation: 10,

                              child: Container(
                                  height: 150,
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(top: 20),
                                        alignment: Alignment.topCenter,
                                        child: Text("TEMPO", style: TextStyle(color: Colors.black54,fontSize: 15, fontFamily: 'Montserrat' ,
                                          fontWeight: FontWeight.bold,),),
                                      ),
                                      Container(
                                        alignment:Alignment.centerRight,
                                        padding: EdgeInsets.only(right: 10,bottom: 20),
                                        child: Text(
                                          "ms",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green),
                                        ),
                                      ),

                                      Center(
                                        child: Text("0.45",
                                            style: TextStyle(fontSize: 45,fontFamily: 'Montserrat', fontWeight: FontWeight.bold)
                                        ),
                                      )
                                    ],
                                  )

                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(left: 8, top: 10, right: 8, bottom: 20),
                      height: 50,
                      child: InkWell(
                        onTap: () {
                        },
                        child: Material(
                          borderRadius: BorderRadius.circular(20),
                          shadowColor: Colors.greenAccent,
                          color: Colors.green,
                          elevation: 7,
                          child: Center(
                            child: Text(
                              "GRÁFICOS",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat'
                              ),
                            ),
                          ),
                        ),
                      )
                  ),
                ],
              ),
            ),
          )
     ])
    )
    );
    }
}





