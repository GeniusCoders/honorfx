class DepositReportResponse {
  int? status;
  String? msg;
  List<DepositReportData>? data;

  DepositReportResponse({this.status, this.msg, this.data});

  DepositReportResponse.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    msg = json["msg"];
    data =
        json["data"] == null
            ? null
            : json['data'] is List
            ? (json["data"] as List)
                .map((e) => DepositReportData.fromJson(e))
                .toList()
            : <DepositReportData>[];
  }
}

class DepositReportData {
  String? mtaccountid;
  String? amount;
  String? paymentmethod;
  String? admincomment;
  String? date;
  String? referenceNumber;
  String? status;

  DepositReportData({
    this.mtaccountid,
    this.amount,
    this.paymentmethod,
    this.admincomment,
    this.date,
    this.referenceNumber,
    this.status,
  });

  DepositReportData.fromJson(Map<String, dynamic> json) {
    mtaccountid = json["mt5id"].toString();
    amount = json["amount"];
    paymentmethod = json["paymentmethod"];
    admincomment = json["comment"];
    date = json["date"];
    referenceNumber = json["reference_number"];
    status = json["status"];
  }
}
