class ClientTransactionResponse {
  final int status;
  final String? msg;
  final ClientTransactionData? data;

  ClientTransactionResponse({required this.status, this.msg, this.data});

  factory ClientTransactionResponse.fromJson(Map<String, dynamic> json) {
    return ClientTransactionResponse(
      status: json['status'] ?? 0,
      msg: json['msg'],
      data:
          json['data'] != null
              ? ClientTransactionData.fromJson(json['data'])
              : null,
    );
  }
}

class ClientTransactionData {
  final List<double> deposit;
  final List<double> withdraw;

  ClientTransactionData({required this.deposit, required this.withdraw});

  factory ClientTransactionData.fromJson(Map<String, dynamic> json) {
    return ClientTransactionData(
      deposit: List<double>.from(
        (json['deposit'] ?? []).map((x) => double.parse(x.toString())),
      ),
      withdraw: List<double>.from(
        (json['withdraw'] ?? []).map((x) => double.parse(x.toString())),
      ),
    );
  }

  // Helper methods to get total values
  double getTotalDeposit() {
    if (deposit.isEmpty) return 0;
    return deposit.reduce((a, b) => a + b);
  }

  double getTotalWithdraw() {
    if (withdraw.isEmpty) return 0;
    return withdraw.reduce((a, b) => a + b);
  }
}
