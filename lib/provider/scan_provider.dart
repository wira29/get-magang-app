import 'package:flutter/widgets.dart';
import 'package:get_magang_app/data/models/RequestResult.dart';
import 'package:get_magang_app/data/services/api_service.dart';
import 'package:get_magang_app/utils/result_state.dart';

import '../data/models/Scan.dart';

class ScanProvider extends ChangeNotifier {
  final ApiService apiService;

  ScanProvider({required this.apiService});

  ResultState _state = ResultState.Success;
  String _message = '';

  String get message => _message;
  ResultState get state => _state;

  Future<dynamic> attendance(Scan scan) async {
    print('provider');
    try {
      _state = ResultState.Loading;
      notifyListeners();

      final response = await apiService.postAttendance(scan);
      _state = ResultState.Success;
      notifyListeners();

      return response;
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = "Error --> ${e.runtimeType.toString()}";
    }
  }
}
