import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({Key key}) : super(key: key);

  @override
  _QrScannerScreenState createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MobileScanner(
        onDetect: (barcode, args) {
          if (barcode.rawValue.startsWith("http")) {
            Navigator.of(context).pop(barcode.rawValue);
          } else if (barcode.rawValue.startsWith("https")) {
            Navigator.of(context).pop(barcode.rawValue);
          } else {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }
}
