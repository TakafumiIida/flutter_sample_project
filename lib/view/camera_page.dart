import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:heif_converter/heif_converter.dart';
import 'dart:io';

class CameraPage extends StatefulWidget{
  const CameraPage({
    Key? key,
  }) : super(key: key);

  @override
  CameraState createState() => CameraState();
}

class CameraState extends State<CameraPage> {
  final _imagePicker = ImagePicker();

  //ギャラリーから画像取得
  Future getImageFromGallery() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);

    if(pickedFile != null) {
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
        final cmd = img.Command()
          ..decodePngFile(pickedFile.path)
          ..writeToFile(directory.path + "/" + fileName + ".jpg");
        await cmd.executeThread();
      } else {
        HeifConverter.convert(pickedFile.path, output: directory.path + "/" + fileName + ".jpg", format: "jpg");
        img.Image? image = img.decodeImage(File(directory.path + "/" + fileName + ".jpg").readAsBytesSync());
        if(image != null){
          //90度回転して保存しなおし
          img.Image rotateImage = img.copyRotate(image, angle: 90);
          XFile file = XFile.fromData(img.encodeJpg(rotateImage));
          file.saveTo(directory.path + "/" + fileName + ".jpg");
        }
      }
    }

    setState(() {
      if(pickedFile != null) {
        //_image = XFile(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
                onPressed: getImageFromGallery,
                child: const Icon(Icons.add)
            ),
            FloatingActionButton(
            onPressed: () async {
              final XFile? image = await _imagePicker.pickImage(source: ImageSource.camera);
               if(image != null){
                 print(image.path);
               }
            },
            child: const Icon(Icons.camera_alt),
          ),
          ]
        )
    );

    //return SizedBox();
  }
}