import 'package:honorfx/models/common/response_details.dart';

class LoginModel {
  ResponseDetails? responseDetails;
  TokenResponse? data;

  LoginModel({this.responseDetails, this.data});

  LoginModel.fromJson(Map<String, dynamic> json) {
    responseDetails = ResponseDetails.fromJson(json);
    data = json["data"] == null ? null : TokenResponse.fromJson(json["data"]);
  }
}

class TokenResponse {
  String? token;
  int? id;
  String? name;
  String? email;
  String? phone;
  String? refferalCode;
  String? emailstatus;
  String? status;
  dynamic parentId;
  String? gender;
  dynamic country;
  String? createdAt;
  String? updatedAt;
  String? isIb;

  TokenResponse({
    this.token,
    this.id,
    this.name,
    this.email,
    this.phone,
    this.refferalCode,
    this.emailstatus,
    this.status,
    this.parentId,
    this.gender,
    this.country,
    this.createdAt,
    this.updatedAt,
    this.isIb,
  });

  TokenResponse.fromJson(Map<String, dynamic> json) {
    token = json["token"];
    id = json["id"];
    name = json["name"];
    email = json["email"];
    phone = json["phone"];
    refferalCode = json["refferal_code"];
    emailstatus = json["verified_status"];
    status = json["status"];
    parentId = json["parent_id"];
    gender = json["gender"];
    country = json["country"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
    isIb = json["is_ib"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["token"] = token;
    data["id"] = id;
    data["name"] = name;
    data["email"] = email;
    data["phone"] = phone;
    data["refferal_code"] = refferalCode;
    data["emailstatus"] = emailstatus;
    data["status"] = status;
    data["parent_id"] = parentId;
    data["gender"] = gender;
    data["country"] = country;
    data["created_at"] = createdAt;
    data["updated_at"] = updatedAt;
    data["is_ib"] = isIb;
    return data;
  }
}
