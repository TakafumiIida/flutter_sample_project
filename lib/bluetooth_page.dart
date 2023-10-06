import 'dart:typed_data';
import 'package:flutter/material.dart';
//import 'package:flutter_blue/flutter_blue.dart';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothPage extends StatelessWidget{
  BluetoothPage({super.key});

  void input(Uint8List data){
    print("★★★★★★input★★★★★★★★★★");
  }

  void onPressed() async {
    debugPrint("onPressed start");

    FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;
    List<BluetoothDevice> deviceList = [];
    try{
      deviceList = await bluetooth.getBondedDevices();

      deviceList.forEach((device) {
        if(device.isConnected) {
          print("■Device Info");
          print("name:${device.name}");
          print("bondState:${device.bondState}");
          print("isConnected:${device.isConnected}");
          print("isBonded:${device.isBonded}");
          print("address:${device.address}");
          print("type:${device.type}");

          BluetoothConnection.toAddress(device.address).then((connection){
            print("■connect start");
            print("isConnected:${connection.isConnected}");
            connection.input!.listen(input).onDone(() {
              print("■connection Close");
            });
            //outputは不要
            // List<int> list = 'xxx'.codeUnits;
            // Uint8List data = Uint8List.fromList(list);
            // connection!.output.add(data);
            print("■connection end");
          }).catchError((error) {
            print("〇error");
          });

        }
      });
    } catch (PlatformException) {
      print("error");
    }
/*
    FlutterBlue flutterBlue = FlutterBlue.instance;
    flutterBlue.startScan(timeout: Duration(seconds: 5));

    flutterBlue.scanResults.listen((result) async{
      for(ScanResult r in result){
        if(r.advertisementData.connectable) {
          r.device.state.listen((state) async{
            if(state == BluetoothDeviceState.disconnected){
              //接続
              try {
                await r.device.connect().then((value) {
                  print("■connect");
                  //print("localName:${r.advertisementData.localName}");
                  // print("serviceData:${r.advertisementData.serviceData}");
                  // print("manufacturerData:${r.advertisementData.manufacturerData}");
                  print("serviceUuids:${r.advertisementData.serviceUuids}");
                });
              } catch (PlatformException){
                //already connect exceptionになることがある。タイミングの問題？
                print("●connect Exception");
              }
            }

            if(state == BluetoothDeviceState.connected){
              print("■coneected");
              // print("localName:${r.advertisementData.localName}");
              // print("serviceData:${r.advertisementData.serviceData}");
              // print("manufacturerData:${r.advertisementData.manufacturerData}");
              // print("serviceUuids:${r.advertisementData.serviceUuids}");
            }
          });
        }
      }
    });

    // BT接続中だが取得が出来ない。Scanしないと接続できない。
    List<BluetoothDevice> connectedSystemDevises = await FlutterBlue.instance.connectedDevices;
    // //List<BluetoothDevice> connectedSystemDevises = await FlutterBluePlus.connectedSystemDevices;
    for (var d in connectedSystemDevises) {
      print("★connectedSystemDevise★");
       List<BluetoothService> services = await d.discoverServices();
       services.forEach((s) {
         print("★service★");
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

 */
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