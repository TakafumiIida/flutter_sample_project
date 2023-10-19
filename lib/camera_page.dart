import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:heic_to_jpg/heic_to_jpg.dart';

class CameraPage extends StatefulWidget{
  const CameraPage({
    Key? key,
    required this.camera,
  }) : super(key: key);
  final CameraDescription camera;

  @override
  CameraState createState() => CameraState();
}

class CameraState extends State<CameraPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  XFile? _image;
  final _imagePicker = ImagePicker();

  //ギャラリーから画像取得
  Future getImageFromGarally() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);

    if(pickedFile != null) {
      _image = XFile(pickedFile.path);
      print(pickedFile.path);

      String fileNameExtension = pickedFile.path.substring(pickedFile.path.lastIndexOf('/') + 1);
      print("fileNameExtension:$fileNameExtension");
      String fileName = fileNameExtension.substring(0, fileNameExtension.lastIndexOf('.'));
      String extension = fileNameExtension.substring(fileNameExtension.lastIndexOf('.') + 1);
      print("extension:$extension");
      final directory = await getExternalStorageDirectory();
      print("convert file:" + directory!.path + "/" + fileName + ".jpg");

      if(extension != "heic") {
        //画像変換 拡張子ごとに利用するメソッドを変更する必要あり
        final cmd = Command()
          ..decodePngFile(pickedFile.path)
          ..writeToFile(directory!.path + "/" + fileName + ".jpg");
        await cmd.executeThread();
      } else {
        HeicToJpg.convert(pickedFile.path, jpgPath: directory!.path + "/" + fileName + ".jpg");
      }
    }

    setState(() {
      if(pickedFile != null) {
        _image = XFile(pickedFile.path);
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _controller = CameraController(
      // カメラを指定
      widget.camera,
      // 解像度を定義
      ResolutionPreset.medium,
    );

    // コントローラーを初期化
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // ウィジェットが破棄されたら、コントローラーを破棄
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // NEXT：プレビュー画面を表示
    // FutureBuilder で初期化を待ってからプレビューを表示（それまではインジケータを表示）
    return Scaffold(
      body: Center(
        child: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return CameraPreview(_controller);
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
      floatingActionButton:
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
                onPressed: getImageFromGarally,
                child: const Icon(Icons.add)
            ),
            FloatingActionButton(
            onPressed: () async {
              // 写真を撮る
              final image = await _controller.takePicture();
              // path を出力
              print(image.path);
            },
            child: const Icon(Icons.camera_alt),
          ),
          ]
        )
    );

    //return SizedBox();
  }
}