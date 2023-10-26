import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScanPage extends StatefulWidget{
  const BarcodeScanPage({super.key});

  @override
  BarcodeScanState createState() => BarcodeScanState();
}

class BarcodeScanState extends State<BarcodeScanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MobileScanner(
          onDetect: (capture) {
            final List<Barcode> barcodes = capture.barcodes;
            //final Uint8List? image = capture.image;
            for (final barcode in barcodes) {
              debugPrint('Barcode found! ${barcode.rawValue}');
            }
          })
    );
  }
}