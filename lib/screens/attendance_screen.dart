import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get_magang_app/screens/camera_screen.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 30, bottom: 10),
                  width: 300,
                  height: 450,
                  color: Colors.grey,
                  child:
                      (imageFile != null) ? Image.file(imageFile!) : SizedBox(),
                ),
                SizedBox(
                  height: 24,
                ),
                TextFormField(
                  autofocus: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Scan Id Card Anda',
                  ),
                  onFieldSubmitted: (value) async {
                    imageFile = await Navigator.push<File>(context,
                        MaterialPageRoute(builder: (_) => CameraScreen()));
                    setState(() {});
                    print(value);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
