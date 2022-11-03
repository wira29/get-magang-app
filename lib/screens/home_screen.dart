import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_magang_app/data/services/api_service.dart';
import 'package:get_magang_app/provider/scan_provider.dart';
import 'package:get_magang_app/utils/result_state.dart';
import 'package:provider/provider.dart';

import '../data/models/Scan.dart';
import 'camera_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? imageFile;
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void submitAttendance(Scan scan, ScanProvider provider) async {
    await provider.attendance(scan);
    controller.clear();

    showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(seconds: 1), () {
            Navigator.of(context).pop(true);
          });
          return AlertDialog(
            title: Text('Berhasil'),
            content: Text("berhasil melakukan absen"),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ScanProvider(apiService: ApiService()),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Consumer<ScanProvider>(
            builder: (context, state, _) {
              if (state.state == ResultState.Loading) {
                return Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(),
                      ),
                      SizedBox(
                        width: 32,
                      ),
                      Text("Loading..."),
                    ],
                  ),
                );
              } else if (state.state == ResultState.Error) {
                return Center(
                  child: Text(state.message),
                );
              } else {
                return Stack(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/illustrations/rfid_illustration.png',
                            width: 200,
                            height: 200,
                          ),
                          const Text(
                            "Silakan melakukan scan id card anda pada RFID scanner !",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 16),
                            child: TextFormField(
                              autofocus: true,
                              controller: controller,
                              focusNode: focusNode,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Scan Id Card Anda',
                              ),
                              onFieldSubmitted: (value) async {
                                imageFile = await Navigator.push<File>(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => CameraScreen()));
                                // focusNode.requestFocus();
                                // controller.text = "";
                                // print(value);
                                submitAttendance(
                                    Scan(rfid: value, photo: imageFile!),
                                    state);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/illustrations/logo-black.png',
                              width: 160,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
