import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
//import 'package:flutter_blue/flutter_blue.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}


class LinearSales {
  final double year;
  final double sales;


  LinearSales(this.year, this.sales);
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static final TextEditingController _text = new TextEditingController();
  // Get the instance of the bluetooth
  FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;

  // Define some variables, which will be required later
  List<BluetoothDevice> _devicesList = [];
  BluetoothDevice _device;
  bool _connected = false;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    bluetoothConnectionState();
    _isConnected();
  }

  //Verify connectivity when invoke the initState method
  void _isConnected(){
    bluetooth.isConnected.then((isConnected) {
      if (isConnected) {
        _connected = true;
      }else{
        _connected = false;
      }
    });
  }

  // We are using async callback for using await
  Future<void> bluetoothConnectionState() async {
    List<BluetoothDevice> devices = [];

    // To get the list of paired devices
    try {
      devices = await bluetooth.getBondedDevices();
    } catch (e) {
      print("Error");
    }

    // For knowing when bluetooth is connected and when disconnected
    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case FlutterBluetoothSerial.CONNECTED:
          setState(() {
            _connected = true;
            _pressed = false;
            Navigator.of(context).pushNamed('/showData');
          });

          break;

        case FlutterBluetoothSerial.DISCONNECTED:
          setState(() {
            _connected = false;
            _pressed = false;
            Navigator.of(context).pushNamed('/homePage');
          });
          break;

        default:
          print(state);
          break;
      }
    });


    // It is an error to call [setState] unless [mounted] is true.
    if (!mounted) {
      return;
    }

    // Store the [devices] list in the [_devicesList] for accessing
    // the list outside this class
    setState(() {
      _devicesList = devices;
    });
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devicesList.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      _devicesList.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name),
          value: device,
        ));
      });
    }
    return items;
  }

  bool _connect() {
    if (_device == null) {
      print("No devices");
    } else {
      bluetooth.isConnected.then((isConnected) {
        if (!isConnected) {
          bluetooth
              .connect(_device)
              .timeout(Duration(seconds: 10))
              .catchError((error) {
            setState(() => _pressed = false);
          });
          setState(() => _pressed = true);
          return false;
        }
        return true;
      });
    }
    return false;
  }

  // Method to disconnect bluetooth
  void _disconnect() {
    bluetooth.disconnect();
    setState(() => _pressed = true);
  }



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
//      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      margin: const EdgeInsets.only(top: 80),
                      //              color: Colors.blue,
                      child: Text(
                        "Gravity Sensor",
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),

                      )
                  ),
                ],
              ),
            ],
          ),


          Center(
              child: Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
//                color: Colors.blue,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(bottom: 100),
                        height: 20,
                        child: Center(
                            child: Text("Dispositivos")
                          ),
                      ),
                    ],
                  )


              )
          ),
          Center(
              child: Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
//                color: Colors.blue,
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: 50,
                      child: Material(
                        elevation: 2,
                        child: Center(
                          child: DropdownButton(
                            style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold, color: Colors.black),
                            items: _getDeviceItems(),
                            onChanged: (value) => setState(() => _device = value),
                            value: _device,
                            isExpanded: true,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              )
          ),

            Center(
              child: Container(
                margin: const EdgeInsets.only(left: 8, right: 8),
                alignment: Alignment(0.0, 0.95),
                child: Container(height: 50,
                  child: InkWell(
                    onTap: () {
                      _connected ? _disconnect() : _connect();

                    },
                    child: Material(
                      borderRadius: BorderRadius.circular(20),
                      shadowColor: Colors.greenAccent,
                      color: Colors.green,
                      elevation: 7,
                      child: Center(
                        child: Text(
                          _connected ? 'DESCONECTAR' : 'CONECTAR',
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
            )
            )


        ],
      )

//        Column(
//        children: <Widget>[
//
//          Container(
//            alignment: Alignment.topLeft,
//              margin: const EdgeInsets.only(left: 20, top: 80, right: 0, bottom: 0),
////              color: Colors.blue,
//                child: Text(
//                  "Dispositivos:",
//                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//
//              )
//          ),
//          Center(
//            child: Container(
//              color: Colors.blue,
//              child: Text("asd"),
//            ),
//          )
          /*Container(
            margin: const EdgeInsets.only(left: 8, top: 80, right: 8, bottom: 0),
            height: 50,
            child: Material(
              borderRadius: BorderRadius.circular(2),
                  elevation: 1,
                child: Center(
                  child: DropdownButton(
                    style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold, color: Colors.black),
                    items: _getDeviceItems(),
                    onChanged: (value) => setState(() => _device = value),
                    value: _device,
                    isExpanded: true,
                  ),
                ),
              ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 8, top: 80, right: 8, bottom: 0),
              height: 50,
              child: InkWell(
                onTap: () {
                  _connected ? _disconnect() : _connect();
                },
                child: Material(
                  borderRadius: BorderRadius.circular(20),
                  shadowColor: Colors.greenAccent,
                  color: Colors.green,
                  elevation: 7,
                  child: Center(
                    child: Text(
                      _connected ? 'DESCONECTAR' : 'CONECTAR',
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
            margin: const EdgeInsets.only(left: 0, top: 150, right: 0, bottom: 0),
//            color: Colors.green,
            alignment: Alignment(0.9, 0),
            child:  Container(
                height: 60,
                width: 120,
//                color: Colors.blue,
                child: InkWell(
                    onTap: () {
//                  _connected ? _disconnect() : _connect();
//                      print("proximo");
                      Navigator.of(context).pushNamed('/showData');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Próximo",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.green,
                          size: 60.0,
                        )

                      ],
                    )
                )
            ),
          )*/



    );
  }

}