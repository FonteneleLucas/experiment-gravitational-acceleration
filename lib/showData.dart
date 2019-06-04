import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class ShowData extends StatefulWidget {
  @override
  _ShowDataState createState() => new _ShowDataState();
}

class _ShowDataState extends State<ShowData> {
  FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;
  static final TextEditingController _text = new TextEditingController();
  static final TextEditingController _contador = new TextEditingController();


  bool _connected = false;
  int contador = 0;
  double tempo = 0;
  double h = 1.0;
  double _gravidade = 0;
  double _gravidadeFinal = 0;

  var values = new List(10);
  var time = new List(10);
  var gravidade = new List(10);




  @override
  void initState() {
    super.initState();
    initPlatformState();
    _isConnected();
  }


  void resetCalc(){
    print("resetCall");
    contador = 0;
    _gravidadeFinal = 0;

  }

  void calculoGravidade(){
    if(tempo > 0 && contador < 10){
      time[contador] = tempo;
      gravidade[contador] =  (2*h/(tempo*tempo));
      contador++;
    }

    if(contador == 10){
      double cont = 0;
      for(int i = 0; i < 10;i++){
        cont += gravidade[i];
      }
      _gravidadeFinal = cont/contador;
    }

  }

  Future<void> initPlatformState() async {
    bluetooth.onRead().listen((msg) {
      setState(() {
//        print('Read: $msg');
        _text.text += msg;
        tempo = double.parse(_text.text.toString());
        print(tempo);
        _text.text = "";
        calculoGravidade();
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Stack(
              children: <Widget>[
                IconButton(
                  padding: EdgeInsets.fromLTRB(15, 50, 0, 0),
                  icon: Icon(Icons.arrow_back_ios),
                  tooltip: 'Voltar',
                  onPressed: () {
                    print("Voltar");
                    Navigator.of(context).pushNamed('/homePage');
                    _connected = true;
                  },
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(240, 50, 0, 0),
                  child: Text(
                    "Lançamentos: "+ contador.toString(),
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 40),
          Container(
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(35, 130, 0, 0),
                  child: Text(
                    "Aceleração da gravidade:",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 175, 0, 0),
                  child: Center(
                    child: Text(
                      _gravidadeFinal.toStringAsFixed(2),
                      style:
                          TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(270, 180, 0, 0),
                  child: Text(
                    "m/s²",
                    style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 50,
          ),

          Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              height: 40,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed('/inicialPage');
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
                          fontFamily: 'Montserrat'),
                    ),
                  ),
                ),
              )),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () {
                  resetCalc();
                },
                child: Text(
                  'Calcular novamente',
                  style: TextStyle(
                      color: Colors.green,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
