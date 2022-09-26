import 'dart:developer';

import 'package:firebase_orders_flutter/pages/testprint.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/services.dart';

class impresoraSQFlite extends StatefulWidget {
  const impresoraSQFlite({
    Key? key,
    required double ancho,
    required double alto,
  })  : _ancho = ancho,
        _alto = alto,
        super(key: key);
  final double _ancho;
  final double _alto;

  @override
  _impresoraSQFliteState createState() => _impresoraSQFliteState();
}

class _impresoraSQFliteState extends State<impresoraSQFlite> {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _device;
  bool _connected = false;
  TestPrint testPrint = TestPrint();
  String message = '';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    bool? isConnected = await bluetooth.isConnected;
    List<BluetoothDevice> devices = [];
    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {}

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          setState(() {
            _connected = true;
            log("bluetooth device state: connected");
            message = 'Dispositivo bluetooth conectado.';
          });
          break;
        case BlueThermalPrinter.DISCONNECTED:
          setState(() {
            _connected = false;
            log("bluetooth device state: disconnected");
            message = 'Dispositivo bluetooth desconectado.';
          });
          break;
        case BlueThermalPrinter.DISCONNECT_REQUESTED:
          setState(() {
            _connected = false;
            log("bluetooth device state: disconnect requested");
            message = 'Dispositivo bluetooth desc. sin respuesta.';
          });
          break;
        case BlueThermalPrinter.STATE_TURNING_OFF:
          setState(() {
            _connected = false;
            log("bluetooth device state: bluetooth turning off");
            message = 'Dispositivo bluetooth rec. apagado.';
          });
          break;
        case BlueThermalPrinter.STATE_OFF:
          setState(() {
            _connected = false;
            log("bluetooth device state: bluetooth off");
            message = 'Dispositivo bluetooth apagado.';
          });
          break;
        case BlueThermalPrinter.STATE_ON:
          setState(() {
            _connected = false;
            log("bluetooth device state: bluetooth on");
            message = 'Dispositivo bluetooth encendido.';
          });
          break;
        case BlueThermalPrinter.STATE_TURNING_ON:
          setState(() {
            _connected = false;
            log("bluetooth device state: bluetooth turning on");
            message = 'Dispositivo bluetooth rec. encendido.';
          });
          break;
        case BlueThermalPrinter.ERROR:
          setState(() {
            _connected = false;
            log("bluetooth device state: error");
            message = 'Dispositivo bluetooth error.';
          });
          break;
        default:
          log(state.toString());
          break;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message.toString())),
      );
    });

    if (!mounted) return;
    setState(() {
      _devices = devices;
    });

    if (isConnected == true) {
      setState(() {
        _connected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.pink.withOpacity(.3),
      width: widget._ancho,
      height: widget._alto,
      child: AlertDialog(
        title: const Center(
            child: Text(
          "Conectar a impresora bluetooth",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.pink, fontSize: 22),
        )),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 30,
                  )),
              IconButton(
                  onPressed: () {
                    TestPrint().test();
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.cast_connected_rounded, size: 30))
            ],
          )
        ],
        content: Container(
          width: widget._ancho * .9,
          height: widget._alto * .9,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'Device:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Expanded(
                      child: DropdownButton(
                        items: _getDeviceItems(),
                        onChanged: (BluetoothDevice? value) =>
                            setState(() => _device = value),
                        value: _device,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.pink),
                      onPressed: () {
                        initPlatformState();
                      },
                      child: const Text(
                        'Refresh',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: _connected ? Colors.red : Colors.green),
                      onPressed: _connected ? _disconnect : _connect,
                      child: Text(
                        _connected ? 'Disconnect' : 'Connect',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                // Padding(
                //   padding:
                //       const EdgeInsets.only(left: 10.0, right: 10.0, top: 50),
                //   child: ElevatedButton(
                //     style: ElevatedButton.styleFrom(primary: Colors.brown),
                //     onPressed: () {
                //       // final orden = Neworden(cantidad: 11,nombre: "nose",precio: 11);
                //       // testPrint.sample(orden);
                //     },
                //     child: const Text('PRINT TEST',
                //         style: TextStyle(color: Colors.white)),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devices.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      _devices.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name ?? ""),
          value: device,
        ));
      });
    }
    return items;
  }

  void _connect() {
    if (_device != null) {
      log("entre al conect");
      bluetooth.isConnected.then((isConnected) {
        log("entre al conect x2 " + isConnected.toString());
        if (!isConnected!) {
          log("entre al conect x3");
          bluetooth.connect(_device!).catchError((error) {
            log("error");
            setState(() => _connected = false);
          });
          setState(() => _connected = true);
        } else {
          log("No se porque no conecto :(");
        }
      });
    } else {
      show('No device selected.');
    }
  }

  void _disconnect() {
    bluetooth.disconnect();
    setState(() => _connected = false);
  }

  Future show(
    String message, {
    Duration duration: const Duration(seconds: 3),
  }) async {
    await new Future.delayed(new Duration(milliseconds: 100));
    ScaffoldMessenger.of(context).showSnackBar(
      new SnackBar(
        content: new Text(
          message,
          style: new TextStyle(
            color: Colors.white,
          ),
        ),
        duration: duration,
      ),
    );
  }
}
