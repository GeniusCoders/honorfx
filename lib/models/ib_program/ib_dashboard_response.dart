class IbDashboardResponse {
  final int status;
  final String? msg;
  final IbDashboardData? data;

  IbDashboardResponse({required this.status, this.msg, this.data});

  factory IbDashboardResponse.fromJson(Map<String, dynamic> json) {
    return IbDashboardResponse(
      status: json['status'] ?? 0,
      msg: json['msg'],
      data:
          json['data'] != null ? IbDashboardData.fromJson(json['data']) : null,
    );
  }
}

class IbDashboardData {
  final int totalClients;
  final String totalVolume;
  final String totalCommission;
  final String availableCommission;
  final String withdrawCommission;
  final int activeTraders;
  final int activeSubIb;

  IbDashboardData({
    required this.totalClients,
    required this.totalVolume,
    required this.totalCommission,
    required this.availableCommission,
    required this.withdrawCommission,
    required this.activeTraders,
    required this.activeSubIb,
  });

  factory IbDashboardData.fromJson(Map<String, dynamic> json) {
    return IbDashboardData(
      totalClients: json['totalclients'] ?? 0,
      totalVolume: json['totalvolume'] ?? '0',
      totalCommission: json['totalcommission'] ?? '0',
      availableCommission: json['availablecommission'] ?? '0',
      withdrawCommission: json['withdrawcommission'] ?? '0',
      activeTraders: json['activetraders'] ?? 0,
      activeSubIb: json['activesubib'] ?? 0,
    );
  }
}
