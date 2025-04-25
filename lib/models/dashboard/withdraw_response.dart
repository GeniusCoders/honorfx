class WithdrawResponse {
  final int status;
  final String? msg;
  final Map<String, dynamic>? data;

  WithdrawResponse({required this.status, this.msg, this.data});

  factory WithdrawResponse.fromJson(Map<String, dynamic> json) {
    return WithdrawResponse(
      status: json['status'] ?? 0,
      msg: json['msg'],
      data:
          json['data'] != null ? Map<String, dynamic>.from(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'msg': msg, 'data': data};
  }

  bool get isSuccess => status == 200;
}
