import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quiver/async.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({required this.cameras, Key? key}) : super(key: key);
  final List<CameraDescription> cameras;

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController controller;

  late Future<void> cameraValue;

  @override
  void initState() {
    controller = CameraController(widget.cameras[0], ResolutionPreset.medium);
    cameraValue = controller.initialize();

    const timeOutInSeconds = 1;
    const stepInSeconds = 1;
    int currentNumber = 0;

    CountdownTimer countDownTimer = CountdownTimer(
        const Duration(seconds: timeOutInSeconds),
        const Duration(seconds: stepInSeconds));

    var sub = countDownTimer.listen(null);
    sub.onData((duration) {
      currentNumber += stepInSeconds;
      int countdownNumber = timeOutInSeconds - currentNumber;
      // Make it start from the timeout value
      countdownNumber += stepInSeconds;
    });

    sub.onDone(() async {
      if (!controller.value.isTakingPicture) {
        File result = await takePicture();
        Navigator.pop(context, result);
      }

      sub.cancel();
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future takePicture() async {
    Directory root = await getTemporaryDirectory();
    String directoryPath = '${root.path}/camera';
    await Directory(directoryPath).create(recursive: true);
    XFile? image;

    try {
      image = await controller.takePicture();
    } catch (e) {
      return null;
    }

    return File(image.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: FutureBuilder(
            future: cameraValue,
            builder: (_, snapshot) =>
                (snapshot.connectionState == ConnectionState.done)
                    ? Stack(children: [
                        Column(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              child: CameraPreview(controller),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: Image.asset(
                            'assets/illustrations/camera-overlay.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ])
                    : const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(),
                        ),
                      )));
  }
}
