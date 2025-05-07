class IbMonthlyCommissionResponse {
  final int status;
  final String? msg;
  final IbMonthlyCommissionData? data;

  IbMonthlyCommissionResponse({required this.status, this.msg, this.data});

  factory IbMonthlyCommissionResponse.fromJson(Map<String, dynamic> json) {
    return IbMonthlyCommissionResponse(
      status: json['status'] ?? 0,
      msg: json['msg'],
      data:
          json['data'] != null
              ? IbMonthlyCommissionData.fromJson(json['data'])
              : null,
    );
  }
}

class IbMonthlyCommissionData {
  final List<String> date;
  final List<double> commission;

  IbMonthlyCommissionData({required this.date, required this.commission});

  factory IbMonthlyCommissionData.fromJson(Map<String, dynamic> json) {
    return IbMonthlyCommissionData(
      date: List<String>.from(json['date'] ?? []),
      commission: List<double>.from(
        (json['commission'] ?? []).map((x) => double.parse(x.toString())),
      ),
    );
  }
}
