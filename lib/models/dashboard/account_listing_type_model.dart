class AccountListingTypeModel {
  int? status;
  String? msg;
  List<AccountListingTypeData>? data;

  AccountListingTypeModel({this.status, this.msg, this.data});

  AccountListingTypeModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    msg = json["msg"];
    data = json["data"] == null
        ? null
        : json['data'] is List
            ? (json["data"] as List)
                .map(
                  (e) => AccountListingTypeData.fromJson(e),
                )
                .toList()
            : <AccountListingTypeData>[];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["status"] = status;
    data["msg"] = msg;
    if (this.data != null) {
      data["data"] = this.data?.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class AccountListingTypeData {
  int? id;
  int? mtUserid;
  int? crmUserid;
  String? name;
  String? groupname;
  String? investpass;
  String? mainpass;
  String? createdAt;
  String? updatedAt;
  String? balance;

  AccountListingTypeData(
      {this.id,
      this.mtUserid,
      this.crmUserid,
      this.name,
      this.groupname,
      this.investpass,
      this.mainpass,
      this.createdAt,
      this.updatedAt,
      this.balance});

  AccountListingTypeData.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    mtUserid = json["mt5id"];
    crmUserid = json["crm_userid"];
    name = json["name"];
    groupname = json["groupname"];
    investpass = json["investpass"];
    mainpass = json["mainpass"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
    balance = json["balance"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["mt_userid"] = mtUserid;
    data["crm_userid"] = crmUserid;
    data["name"] = name;
    data["groupname"] = groupname;
    data["investpass"] = investpass;
    data["mainpass"] = mainpass;
    data["created_at"] = createdAt;
    data["updated_at"] = updatedAt;
    data["balance"] = balance;
    return data;
  }
}
