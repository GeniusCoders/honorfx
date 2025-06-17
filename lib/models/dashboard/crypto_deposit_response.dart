class CryptoDepositResponse {
  final int status;
  final String? msg;
  final CryptoDepositData? data;

  CryptoDepositResponse({required this.status, this.msg, this.data});

  factory CryptoDepositResponse.fromJson(Map<String, dynamic> json) {
    return CryptoDepositResponse(
      status: json['status'] ?? 0,
      msg: json['msg'],
      data:
          json['data'] != null
              ? CryptoDepositData.fromJson(json['data'])
              : null,
    );
  }
}

class CryptoDepositData {
  final String url;

  CryptoDepositData({required this.url});

  factory CryptoDepositData.fromJson(Map<String, dynamic> json) {
    return CryptoDepositData(url: json['url'] ?? '');
  }
}
