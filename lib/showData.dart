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
//      resizeToAvoidBottomPadding: false,
      body: Column(
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
                    alignment: Alignment(1, 0),
//                    color: Colors.white70,
                    child: Container(
                      width: 100,
                      color: Colors.white70,
                      child: Text(
                        "Lançamentos: "+ contador.toString(),
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
                          child: Text(
                            _gravidadeFinal.toStringAsFixed(2),
                            style:
                            TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(270, 55, 0, 0),
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
              margin: const EdgeInsets.only(left: 8, top: 80, right: 8, bottom: 0),
//              color: Colors.black,
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
            margin: const EdgeInsets.only(left: 0, top: 80, right: 0, bottom: 0),
            child: InkWell(
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
            ),
          )
        ],
      ),
    );
  }
}
