import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
//import 'package:flutter_blue_plus/flutter_blue_plus.dart';
//import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothPage extends StatelessWidget{
  BluetoothPage({super.key});

  void onPressed() async {
    debugPrint("onPressed start");
    FlutterBlue flutterBlue = FlutterBlue.instance;
    flutterBlue.startScan(timeout: Duration(seconds: 5));

    flutterBlue.scanResults.listen((result) async{
      for(ScanResult r in result){
        if(r.advertisementData.connectable) {
          r.device.state.listen((state) async{
            if(state == BluetoothDeviceState.disconnected){
              //接続
              await r.device.connect().then((value) {
                print("■connect");
                print("localName:${r.advertisementData.localName}");
                print("serviceData:${r.advertisementData.serviceData}");
                print("manufacturerData:${r.advertisementData.manufacturerData}");
                print("serviceUuids:${r.advertisementData.serviceUuids}");
              });
            }

            if(state == BluetoothDeviceState.connected){
              print("★coneected");
              print("localName:${r.advertisementData.localName}");
              print("serviceData:${r.advertisementData.serviceData}");
              print("manufacturerData:${r.advertisementData.manufacturerData}");
              print("serviceUuids:${r.advertisementData.serviceUuids}");
            }
          });
        }
      }
    });

    // BT接続中だが取得が出来ない。Scanしないと接続できない。
    List<BluetoothDevice> connectedSystemDevises = await FlutterBlue.instance.connectedDevices;
    // //List<BluetoothDevice> connectedSystemDevises = await FlutterBluePlus.connectedSystemDevices;
    for (var d in connectedSystemDevises) {
       List<BluetoothService> services = await d.discoverServices();
       services.forEach((s) {
         print("deviceId:${s.deviceId}");
         print("uuid:${s.uuid}");
         print("isPrimary:${s.isPrimary}");
         print("■characteristics start■");
         print("authenticatedSignedWrites:${s.characteristics.first.properties.authenticatedSignedWrites}");
         print("broadcast:${s.characteristics.first.properties.broadcast}");
         print("extendedProperties:${s.characteristics.first.properties.extendedProperties}");
         print("indicate:${s.characteristics.first.properties.indicate}");
         print("indicateEncryptionRequired:${s.characteristics.first.properties.indicateEncryptionRequired}");
         print("notify:${s.characteristics.first.properties.notify}");
         print("notifyEncryptionRequired:${s.characteristics.first.properties.notifyEncryptionRequired}");
         print("read:${s.characteristics.first.properties.read}");
         print("write:${s.characteristics.first.properties.write}");
         print("writeWithoutResponse:${s.characteristics.first.properties.writeWithoutResponse}");
         print("■characteristics end■");
       });
    //   debugPrint("2");
      d.disconnect();
     }
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