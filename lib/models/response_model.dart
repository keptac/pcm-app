class ResponseModel {
  bool? success;
  String message;
  Object? responseBody;

  ResponseModel({
    required this.success,
    required this.message,
    required this.responseBody,
  });

  factory ResponseModel.fromJson(Map<dynamic, dynamic> json) {
    return ResponseModel(
      success: json['success'] as bool?,
      message: json['message'] as String,
      responseBody: json['responseBody'],
    );
  }
}
