class WalletHistoryResponse {
  int? status;
  String? msg;
  List<WalletHistoryData>? data;

  WalletHistoryResponse({this.status, this.msg, this.data});

  WalletHistoryResponse.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    msg = json["msg"];
    data =
        json["data"] == null
            ? null
            : json['data'] is List
            ? (json["data"] as List)
                .map((e) => WalletHistoryData.fromJson(e))
                .toList()
            : <WalletHistoryData>[];
  }
}

class WalletHistoryData {
  String? amount;
  String? method;
  String? todeposit;
  String? note;
  String? date;

  WalletHistoryData({
    this.amount,
    this.method,
    this.todeposit,
    this.note,
    this.date,
  });

  WalletHistoryData.fromJson(Map<String, dynamic> json) {
    amount = json["amount"];
    method = json["method"];
    todeposit = json["todeposit"];
    note = json["note"];
    date = json["date"];
  }
}
