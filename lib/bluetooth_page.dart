import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
//import 'package:flutter_blue_plus/flutter_blue_plus.dart';
//import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothPage extends StatelessWidget{
  BluetoothPage({super.key});

  void onPressed() async {
    debugPrint("onPressed start");

    // bool ava = await FlutterBlue.instance.isAvailable;
    // bool on = await FlutterBlue.instance.isOn;
    // print(ava);
    // print(on);

    //FlutterBlue flutterBlue = FlutterBlue.instance;
    //flutterBlue.startScan(timeout: Duration(seconds: 5));

    // BT接続中だが取得が出来ない
    List<BluetoothDevice> connectedSystemDevises = await FlutterBlue.instance.connectedDevices;
    //List<BluetoothDevice> connectedSystemDevises = await FlutterBluePlus.connectedSystemDevices;
    for (var d in connectedSystemDevises) {
      debugPrint("1");
      await d.connect();
      List<BluetoothService> services = await d.discoverServices();
      services.forEach((s) {
        print(s);
      });
      debugPrint("2");
    }


    //FlutterBlue.instance.startScan(timeout: Duration(seconds: 3));
    //List<BluetoothDevice> connectedDevices = await FlutterBlue.instance.connectedDevices;

    // var timeout = 5;
    // fb.scan(timeout: Duration(seconds: timeout),)
    //     .listen((scanResult) {
    //       debugPrint(scanResult.toString());
    //     });

    debugPrint("onPressed end");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text("BluetoothPage"),
              ElevatedButton(
                  onPressed: onPressed,
                  child: const Icon(Icons.add)
              ),
          ]
       )
     ),
    );
  }
}