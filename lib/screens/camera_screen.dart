import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quiver/async.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController controller;

  Future<void> initializeCamera() async {
    var cameras = await availableCameras();
    controller = CameraController(cameras[1], ResolutionPreset.medium);
    await controller.initialize();
  }

  @override
  void initState() {
    const timeOutInSeconds = 3;
    const stepInSeconds = 1;
    int currentNumber = 0;

    CountdownTimer countDownTimer = new CountdownTimer(
        new Duration(seconds: timeOutInSeconds),
        new Duration(seconds: stepInSeconds));

    var sub = countDownTimer.listen(null);
    sub.onData((duration) {
      currentNumber += stepInSeconds;
      int countdownNumber = timeOutInSeconds - currentNumber;
      // Make it start from the timeout value
      countdownNumber += stepInSeconds;
      print('Your message here: $countdownNumber');
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
    String filepath = '$directoryPath/${DateTime.now()}.jpg';
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
            future: initializeCamera(),
            builder: (_, snapshot) =>
                (snapshot.connectionState == ConnectionState.done)
                    ? Stack(children: [
                        Column(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.width *
                                  controller.value.aspectRatio,
                              child: CameraPreview(controller),
                            ),
                            Expanded(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/illustrations/user.png',
                                  width: 100,
                                  height: 100,
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  "Posisikan wajah anda sesuai lingkaran!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            )),
                          ],
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width *
                              controller.value.aspectRatio,
                          child: Image.asset(
                            'assets/illustrations/camera-overlay.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ])
                    : Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(),
                        ),
                      )));
  }
}
