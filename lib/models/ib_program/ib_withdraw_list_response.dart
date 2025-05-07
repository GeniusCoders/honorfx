class IbWithdrawListResponse {
  final int status;
  final String? msg;
  final List<IbWithdrawItem>? data;

  IbWithdrawListResponse({required this.status, this.msg, this.data});

  factory IbWithdrawListResponse.fromJson(Map<String, dynamic> json) {
    return IbWithdrawListResponse(
      status: json['status'] ?? 0,
      msg: json['msg'],
      data:
          json['data'] != null
              ? List<IbWithdrawItem>.from(
                json['data'].map((x) => IbWithdrawItem.fromJson(x)),
              )
              : null,
    );
  }
}

class IbWithdrawItem {
  final String paymentMethod;
  final String withdrawTo;
  final String note;
  final String comment;
  final String date;
  final String amount;
  final String status;

  IbWithdrawItem({
    required this.paymentMethod,
    required this.withdrawTo,
    required this.note,
    required this.comment,
    required this.date,
    required this.amount,
    required this.status,
  });

  factory IbWithdrawItem.fromJson(Map<String, dynamic> json) {
    return IbWithdrawItem(
      paymentMethod: json['paymentmethod'] ?? '',
      withdrawTo: json['withdraw_to'] ?? '',
      note: json['note'] ?? '',
      comment: json['comment'] ?? '',
      date: json['date'] ?? '',
      amount: json['amount'] ?? '',
      status: json['status'] ?? '',
    );
  }
}
