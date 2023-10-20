import 'dart:io'; //Platform.isAndroidの利用のため
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'package:camera/camera.dart';

import 'list_page.dart'; //別ファイルになる場合はimport必要
import 'bluetooth_page.dart';
import 'camera_page.dart';
import 'barcode_scan_page.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
//import 'package:device_info_plus/device_info_plus.dart';
import 'package:device_info/device_info.dart' as di;

void main() {
  if(Platform.isAndroid) {
    WidgetsFlutterBinding.ensureInitialized();
    // コンソールに下記が出るがbluetooth使えてる
    // No permissions found in manifest
    // Bluetooth permission missing in manifest メッセージが出るけど使えてる？Android10だと表示されない。
    [
      Permission.location,
      Permission.storage,
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      // Permission.bluetoothAdvertise,
      Permission.camera,
      Permission.microphone,
      Permission.phone,
    ].request().then((status) async {
      //final cameras = await availableCameras();
      //final firstCamera = cameras.first;

      //runApp(MyApp(camera: firstCamera));
      runApp(MyApp());
    });
  } else if (Platform.isWindows) {
    runApp(MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    //required this.camera,
    }) : super(key: key);
  //final CameraDescription camera;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigoAccent),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("ja", "JP"),
      ],
      home: DefaultTabController(
        length:5,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Flutter Demo Page"),
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
                child: MyHomePage(title: "Flutter Demo Home Page"),
              ),
              Tab(
                child: ListPage(),
              ),
              Tab(
                child: BluetoothPage(),
              ),
              Tab(
                //child: CameraPage(camera: camera),
                child: CameraPage(),
              ),
              Tab(
                child: BarcodeScanPage(),
              )
            ],
          )
        ),
      )
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  //device_info_plusではandroidIdが取得できないので、device_infoで取得
  //androidIdではなくidがユニークならidでもOK.ユニークに見えない・・・
  //Windowsはdevice_info_plusで確認すること
  final di.DeviceInfoPlugin _deviceInfo = di.DeviceInfoPlugin();
  String? uuid = "";

  void _incrementCounter() async {
    di.AndroidDeviceInfo info = await _deviceInfo.androidInfo;
    setState(() {
      if(info.id != null) {
        uuid = info.androidId;
      }
      _counter++;
    });
  }

  // buildはUI処理を記載
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   title: Text(widget.title),
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // ElevatedButton(
            //   child: const Text("next page"),
            //   onPressed: (){
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => ListPage()),
            //     );
            // },),
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Android ID:"),
                Text(uuid!),
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
                      title: Text("Title"),
                      content: Text("content"),
                      actions:<Widget>[
                        TextButton(
                          child: Text("Cancel"),
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
              onPressed: _incrementCounter,
              tooltip: 'Increment',
              child: const Icon(Icons.add),
          ), // This trailing comma makes auto-formatting nicer for build methods.
          ]
        )
    );
  }
}
