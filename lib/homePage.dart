import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
//import 'package:flutter_blue/flutter_blue.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
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
          });

          break;

        case FlutterBluetoothSerial.DISCONNECTED:
          setState(() {
            _connected = false;
            _pressed = false;
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
      resizeToAvoidBottomPadding: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[


          SizedBox(height: 100),

          Container(
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 40),
                  child: Center(
                    child: Text(
                      "Dispositivos:",
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),

                ),
                SizedBox(height: 40,),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 100, 20, 0),

                  child: DropdownButton(
                    items: _getDeviceItems(),
                    onChanged: (value) => setState(() => _device = value),
                    value: _device,
                    isExpanded: true,
                  ),
                ),
                SizedBox(height: 40,),

              ],
            ),
          ),

          SizedBox(height: 100,),
          Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              height: 40,
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
          SizedBox(height: 110),
          Container(
            child: Stack(
              children: <Widget>[
                IconButton(
                  padding: EdgeInsets.fromLTRB(280, 50, 0, 0),
                  icon: Icon(Icons.arrow_forward_ios),
                  iconSize: 60,
                  tooltip: 'Voltar',
                  color: Colors.green,
                  onPressed: () {
                    if(_connected == true){
                      print("Próximo");
                      Navigator.of(context).pushNamed('/showData');
                    }else{
                      print("Nadaa");
                    }


                  },

                ),

                Container(
                  padding: EdgeInsets.fromLTRB(240, 93, 0, 0),
                  child: Text(
                    "Próximo",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}