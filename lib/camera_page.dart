import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';

class Camera extends StatefulWidget {
  Camera({Key? key}) : super(key: key);

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  late CameraController controller;

  Future<void> InitializeCamera() async {
    var cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    await controller.initialize();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<File> takePicture() async {
    Directory root = await getTemporaryDirectory();
    String directorypath = '${root.path}/Guided_Camera';
    await Directory(directorypath).create(recursive: true);
    String filepath = '$directorypath/${DateTime.now()}.jpg';

    try {
      await controller.takePicture(filepath);
    } catch (e) {
      return null;
    }
    return File(filepath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: FutureBuilder(
            future: InitializeCamera(),
            builder: (_, snapshot) =>
                (snapshot.connectionState == ConnectionState.done)
                    ? Stack(
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.width /
                                    controller.value.aspectRatio,
                                child: CameraPreview(controller),
                              ),
                              Container(
                                  width: 70,
                                  height: 70,
                                  margin: EdgeInsets.only(top: 50),
                                  child: RaisedButton(
                                    onPressed: () async {
                                      if (!controller.value.isTakingPicture) {
                                        File result = await takePicture();
                                        Navigator.pop(context, result);
                                      }
                                    },
                                    shape: CircleBorder(),
                                    color: Colors.blue,
                                  )),
                            ],
                          ),
                        ],
                      )
                    : Center(
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(),
                        ),
                      )));
  }
}
