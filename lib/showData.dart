import 'dart:async';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:page_indicator/page_indicator.dart';

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:charts_flutter/src/text_element.dart';
import 'package:charts_flutter/src/text_style.dart' as style;


import 'Gravity.dart';

class ShowData extends StatefulWidget {
  @override
  _ShowDataState createState() => new _ShowDataState();
}

String selectedTooltip;

class ScatterPlot {
  final double tempo;
  final double gravidade;
  final int radius;

  ScatterPlot(this.tempo, this.gravidade, this.radius);
}


class _ShowDataState extends State<ShowData> {
  PageController _pageController;

  FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;
  static final TextEditingController _text = new TextEditingController();
  static final TextEditingController _contador = new TextEditingController();

  var dadosTable = new List<Gravity>();


  bool _connected = false;
  int contador = 0;
  double tempo = 0;
  double _gravidadeFinal = 0;
  bool control = false;
  int amostras = 4;
  bool aceitar = true;




  @override
  void initState() {
    super.initState();
    initPlatformState();
    _isConnected();
    //Inicia com 0
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }


  void resetCalc(){
    print("resetCall");
    gravity.setValues(0, 0);
    contador = 0;
    _gravidadeFinal = 0;
    gravity.clearData();
    control = false;
  }

  void aceitarLancamento(){
      print("Finalizar");
      amostras = contador;
  }

  void negarLancamento(){
    print("negar");
    gravity.dados.removeLast();
    gravity.clearLast(--contador);
    for(int i = 0; i < gravity.dados.length; i++){
      print(gravity.dados.elementAt(i).gravidade);
    }
  }


  Future<void> initPlatformState() async {
    bluetooth.onRead().listen((msg) {
      setState(() {
//        print('Read: $msg');
        _text.text += msg;
        tempo = double.parse(_text.text.toString());

        _text.text = "";

        //Espera um tempo 0 e contador 0 resolvendo problema de lista vazia no inicio


        if(tempo > 0 && contador < amostras){
          print(tempo);
          print(contador);
          gravity.setValues(++contador, tempo);
          for(int i = 0; i < gravity.dados.length; i++){
            print(gravity.dados.elementAt(i).gravidade);
          }

        }

      });
    });
  }

  void _isConnected() {
    bluetooth.isConnected.then((isConnected) {
      if (!isConnected) {
        print("Desconectado");
        _connected = false;
      } else {
        _connected = true;
        print("conectado");
      }
    });
  }

  var gravity = Gravity();
//class Episode5State extends State<Episode5> {
  Widget bodyData() => DataTable(
      columns: <DataColumn>[
        DataColumn(
          label: Text("Nº",style: TextStyle()),
          numeric: true,

        ),
        DataColumn(
          label: Text("T (ms)", style: TextStyle(fontSize: 10),),
          numeric: true,

        ),
        DataColumn(
          label: Text("G (m/s²)",  style: TextStyle(fontSize: 10)),
          numeric: true,
        ),
      ],
//12.76, 12.76
      rows: dadosTable
          .map(
            (name) => DataRow(
          cells: [
            DataCell(
              Text(name.lancamento.toString(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
//              showEditIcon: false,
              placeholder: false,
            ),
            DataCell(
              Text(name.tempo.toString(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
//              showEditIcon: false,
              placeholder: false,
            ),
            DataCell(
              Text(name.gravidade.toStringAsFixed(2), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
//              showEditIcon: false,
              placeholder: false,
            )
          ],
        ),
      )
          .toList());

  @override
  Widget build(BuildContext context) {

    var scatterPlot = new List<ScatterPlot>();

    var series1 = [
      new Series(
        id: 'Sales',
        colorFn: (_, __) => MaterialPalette.blue.shadeDefault,
        domainFn: (Gravity _gravity, _) => _gravity.lancamento,
        measureFn: (Gravity _gravity, _) => _gravity.gravidade,
        data: gravity.dados,
      ),
    ];

    var series2 = [
      new Series(
        id: 'Sales',
        colorFn: (_, __) => MaterialPalette.blue.shadeDefault,
        domainFn: (Gravity _gravity, _) => _gravity.lancamento,
        measureFn: (Gravity _gravity, _) => _gravity.tempo,
        data: gravity.dados,
      ),
    ];

    var series3 = [
      new Series(
        id: 'Sales',
        colorFn: (_, __) => MaterialPalette.blue.shadeDefault,
        domainFn: (Gravity _gravity, _) => _gravity.gravidade,
        measureFn: (Gravity _gravity, _) => _gravity.tempo,
        radiusPxFn: (Gravity _gravity, _) => 3,
        data: gravity.dados,
      )
    ];

    //10 número de amostras
    if(gravity.lancamento == amostras && control == false){
      control = true;
      _gravidadeFinal = gravity.calcGravidadeMedia();
      print("Gravidade média 2 : ${gravity.calcGravidadeMedia()}");
      gravity.sortTempo();
      gravity.sortGravidade();
      dadosTable = gravity.dados;
//      print(gravity.medianaTempo().toString());
//      print(gravity.medianaGravidade().toString());
    }

    return new Scaffold(
//      resizeToAvoidBottomPadding: false,
        body: Center(
          child: Container(
            child: PageIndicatorContainer(
              pageView: PageView(
                controller: _pageController,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(left: 0, top: 40, right: 0, bottom: 0),
//            color: Colors.blue,
                        child:  Row(
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: Container(
//                    color: Colors.grey,
                                  child: Container(
                                    width: 20,
                                    child: IconButton(
                                      icon: Icon(Icons.arrow_back_ios),
                                      iconSize: 40,
                                      color: Colors.green,
                                      tooltip: 'Voltar',
                                      onPressed: () {
                                        print("Voltar");
                                        Navigator.of(context).pushNamed('/homePage');
                                        _connected = true;
                                      },
                                    ),
                                  )
                              ),
                            ),
                            Expanded(
                              flex: 9,
                              child: Container(
                                alignment: Alignment(0.9, 0),

                                child: Container(
                                  child: Text(
                                    "Lançamentos: "+ "$contador",
                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 0, top: 100, right: 0, bottom: 0),
//            color: Colors.lightBlueAccent,
                        child: Stack(
                          children: <Widget>[
                            Container(
                                margin: const EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0),
//                  height: 30,
                                child: Center(
                                  child: Text(
                                    "Aceleração da gravidade:",
                                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                                  ),
                                )
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 0, top: 50, right: 0, bottom: 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
//                        color: Colors.red,
                                    child: Center(
                                      child: Text(gravity.dados.length == 0 ? "0.00" : contador == amostras ? _gravidadeFinal.toStringAsFixed(2) : gravity.dados.last.gravidade.toStringAsFixed(2),
//                                        _gravidadeFinal.toStringAsFixed(2),
                                        style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              margin: const EdgeInsets.only(left: 0, top: 55, right: 10, bottom: 0),
//                              color: Colors.blueGrey,
//                              padding: EdgeInsets.fromLTRB(270, 55, 0, 0),
                              child: Text(
                                "m/s²",
                                style: TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.only(left: 6, top: 50, right: 6, bottom: 0),
//              color: Colors.black,
                          height: 50,
                          child: InkWell(
                            onTap: () {
                              if (_pageController.hasClients) {
                                _pageController.animateToPage(
                                  1,
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                            child: Material(
                              borderRadius: BorderRadius.circular(20),
                              shadowColor: Colors.greenAccent,
                              color: Colors.green,
                              elevation: 7,
                              child: Center(
                                child: Text(
                                  "DADOS ESTATÍSTICOS",
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
                      Container(
                        margin: const EdgeInsets.only(left: 10, top: 40, right: 10, bottom: 10),
//                    color: Colors.lightGreen,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 5,
                              child: Container(

                                height: 50,
                                margin: EdgeInsets.only(right: 5),
//                            color: Colors.black12,
                                child:  Material(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                  shadowColor: Colors.white70,
                                  elevation: 10,

                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            negarLancamento();

                                          });
                                        },
                                        child: Material(
                                          borderRadius: BorderRadius.circular(20),
                                          shadowColor: Colors.greenAccent,
                                          color: Colors.redAccent,
                                          elevation: 7,
                                          child: Center(
                                            child: Text(
                                              "NEGAR",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Montserrat'
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ),

                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Container(
                                height: 50,
                                margin: EdgeInsets.only(left: 5),
//                            color: Colors.black12,
                                child:  Material(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                  shadowColor: Colors.white70,
                                  elevation: 10,

                                  child: Container(
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            aceitarLancamento();
                                          });

                                        },
                                        child: Material(
                                          borderRadius: BorderRadius.circular(20),
                                          shadowColor: Colors.greenAccent,
                                          color: Colors.green,
                                          elevation: 7,
                                          child: Center(
                                            child: Text(
                                              "FINALIZAR",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Montserrat'
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 0, top: 40, right: 0, bottom: 0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              resetCalc();
                            });


                          },
                          child: Text(
                            'Calcular novamente',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.green,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      )
                    ],
                  ),
                  SingleChildScrollView(

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
                                            if (_pageController.hasClients) {
                                              _pageController.animateToPage(
                                                0,
                                                duration: const Duration(milliseconds: 400),
                                                curve: Curves.easeInOut,
                                              );
                                            }
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
                                      margin: const EdgeInsets.only(left: 5, top: 8, right: 5, bottom: 10),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Material(
                                                color: Colors.white,
                                                shadowColor: Colors.white70,
                                                elevation: 5,

                                                child: bodyData(),
                                              ),
                                            )
                                          ],
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
                                                          child: Text("GRAVIDADE (m/s²)", style: TextStyle(color: Colors.black54,fontSize: 15, fontFamily: 'Montserrat' ,
                                                            fontWeight: FontWeight.bold,),),
                                                        ),
                                                        Center(
                                                          child: Text(_gravidadeFinal.toStringAsFixed(2),
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
                                                          child: Text("TEMPO (s)", style: TextStyle(color: Colors.black54,fontSize: 15, fontFamily: 'Montserrat' ,
                                                            fontWeight: FontWeight.bold,),),
                                                        ),

                                                        Center(
                                                          child: Text(gravity.tempoMedio().toStringAsFixed(2),
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
                                                          child: Text("GRAVIDADE (m/s²)", style: TextStyle(color: Colors.black54,fontSize: 15, fontFamily: 'Montserrat' ,
                                                            fontWeight: FontWeight.bold,),),
                                                        ),


                                                        Center(
                                                          child: Text(contador < amostras ? "0.00" : gravity.medianaGravidade().toStringAsFixed(2),
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
                                                          child: Text("TEMPO (s)", style: TextStyle(color: Colors.black54,fontSize: 15, fontFamily: 'Montserrat' ,
                                                            fontWeight: FontWeight.bold,),),
                                                        ),

                                                        Center(
                                                          child: Text(contador < amostras ? "0.00" : gravity.medianaTempo().toStringAsFixed(2),
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
                                                          child: Text("GRAVIDADE (m/s²)", style: TextStyle(color: Colors.black54,fontSize: 15, fontFamily: 'Montserrat' ,
                                                            fontWeight: FontWeight.bold,),),
                                                        ),

                                                        Center(
                                                          child: Text(gravity.desvioPadraoGravidade().toStringAsFixed(2),
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
                                                          child: Text("TEMPO (s)", style: TextStyle(color: Colors.black54,fontSize: 15, fontFamily: 'Montserrat' ,
                                                            fontWeight: FontWeight.bold,),),
                                                        ),

                                                        Center(
                                                          child: Text(gravity.desvioPadraoTempo().toStringAsFixed(2),
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
                                        margin: const EdgeInsets.only(left: 8, top: 10, right: 8, bottom: 28),
                                        height: 50,
                                        child: InkWell(
                                          onTap: () {
                                            if (_pageController.hasClients) {
                                              _pageController.animateToPage(
                                              2,
                                                duration: const Duration(milliseconds: 400),
                                                curve: Curves.easeInOut,
                                              );
                                            }
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
                  ),

                  // ################ PAGE 3  #################### //

                  SingleChildScrollView(

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
                                                if (_pageController.hasClients) {
                                                  _pageController.animateToPage(
                                                    1,
                                                    duration: const Duration(milliseconds: 400),
                                                    curve: Curves.easeInOut,
                                                  );
                                                }
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
                                      child: LineChart(series1, animate: false,
                                        behaviors: [
                                          new ChartTitle('Lançamentos',
                                              behaviorPosition: BehaviorPosition.bottom,
                                              titleStyleSpec: TextStyleSpec(fontSize: 11),
                                              titleOutsideJustification:
                                              OutsideJustification.middleDrawArea),
                                          new ChartTitle('Gravidade (m/s²)',
                                              behaviorPosition: BehaviorPosition.start,
                                              titleStyleSpec: TextStyleSpec(fontSize: 11),
                                              titleOutsideJustification:
                                              OutsideJustification.middleDrawArea),
                                          LinePointHighlighter(
                                              symbolRenderer: CustomCircleSymbolRenderer()
                                          )

                                        ],
                                        selectionModels: [
                                          SelectionModelConfig(
                                              changedListener: (SelectionModel model) {
                                                if(model.hasDatumSelection)
                                                  selectedTooltip = model.selectedSeries[0].measureFn(model.selectedDatum[0].index).toString();
                                              }
                                          )
                                        ],
                                        defaultRenderer: LineRendererConfig(includePoints: true),
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
                                      child: LineChart(series2, animate: false,
                                        behaviors: [
                                          new ChartTitle('Lançamentos',
                                              behaviorPosition: BehaviorPosition.bottom,
                                              titleStyleSpec: TextStyleSpec(fontSize: 11),
                                              titleOutsideJustification:
                                              OutsideJustification.middleDrawArea),
                                          new ChartTitle('Tempo (ms)',
                                              behaviorPosition: BehaviorPosition.start,
                                              titleStyleSpec: TextStyleSpec(fontSize: 11),
                                              titleOutsideJustification:
                                              OutsideJustification.middleDrawArea),
                                          LinePointHighlighter(
                                              symbolRenderer: CustomCircleSymbolRenderer()
                                          )

                                        ],
                                        selectionModels: [
                                          SelectionModelConfig(
                                              changedListener: (SelectionModel model) {
                                                if(model.hasDatumSelection)
                                                  selectedTooltip = model.selectedSeries[0].measureFn(model.selectedDatum[0].index).toString();
                                              }
                                          )
                                        ],
                                        defaultRenderer: LineRendererConfig(includePoints: true),
                                      )
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
                                      child: ScatterPlotChart(series3,animate: true,
                                        behaviors: [
                                          new ChartTitle('Gravidade (m/s²)',
                                              behaviorPosition: BehaviorPosition.bottom,
                                              titleStyleSpec: TextStyleSpec(fontSize: 11),
                                              titleOutsideJustification:
                                              OutsideJustification.middleDrawArea),
                                          new ChartTitle('Tempo (ms)',
                                              behaviorPosition: BehaviorPosition.start,
                                              titleStyleSpec: TextStyleSpec(fontSize: 11),
                                              titleOutsideJustification:
                                              OutsideJustification.middleDrawArea),


                                        ],)
                                  ),
                                ),
                              )
                          ),
                          Container(
                              margin: const EdgeInsets.only(left: 8, top:15, right: 8, bottom: 28),
                              height: 50,
                              child: InkWell(
                                onTap: () {
                                  if (_pageController.hasClients) {
                                    _pageController.animateToPage(
                                      1,
                                      duration: const Duration(milliseconds: 400),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                },
                                child: Material(
                                  borderRadius: BorderRadius.circular(20),
                                  shadowColor: Colors.greenAccent,
                                  color: Colors.green,
                                  elevation: 7,
                                  child: Center(
                                    child: Text(
                                      "VOLTAR",
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
                      )
                  )

                ],
              ),
              align: IndicatorAlign.bottom,
              length: 3,
              indicatorSpace: 10.0,
              indicatorColor: Colors.black26,
              indicatorSelectorColor: Colors.green,
              shape: IndicatorShape.circle(size: 6),
            ),
          ),

        )



    );
  }
}


class CustomCircleSymbolRenderer extends CircleSymbolRenderer {
  @override
  void paint(ChartCanvas canvas, Rectangle<num> bounds, {List<int> dashPattern, Color fillColor, Color strokeColor, double strokeWidthPx}) {
    super.paint(canvas, bounds, dashPattern: dashPattern, fillColor: fillColor, strokeColor: strokeColor, strokeWidthPx: strokeWidthPx);

    var textStyle = style.TextStyle();
    textStyle.fontFamily = 'Montserrat';
    textStyle.color = Color.black;
    textStyle.fontSize = 10;
    canvas.drawText(
        TextElement(selectedTooltip, style: textStyle),
        (bounds.left).round(),
        (bounds.top - 28).round()
    );
  }
}


