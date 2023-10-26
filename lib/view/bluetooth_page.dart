import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:audio_session/audio_session.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
//import 'package:speech_to_text/speech_recognition_error.dart';
//import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:audio_streamer/audio_streamer.dart';

@immutable
class BluetoothPage extends StatefulWidget{
  const BluetoothPage({super.key});

  @override
  BluetoothPageState createState() =>  BluetoothPageState();
}

class BluetoothPageState extends State<BluetoothPage> {
  stt.SpeechToText speech = stt.SpeechToText();
  final streamer = AudioStreamer();
  int? sampleRate;
  bool isRecording = false;
  List<double> audio = [];
  List<double>? latestBuffer;
  double recordingTime = 0;
  StreamSubscription<List<double>>? audioSubscription;
  String speechToText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("BluetoothPage"),
                //Bluetooth接続
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                      const Text("接続"),
                      ElevatedButton(
                        onPressed: onPressed,
                        child: const Icon(Icons.add)
                      )
                    ]
                ),
                //音声テキスト変換
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    const Text("音声テキスト化"),
                    ElevatedButton(
                    onPressed: speak,
                    child: const Icon(Icons.mic)),
                  ]
                ),
                //音声バイナリ化ボタン
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("音声バイナリ化"),
                    ElevatedButton(
                      onPressed: isRecording ? onStop : onStart,
                      child: isRecording ? const Icon(Icons.mic_off) : const Icon(Icons.mic)),
                    ]
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    const Text("音声テキスト化："),
                    Text(speechToText)
                  ]
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    Text("録音時間：$recordingTime"),
                    const Text("秒"),
                  ]
                )
              ]
          )
      ),
    );
  }

  void onPressed() async {
    debugPrint("onPressed start");

    FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;
    List<BluetoothDevice> deviceList = [];
    try{
      deviceList = await bluetooth.getBondedDevices();

      for (var device in deviceList) {
        if(device.isConnected) {
          print("■Device Info");
          print("name:${device.name}");
          print("bondState:${device.bondState}");
          print("isConnected:${device.isConnected}");
          print("isBonded:${device.isBonded}");
          print("address:${device.address}");
          print("type:${device.type}");

          BluetoothConnection.toAddress(device.address).then((connection) async{
            print("■connect start");
            print("isConnected:${connection.isConnected}");
            connection.input!.listen(input).onDone(() {
              print("■connection Close");
            });

            //Bluetoothマイク動作には下記２行が必須
            var session = await AudioSession.instance;
            await session.configure(AudioSessionConfiguration.speech());

            print("■connection end");
          }).catchError((error) {
            print("〇error");
          });

        }
      }
    } catch (PlatformException) {
      print("error");
    }

    debugPrint("onPressed end");
  }

  // ボタンイベント取得
  void input(Uint8List data){
    print("★★★★★★input★★★★★★★★★★");
    print(data);
  }

  //音声テキスト変換
  void speak() async {
    bool available = await speech.initialize(
        onStatus: (status) {
          print("status:$status");
        },
        onError: (error) {
          print("onError:$error");
        });

    speechToText = "";

    if(available) {
      print("available");
      await speech.listen(onResult: (result) {
        print("speech listen:${result.recognizedWords}");
        setState(() {
          if(result.recognizedWords.length > 0) {
            speechToText += result.recognizedWords;
          }
        });
      });
    } else {
      print("not available");
    }
  }

  //音声バイナリ化
  void onAudio(List<double> buffer) async{
    print("onAudio");
    audio.addAll(buffer);
    sampleRate ??= await AudioStreamer().actualSampleRate;
    recordingTime = audio.length / sampleRate!;

    setState(() {
      latestBuffer = buffer;
      print("recordingTime:$recordingTime");
      print("audio.length:${audio.length}");
    });
  }

  void onStart() {
    try{
      AudioStreamer().sampleRate = 22100;
      audioSubscription = AudioStreamer().audioStream.listen(onAudio, onError: handleError);
    } catch(error) {
      print("error:$error");
    }
    setState(() => isRecording = true);
  }

  void onStop() async {
    print("onStop");
    audioSubscription?.cancel();

    setState(()=> isRecording = false);
  }

  void handleError(Object obj) {
    print("error:$obj");
  }

}