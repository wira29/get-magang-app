class RequestResult {
  String status;
  String message;

  RequestResult({
    required this.status,
    required this.message,
  });

  factory RequestResult.fromJson(Map<String, dynamic> json) => RequestResult(
        status: json['status'],
        message: json['message'],
      );
}
