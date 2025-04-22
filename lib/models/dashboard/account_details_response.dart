class AccountDetailsResponse {
  int? status;
  String? msg;
  AccountDetailsData? data;

  AccountDetailsResponse({this.status, this.msg, this.data});

  AccountDetailsResponse.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    msg = json["msg"];
    data =
        json["data"] == null ? null : AccountDetailsData.fromJson(json["data"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["status"] = status;
    data["msg"] = msg;
    if (this.data != null) {
      data["data"] = this.data?.toJson();
    }
    return data;
  }
}

class AccountDetailsData {
  String? accountNumber;
  String? balance;
  String? equity;
  String? credit;
  num? margin;
  num? marginLeverage;
  num? profit;
  num? assets;
  String? registration;
  num? leverage;
  String? equityPrevDay;
  num? currencyDigits;
  String? currency;

  AccountDetailsData({
    this.accountNumber,
    this.balance,
    this.equity,
    this.credit,
    this.margin,
    this.marginLeverage,
    this.profit,
    this.assets,
    this.registration,
    this.leverage,
    this.equityPrevDay,
    this.currencyDigits,
    this.currency,
  });

  AccountDetailsData.fromJson(Map<String, dynamic> json) {
    accountNumber = json["Login"]?.toString();
    balance = json["Balance"]?.toString();
    equity = json["Equity"]?.toString();
    credit = json["Credit"]?.toString();
    margin = json["Margin"];
    marginLeverage = json["MarginLeverage"];
    profit = json["Profit"];
    assets = json["Assets"];
    registration = json["Registration"]?.toString();
    leverage = json["Leverage"];
    equityPrevDay = json["EquityPrevDay"]?.toString();
    currencyDigits = json["CurrencyDigits"];
    currency = json["Currency"]?.toString() ?? "\$";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["Login"] = accountNumber;
    data["Balance"] = balance;
    data["Equity"] = equity;
    data["Credit"] = credit;
    data["Margin"] = margin;
    data["MarginLeverage"] = marginLeverage;
    data["Profit"] = profit;
    data["Assets"] = assets;
    data["Registration"] = registration;
    data["Leverage"] = leverage;
    data["EquityPrevDay"] = equityPrevDay;
    data["CurrencyDigits"] = currencyDigits;
    data["Currency"] = currency;
    return data;
  }
}
