import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:blind_vision/view/home/TextView.dart';
import 'package:blind_vision/camera/TakePhoto.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

List<CameraDescription> cameras;

File image;
double pixelRatio;

Future<void> main() async {
  cameras = await availableCameras();
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.high);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  CameraController controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey previewContainer = new GlobalKey();

    if (!controller.value.isInitialized) {
      return Container();
    }
    int counter = 0;
    return new MaterialApp(
        title: "Vision for Blind",
        home: new Scaffold(
          body: Builder(
              builder: (context) => Center(
                    child: Stack(
                            children: <Widget>[

                              new Center(
                                child: new FutureBuilder(
                                  future: new TakePhoto().getImageFile(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<File> snapshot) {
                                    return snapshot.data != null
                                        ? new Image.file(snapshot.data)
                                        : new Container();
                                  },
                                ),
                              ),

//                              RepaintBoundary(
//                                  key: previewContainer,
//                                  child: Stack(children: <Widget>[
//                                    new GestureDetector(
//                                      onTap: () {
//                                        counter++;
//                                        print(
//                                            "TAP ON SCREEN {$counter} TIMES !!!!!");
//                                      },
//                                      child: new Stack(
//                                        children: <Widget>[
//                                          new Transform.scale(
//                                              scale: 1 /
//                                                  controller.value.aspectRatio,
//                                              child: new Center(
//                                                child: new AspectRatio(
//                                                    aspectRatio: controller
//                                                            .value.aspectRatio /
//                                                        1.1,
//                                                    child: new CameraPreview(
//                                                        controller)),
//                                              )),
//                                          new TextView(),
//                                        ],
//                                      ),
//                                    ),
//                                  ])),
//
//                              new Center(
//                                child: FlatButton(
//                                  color: Colors.white,
//                                  child: Text(
//                                    'CLICK ME',
//                                    textDirection: TextDirection.ltr,
//                                  ),
//                                  onPressed: () async {
//                                    double pixelRatio =
//                                        MediaQuery.of(context).size.width;
//                                    print("PixelRatio: $pixelRatio");
//
//                                    await new TakePhoto().takePicture(controller);
//                                  },
//                                ),
//                              ),

                            ],
                          ),
                  )),
        ));
  }
}
