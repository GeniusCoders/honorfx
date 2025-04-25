class OpenAccountResponse {
  final int status;
  final String? msg;
  final OpenAccountData? data;

  OpenAccountResponse({required this.status, this.msg, this.data});

  factory OpenAccountResponse.fromJson(Map<String, dynamic> json) {
    return OpenAccountResponse(
      status: json['status'] ?? 0,
      msg: json['msg'],
      data:
          json['data'] != null ? OpenAccountData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'msg': msg, 'data': data?.toJson()};
  }
}

class OpenAccountData {
  final String? message;
  final bool? success;

  OpenAccountData({this.message, this.success});

  factory OpenAccountData.fromJson(Map<String, dynamic> json) {
    return OpenAccountData(message: json['message'], success: json['success']);
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'success': success};
  }
}
