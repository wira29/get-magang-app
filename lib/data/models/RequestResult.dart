class RequestResult {
  int statusCode;
  String message;

  RequestResult({
    required this.statusCode,
    required this.message,
  });

  factory RequestResult.fromJson(Map<String, dynamic> json) => RequestResult(
        statusCode: json['status'],
        message: json['message'],
      );
}
