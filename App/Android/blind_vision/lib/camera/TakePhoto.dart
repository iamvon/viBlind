import 'package:path_provider/path_provider.dart';
import 'package:camera/camera.dart';
import 'dart:io';

String fileName = "nono.png";

class TakePhoto {
  Future<void> takePicture(controller) async {
    if (!controller.value.isInitialized) {
      print('Error: select a camera first.');
      return null;
    }
    final directory = (await getApplicationDocumentsDirectory()).path;
    String imgPath = "$directory/$fileName";

    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await controller.takePicture(imgPath);
      print("Photo is saved in $imgPath");
    } on CameraException catch (e) {
      print(e);
      return null;
    }
  }

  Future<File> getImageFile() async {
    final directory = (await getApplicationDocumentsDirectory()).path;
    File imgFile = new File('$directory/$fileName');
    print("Get photo from $directory/$fileName");
    return imgFile;
  }
}