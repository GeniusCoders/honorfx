class LeverageListResponse {
  final int status;
  final String? msg;
  final List<LeverageData>? data;

  LeverageListResponse({required this.status, this.msg, this.data});

  factory LeverageListResponse.fromJson(Map<String, dynamic> json) {
    return LeverageListResponse(
      status: json['status'] ?? 0,
      msg: json['msg'],
      data:
          json['data'] != null
              ? List<LeverageData>.from(
                json['data'].map((x) => LeverageData.fromJson(x)),
              )
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'msg': msg,
      'data': data?.map((x) => x.toJson()).toList(),
    };
  }
}

class LeverageData {
  final int leverage;

  LeverageData({required this.leverage});

  factory LeverageData.fromJson(Map<String, dynamic> json) {
    return LeverageData(leverage: json['leverage'] ?? 0);
  }

  Map<String, dynamic> toJson() {
    return {'leverage': leverage};
  }
}
