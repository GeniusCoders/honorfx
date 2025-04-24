import 'package:honorfx/models/common/response_details.dart';

class OpenPositionsResponse extends ResponseDetails {
  List<OpenPositionData>? data;

  OpenPositionsResponse({this.data, int? status, String? msg})
    : super(status: status, msg: msg);

  factory OpenPositionsResponse.fromJson(Map<String, dynamic> json) {
    return OpenPositionsResponse(
      status: json['status'],
      msg: json['msg'],
      data:
          json['data'] != null
              ? List<OpenPositionData>.from(
                json['data'].map((x) => OpenPositionData.fromJson(x)),
              )
              : null,
    );
  }
}

class OpenPositionData {
  int? id;
  String? ticket;
  String? openTime;
  String? type;
  String? volume;
  String? symbol;
  double? openPrice;
  double? currentPrice;
  double? sl;
  double? tp;
  double? commission;
  double? swap;
  double? profit;
  String? comment;
  String? accountId;

  OpenPositionData({
    this.id,
    this.ticket,
    this.openTime,
    this.type,
    this.volume,
    this.symbol,
    this.openPrice,
    this.currentPrice,
    this.sl,
    this.tp,
    this.commission,
    this.swap,
    this.profit,
    this.comment,
    this.accountId,
  });

  factory OpenPositionData.fromJson(Map<String, dynamic> json) {
    return OpenPositionData(
      id: json['id'],
      ticket: json['ticket'],
      openTime: json['open_time'],
      type: json['type'],
      volume: json['volume'],
      symbol: json['symbol'],
      openPrice:
          json['open_price'] != null
              ? double.tryParse(json['open_price'].toString())
              : null,
      currentPrice:
          json['current_price'] != null
              ? double.tryParse(json['current_price'].toString())
              : null,
      sl: json['sl'] != null ? double.tryParse(json['sl'].toString()) : null,
      tp: json['tp'] != null ? double.tryParse(json['tp'].toString()) : null,
      commission:
          json['commission'] != null
              ? double.tryParse(json['commission'].toString())
              : null,
      swap:
          json['swap'] != null
              ? double.tryParse(json['swap'].toString())
              : null,
      profit:
          json['profit'] != null
              ? double.tryParse(json['profit'].toString())
              : null,
      comment: json['comment'],
      accountId: json['account_id'],
    );
  }
}
