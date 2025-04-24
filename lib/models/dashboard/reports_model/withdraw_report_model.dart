class WithdrawReportResponse {
  int? status;
  String? msg;
  List<WithdrawReportData>? data;

  WithdrawReportResponse({this.status, this.msg, this.data});

  WithdrawReportResponse.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    msg = json["msg"];
    data = json["data"] == null
        ? null
        : json['data'] is List
            ? (json["data"] as List)
                .map((e) => WithdrawReportData.fromJson(e))
                .toList()
            : <WithdrawReportData>[];
  }
}

class WithdrawReportData {
  String? mtaccountid;
  String? amount;
  String? bankaccount;
  String? admincomment;
  String? date;
  String? note;
  String? status;

  WithdrawReportData(
      {this.mtaccountid,
      this.amount,
      this.bankaccount,
      this.admincomment,
      this.date,
      this.note,
      this.status});

  WithdrawReportData.fromJson(Map<String, dynamic> json) {
    mtaccountid = json["mt5id"].toString();
    amount = json["amount"];
    bankaccount = json["withdraw_to"];
    admincomment = json["comment"];
    date = json["date"];
    note = json["note"];
    status = json["status"];
  }
}
