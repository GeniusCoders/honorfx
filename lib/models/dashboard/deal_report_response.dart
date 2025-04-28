import 'dart:convert';
import 'package:intl/intl.dart';

DealReportResponse dealReportResponseFromJson(String str) =>
    DealReportResponse.fromJson(json.decode(str));

String dealReportResponseToJson(DealReportResponse data) =>
    json.encode(data.toJson());

class DealReportResponse {
  int? status;
  String? message;
  List<DealReportData>? data;

  DealReportResponse({this.status, this.message, this.data});

  factory DealReportResponse.fromJson(Map<String, dynamic> json) =>
      DealReportResponse(
        status: json["status"],
        message: json["msg"],
        data:
            json["data"] == null
                ? []
                : List<DealReportData>.from(
                  json["data"]!.map((x) => DealReportData.fromJson(x)),
                ),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": message,
    "data":
        data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class DealReportData {
  int? deal;
  int? login;
  int? order;
  int? action;
  int? entry;
  int? reason;
  int? time;
  String? symbol;
  int? digits;
  double? price;
  double? volume;
  double? profit;
  String? comment;
  int? externalId;

  DealReportData({
    this.deal,
    this.login,
    this.order,
    this.action,
    this.entry,
    this.reason,
    this.time,
    this.symbol,
    this.digits,
    this.price,
    this.volume,
    this.profit,
    this.comment,
    this.externalId,
  });

  factory DealReportData.fromJson(Map<String, dynamic> json) => DealReportData(
    deal: json["Deal"],
    login: json["Login"],
    order: json["Order"],
    action: json["Action"],
    entry: json["Entry"],
    reason: json["Reason"],
    time: json["Time"],
    symbol: json["Symbol"],
    digits: json["Digits"],
    price: json["Price"]?.toDouble(),
    volume: json["Volume"]?.toDouble(),
    profit: json["Profit"]?.toDouble(),
    comment: json["Comment"],
    externalId: json["External_ID"],
  );

  Map<String, dynamic> toJson() => {
    "deal": deal,
    "login": login,
    "order": order,
    "action": action,
    "entry": entry,
    "reason": reason,
    "time": time,
    "symbol": symbol,
    "digits": digits,
    "price": price,
    "volume": volume,
    "profit": profit,
    "comment": comment,
    "external_id": externalId,
  };

  // Method to get formatted time from Unix timestamp
  String getFormattedTime() {
    if (time == null) return '';

    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time! * 1000);
    return DateFormat('MM/dd/yyyy HH:mm:ss').format(dateTime);
  }

  String get formattedCurrentPrice {
    if (price == null) return "0.00";

    // Check if it's a commodity (like XAUUSD.r, ESP35.r) or index
    if (symbol != null) {
      // Commodities typically start with XAU, XAG, USOIL, etc.
      bool isCommodity =
          symbol!.startsWith('XAU') ||
          symbol!.startsWith('XAG') ||
          symbol!.contains('OIL') ||
          symbol!.contains('GOLD');

      // Indices typically include numbers or specific names
      bool isIndex =
          symbol!.contains('30') ||
          symbol!.contains('35') ||
          symbol!.contains('40') ||
          symbol!.contains('500') ||
          symbol!.startsWith('US') ||
          symbol!.startsWith('UK') ||
          symbol!.startsWith('ESP') ||
          symbol!.startsWith('GER') ||
          symbol!.startsWith('JP');

      if (isCommodity || isIndex) {
        return price!.toStringAsFixed(2);
      }

      // For forex pairs, show 5 decimals
      return price!.toStringAsFixed(5);
    }

    return price!.toStringAsFixed(5);
  }

  // Method to convert action code to readable deal type
  String getDealType() {
    // MT5 deal types based on common values
    switch (action) {
      case 0:
        return 'Buy';
      case 1:
        return 'Sell';
      case 2:
        return 'Balance';
      case 3:
        return 'Credit';
      case 4:
        return 'Charge';
      case 5:
        return 'Correction';
      case 6:
        return 'Bonus';
      case 7:
        return 'Commission';
      case 8:
        return 'Commission Daily';
      case 9:
        return 'Commission Monthly';
      case 10:
        return 'Commission Agent Daily';
      case 11:
        return 'Commission Agent Monthly';
      case 12:
        return 'Interest';
      case 13:
        return 'Buy Canceled';
      case 14:
        return 'Sell Canceled';
      case 15:
        return 'Dividend';
      case 16:
        return 'Dividend Franked';
      case 17:
        return 'Tax';
      default:
        return 'Unknown';
    }
  }
}
