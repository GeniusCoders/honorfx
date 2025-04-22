import 'dart:convert';

class SignupModel {
  final String name;
  final String email;
  final String password;
  final String mobile;
  final String country;
  final String? refferalCode;

  SignupModel({
    required this.name,
    required this.email,
    required this.password,
    required this.mobile,
    required this.country,
    this.refferalCode,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'phone': mobile,
      'country': country,
      'refferal_code': refferalCode,
    };
  }

  String toJson() => json.encode(toMap());
}
