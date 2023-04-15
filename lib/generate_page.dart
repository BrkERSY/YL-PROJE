import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share_plus/share_plus.dart';

class GenerateQRCodeScreen extends StatefulWidget {
  const GenerateQRCodeScreen({Key? key}) : super(key: key);

  @override
  _GenerateQRCodeScreenState createState() => _GenerateQRCodeScreenState();
}

class _GenerateQRCodeScreenState extends State<GenerateQRCodeScreen> {
  final textController = TextEditingController();
  final GlobalKey<State<StatefulWidget>> _qrKey = GlobalKey();
  String qrData = "";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          title: const Text(
            "QR Code Generating",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontFamily: "Silkscreen",
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveQrToGallery,
              color: Colors.blue,
            ),
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: _shareQr,
              color: Colors.orangeAccent,
            ),
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: textController,
                  decoration: const InputDecoration(
                    labelText: "Enter text for QR code",
                    hintText: "https://github.com/BrkERSY",
                  ),
                ),
                const SizedBox(height: 25.0),
                if (qrData.isNotEmpty)
                  RepaintBoundary(
                    key: _qrKey,
                    child: Container(
                      color: Colors.white,
                      child: QrImage(
                        data: qrData,
                        version: QrVersions.auto,
                        size: 200.0,
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 25,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      qrData = textController.text;
                    });
                  },
                  icon: const Icon(Icons.qr_code_2_outlined),
                  label: const Text(
                    "Oluştur",
                    style: TextStyle(fontFamily: "Silkscreen"),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      minimumSize: const Size(180, 35)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveQrToGallery() async {
    try {
      RenderRepaintBoundary boundary =
          _qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 1.0);
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      if (byteData != null) {
        final result =
            await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
        if (result["isSuccess"]) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("QR code has been saved to the gallery"),
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("The QR code could not be saved"),
          ));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("The QR code could not be saved"),
      ));
    }
  }

  Future<void> _shareQr() async {
    try {
      RenderRepaintBoundary boundary =
          _qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage(pixelRatio: 2.0);
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      if (byteData != null) {
        final tempDir = await getTemporaryDirectory();
        final path = '${tempDir.path}/qr.png';
        final qrImageFile = File(path);
        await qrImageFile.writeAsBytes(byteData.buffer.asUint8List());
        await Share.shareFiles([path], text: 'QR Code');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("The QR code could not be shared"),
        ),
      );
    }
  }
}
