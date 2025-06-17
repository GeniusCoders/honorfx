class UpiQrCodeResponse {
  final int status;
  final String? msg;
  final UpiQrCodeData? data;

  UpiQrCodeResponse({required this.status, this.msg, this.data});

  factory UpiQrCodeResponse.fromJson(Map<String, dynamic> json) {
    return UpiQrCodeResponse(
      status: json['status'] ?? 0,
      msg: json['msg'],
      data: json['data'] != null ? UpiQrCodeData.fromJson(json['data']) : null,
    );
  }
}

class UpiQrCodeData {
  final String qrcode;

  UpiQrCodeData({required this.qrcode});

  factory UpiQrCodeData.fromJson(Map<String, dynamic> json) {
    return UpiQrCodeData(qrcode: json['qrcode'] ?? '');
  }
}
