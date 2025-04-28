class WalletTransferResponse {
  final int status;
  final String? msg;
  final Map<String, dynamic>? data;

  WalletTransferResponse({required this.status, this.msg, this.data});

  factory WalletTransferResponse.fromJson(Map<String, dynamic> json) {
    return WalletTransferResponse(
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
