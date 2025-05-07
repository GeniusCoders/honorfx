class DashboardDataResponse {
  final int status;
  final String? msg;
  final DashboardData? data;

  DashboardDataResponse({required this.status, this.msg, this.data});

  factory DashboardDataResponse.fromJson(Map<String, dynamic> json) {
    return DashboardDataResponse(
      status: json['status'] ?? 0,
      msg: json['msg'],
      data: json['data'] != null ? DashboardData.fromJson(json['data']) : null,
    );
  }
}

class DashboardData {
  final String? walletBalance;
  final double? totalMt5Account;
  final double? totalDeposit;
  final double? totalWithdraw;

  DashboardData({
    this.walletBalance,
    this.totalMt5Account,
    this.totalDeposit,
    this.totalWithdraw,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      walletBalance: json['wallet_balance'],
      totalMt5Account: json['totalmt5account'].toDouble(),
      totalDeposit: json['totaldeposit'].toDouble(),
      totalWithdraw: json['totalwithdraw'].toDouble(),
    );
  }
}
