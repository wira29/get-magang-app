import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_magang_app/data/models/RequestResult.dart';
import 'package:http/http.dart' as http;

import '../models/Scan.dart';

class ApiService {
  static final _baseUrl = "http://192.168.7.37:8000/api/";
  static final _apiKey = "";
  static final _contentType = "";

  Future<RequestResult> postAttendance(Scan scan) async {
    Uri url = Uri.parse(_baseUrl + 'attendance');
    // print(url);

    // var stream = new http.ByteStream(scan.photo.openRead());
    // stream.cast();

    // var length = await scan.photo.length();

    // var request = new http.MultipartRequest('POST', url);
    // request.fields['rfid'] = scan.rfid;

    // var multiport = new http.MultipartFile('photo', stream, length);
    // request.files.add(multiport);

    // await request.send().then((result) async {
    //   http.Response.fromStream(result).then((response) {
    //     if (response.statusCode == 200) {
    //       print("Uploaded! ");
    //       print('response.body ' + response.body);
    //     }

    //     return response.body;
    //   });
    // }).catchError((e) {
    //   print(e);
    //   print('error');
    // });

    Dio dio = new Dio();
    scan.photo.existsSync();
    String filename = scan.photo.path.split('/').last;
    FormData formData = new FormData.fromMap({
      "rfid": scan.rfid,
      "photo": await MultipartFile.fromFile(scan.photo.path, filename: filename)
    });

    await dio.post(url.toString(), data: formData).then(
      (res) {
        print(res.data);
        print('berhasil upload');
      },
    ).catchError((e) {
      print(e);
      print('error');
    });

    return RequestResult(statusCode: 200, message: "berhasil");
  }
}
