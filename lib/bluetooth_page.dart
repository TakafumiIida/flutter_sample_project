import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_blue/flutter_blue.dart';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_audio_capture/flutter_audio_capture.dart';
import 'package:audio_session/audio_session.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:audio_streamer/audio_streamer.dart';

class BluetoothPage extends StatelessWidget{
  BluetoothPage({super.key});
  FlutterAudioCapture audioPlugin = new FlutterAudioCapture();
  stt.SpeechToText speech = stt.SpeechToText();
  final streamer = AudioStreamer();
  int? sampleRate;
  bool isRecording = false;
  List<double> audio = [];
  List<double>? latestBuffer;
  double? recordingTime;
  StreamSubscription<List<double>>? audioSubscription;

  void input(Uint8List data){
    print("★★★★★★input★★★★★★★★★★");
    print(data);
  }

  void stop(){
    print("stop");
    speech.stop();
  }

  void resultListener(SpeechRecognitionResult result) {
    print("resultListener");
  }

  void errorListener(SpeechRecognitionError error) {
    print("errorListener");
  }

  void statusListener(String status) {
    print("status:$status");
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
      });
    } catch (PlatformException) {
      print("error");
    }

    debugPrint("onPressed end");
  }

  void onSpeechStart() async{
    print("onSpeech Start");
    await audioPlugin.start(onSpeechListen, onError, sampleRate: 16000, bufferSize: 3000);
  }

  void onSpeechListen(dynamic obj) {
    print("listen start");
    var buffer = Float64List.fromList(obj.cast<double>());
    print(buffer);
  }

  void onError(Object e) {
    print("onError:$e");
  }

  void onSpeechStop() async {
    print("onSpeech End");
    await audioPlugin.stop();
    speech.stop();
  }

  //音声テキスト変換
  void speak() async {
    bool available = await speech.initialize(onError: onError, onStatus: statusListener);
    if(available) {
      print("available");
      await speech.listen(onResult: (result) {
        print("speech listen:${result.recognizedWords}");
      });
    } else {
      print("not available");
    }
  }

  void onAudio(List<double> buffer) async {
    print("onAudio");
    audio.addAll(buffer);
    sampleRate ??= await AudioStreamer().actualSampleRate;
    recordingTime = audio.length / sampleRate!;
    latestBuffer = buffer;
    print(buffer);
  }

  void onStop() async {
    audioSubscription?.cancel();
    isRecording = false;
  }

  void handleError(PlatformException error) {
    print(error);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text("BluetoothPage"),
              //Bluetooth接続
              ElevatedButton(
                  onPressed: onPressed,
                  child: const Icon(Icons.add)
              ),
              //音声テキスト変換
              ElevatedButton(
                  onPressed: speak,
                  child: const Icon(Icons.mic)),
              //音声バイナリ化Start
              ElevatedButton(
                  onPressed: ()async{
                    try{
                      AudioStreamer().sampleRate = 22100;
                      audioSubscription = AudioStreamer().audioStream.listen(onAudio, onError: handleError);
                    } catch(error) {
                      print("error:$error");
                    }
                  },
                child: const Icon(Icons.mic)),
              //音声バイナリ化Stop
              ElevatedButton(
                  onPressed: onStop,
                  child: const Icon(Icons.mic_off))
          ]
       )
     ),
    );
  }
}