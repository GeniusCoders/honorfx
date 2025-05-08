class MyCommissionResponse {
  final int status;
  final String? msg;
  final List<MyCommissionItem>? data;

  MyCommissionResponse({required this.status, this.msg, this.data});

  factory MyCommissionResponse.fromJson(Map<String, dynamic> json) {
    return MyCommissionResponse(
      status: json['status'] ?? 0,
      msg: json['msg'],
      data:
          json['data'] != null
              ? List<MyCommissionItem>.from(
                json['data'].map((x) => MyCommissionItem.fromJson(x)),
              )
              : null,
    );
  }
}

class MyCommissionItem {
  final String login;
  final String date;
  final String order;
  final String symbol;
  final String price;
  final String profit;
  final String volume;
  final String commission;
  final String type;

  MyCommissionItem({
    required this.login,
    required this.date,
    required this.order,
    required this.price,
    required this.profit,
    required this.volume,
    required this.commission,
    required this.type,
    required this.symbol,
  });

  factory MyCommissionItem.fromJson(Map<String, dynamic> json) {
    return MyCommissionItem(
      login: json['Login']?.toString() ?? '',
      date: json['Date'] ?? '',
      order: json['Order'] ?? '',
      symbol: json['Symbol'] ?? '',
      price: json['Price'] ?? '',
      profit: json['Profit'] ?? '',
      volume: json['Volume'] ?? '',
      commission: json['Commission'] ?? '',
      type: json['Type'] ?? '',
    );
  }
}
