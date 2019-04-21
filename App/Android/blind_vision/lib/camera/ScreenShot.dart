import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart';

String fileName = "nono.png";

class ScreenShot {
  GlobalKey previewContainer;
  double pixelRatio;
  ScreenShot(this.pixelRatio, this.previewContainer);

  Future<void> takeScreenShoot() async {
    RenderRepaintBoundary boundary = previewContainer.currentContext.findRenderObject();

    ui.Image image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();

    final directory = (await getApplicationDocumentsDirectory()).path;
    File imgFile = new File('$directory/$fileName');
    imgFile.writeAsBytes(pngBytes);
    print("Saved to $directory");
  }

  Future<File> getImageFile() async {
    final directory = (await getApplicationDocumentsDirectory()).path;
    File imgFile = new File('$directory/$fileName');
    print("Get photo from $directory/$fileName");
    return imgFile;
  }
}
