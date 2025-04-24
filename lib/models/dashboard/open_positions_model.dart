import 'package:honorfx/models/common/response_details.dart';
import 'package:intl/intl.dart';

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
  String? symbol;
  int? action; // 0 = Buy, 1 = Sell
  double? openPrice;
  double? currentPrice;
  double? sl;
  double? tp;
  int? volume;
  double? profit;
  String? comment;
  int? timeCreate;
  int? timeUpdate;
  int? login;

  OpenPositionData({
    this.id,
    this.ticket,
    this.symbol,
    this.action,
    this.openPrice,
    this.currentPrice,
    this.sl,
    this.tp,
    this.volume,
    this.profit,
    this.comment,
    this.timeCreate,
    this.timeUpdate,
    this.login,
  });

  factory OpenPositionData.fromJson(Map<String, dynamic> json) {
    return OpenPositionData(
      id: json['Position'],
      ticket: json['Position']?.toString(),
      symbol: json['Symbol'],
      action: json['Action'],
      openPrice:
          json['PriceOpen'] != null
              ? double.tryParse(json['PriceOpen'].toString())
              : null,
      currentPrice:
          json['PriceCurrent'] != null
              ? double.tryParse(json['PriceCurrent'].toString())
              : null,
      sl:
          json['PriceSL'] != null
              ? double.tryParse(json['PriceSL'].toString())
              : null,
      tp:
          json['PriceTP'] != null
              ? double.tryParse(json['PriceTP'].toString())
              : null,
      volume: json['Volume'],
      profit:
          json['Profit'] != null
              ? double.tryParse(json['Profit'].toString())
              : null,
      comment: json['Comment'],
      timeCreate: json['TimeCreate'],
      timeUpdate: json['TimeUpdate'],
      login: json['Login'],
    );
  }

  // Helper methods for UI display
  bool get isBuy => action == 0;

  String get actionType => isBuy ? "Buy" : "Sell";

  // Format volume to display in lots with proper rounding
  String get formattedVolume {
    if (volume == null) return "0.00 Lot";
    return "${(volume! / 10000)} Lot";
  }

  // Format profit with sign and decimal places
  String get formattedProfit {
    if (profit == null) return "\$0.00";
    final sign = profit! >= 0 ? "+" : "";
    return "$sign\$${profit!.toStringAsFixed(2)}";
  }

  // Format prices with appropriate decimal places based on the asset
  String get formattedOpenPrice {
    if (openPrice == null) return "0.00";

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
        return openPrice!.toStringAsFixed(2);
      }

      // For forex pairs, show 5 decimals
      return openPrice!.toStringAsFixed(5);
    }

    return openPrice!.toStringAsFixed(5);
  }

  // Format current price with appropriate decimal places
  String get formattedCurrentPrice {
    if (currentPrice == null) return "0.00";

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
        return currentPrice!.toStringAsFixed(2);
      }

      // For forex pairs, show 5 decimals
      return currentPrice!.toStringAsFixed(5);
    }

    return currentPrice!.toStringAsFixed(5);
  }

  // Get date string from Unix timestamp
  String get dateString {
    if (timeCreate == null) return "";
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timeCreate! * 1000);
    return DateFormat('MM/dd/yyyy').format(dateTime);
  }

  // Get time string from Unix timestamp
  String get timeString {
    if (timeCreate == null) return "";
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timeCreate! * 1000);
    return DateFormat('HH:mm').format(dateTime);
  }
}
