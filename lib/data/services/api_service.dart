import 'package:dio/dio.dart';
import 'package:get_magang_app/data/models/RequestResult.dart';

import '../models/Scan.dart';

class ApiService {
  static const _baseUrl = "http://magang.hummasoft.com/api/";

  Future<RequestResult> postAttendance(Scan scan) async {
    Uri url = Uri.parse(_baseUrl + 'attendance');

    Dio dio = Dio();
    scan.photo.existsSync();
    String filename = scan.photo.path.split('/').last;
    FormData formData = FormData.fromMap({
      "rfid": scan.rfid,
      "photo": await MultipartFile.fromFile(scan.photo.path, filename: filename)
    });

    return await dio.post(url.toString(), data: formData).then(
      (res) {
        return RequestResult.fromJson(res.data);
      },
    ).catchError((e) {
      return RequestResult(status: 'Gagal', message: "Kesalahan jaringan!");
    });
  }
}
