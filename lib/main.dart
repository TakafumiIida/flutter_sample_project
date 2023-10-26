import 'dart:io'; //Platform.isAndroidの利用のため
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'view/list_page.dart'; //別ファイルになる場合はimport必要
import 'view/bluetooth_page.dart';
import 'view/camera_page.dart';
import 'view/barcode_scan_page.dart';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:device_info/device_info.dart' as di;

 import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  if(Platform.isAndroid) {
    // コンソールに下記が出るがbluetooth使えてる
    // Bluetooth permission missing in manifest メッセージが出るけど使えてる。Android10だと表示されない。
    [
      Permission.location,
      Permission.storage,
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.camera,
      Permission.microphone,
      Permission.phone,
    ].request().then((status) async {
      //runApp(const MyApp());
      runApp(const ProviderScope(child: MyApp()));
    });
  } else if (Platform.isWindows) {
    runApp(const MyApp());
  }

  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigoAccent),
        useMaterial3: true,
      ),
      home: DefaultTabController(
        length:5,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Flutter Demo Page"),
            bottom: const TabBar(
              tabs: [
                Tab(text: "Home Page"),
                Tab(text: "List Page"),
                Tab(text: "Bluetooth Page"),
                Tab(text: "Camera page"),
                Tab(text: "Barcode Scan Page"),
              ]
            )
          ),
          body: TabBarView(
            children: [
              Tab(
                //child: MyHomePage(title: "Flutter Demo Home Page"),
                child: MyHomeHookPage(),
              ),
              const Tab(
                child: ListPage(),
              ),
              const Tab(
                child: BluetoothPage(),
              ),
              const Tab(
                child: CameraPage(),
              ),
              const Tab(
                child: BarcodeScanPage(),
              )
            ],
          )
        ),
      )
    );
  }
}

//Hook用
@immutable
class MyHomeHookPage extends HookWidget {
  MyHomeHookPage({super.key});
  final di.DeviceInfoPlugin _deviceInfo = di.DeviceInfoPlugin();
  //String? uuid = "";

  @override
  Widget build(BuildContext context) {
    final counter = useState<int>(0);
    final uuid = useState<String>("");
    int counterValue = counter.value;

    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   title: Text(widget.title),
      // ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$counterValue',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Android ID:"),
                    Text(uuid.value),
                  ]
              )
            ],
          ),
        ),
        floatingActionButton:
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            title: const Text("Title"),
                            content: const Text("content"),
                            actions:<Widget>[
                              TextButton(
                                child: const Text("Cancel"),
                                onPressed: (){
                                  Navigator.of(context).pop();
                                },
                              ),
                            ]
                        );
                      }
                  );
                },
                child: const Icon(Icons.add_chart),
              ),
              FloatingActionButton(
                onPressed: () async {
                  if(Platform.isAndroid) {
                    di.AndroidDeviceInfo info = await _deviceInfo.androidInfo;
                    uuid.value = info.androidId;
                  } else if(Platform.isWindows){
                    final DeviceInfoPlusWindowsPlugin deviceWindowsInfo = DeviceInfoPlusWindowsPlugin();
                    WindowsDeviceInfo info = deviceWindowsInfo.getInfo();
                    uuid.value = info.deviceId;
                  }
                  //counter.value++;
                  //useStateで取得した変数に入れなおすと保持される
                  counter.value = counter.value + 1;
                },
                tooltip: 'Increment',
                child: const Icon(Icons.add),
              )
            ]
        )
    );
  }
}