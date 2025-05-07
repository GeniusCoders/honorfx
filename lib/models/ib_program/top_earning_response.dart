class TopEarningResponse {
  final int status;
  final String? msg;
  final List<TopEarningData>? data;

  TopEarningResponse({required this.status, this.msg, this.data});

  factory TopEarningResponse.fromJson(Map<String, dynamic> json) {
    return TopEarningResponse(
      status: json['status'] ?? 0,
      msg: json['msg'],
      data:
          json['data'] != null
              ? List<TopEarningData>.from(
                json['data'].map((x) => TopEarningData.fromJson(x)),
              )
              : null,
    );
  }
}

class TopEarningData {
  final String name;
  final String email;
  final String totalLots;
  final String totalComm;

  TopEarningData({
    required this.name,
    required this.email,
    required this.totalLots,
    required this.totalComm,
  });

  factory TopEarningData.fromJson(Map<String, dynamic> json) {
    return TopEarningData(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      totalLots: json['totallots'] ?? '0',
      totalComm: json['totalcomm'] ?? '0',
    );
  }
}
