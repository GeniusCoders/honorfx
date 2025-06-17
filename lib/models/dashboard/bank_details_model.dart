class BankDetailsResponse {
  final int status;
  final String? msg;
  final List<BankDetailsData>? data;

  BankDetailsResponse({required this.status, this.msg, this.data});

  factory BankDetailsResponse.fromJson(Map<String, dynamic> json) {
    return BankDetailsResponse(
      status: json['status'] ?? 0,
      msg: json['msg'],
      data:
          json['data'] != null
              ? (json['data'] as List)
                  .map((item) => BankDetailsData.fromJson(item))
                  .toList()
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'msg': msg,
      'data': data?.map((item) => item.toJson()).toList(),
    };
  }
}

class BankDetailsData {
  final int? id;
  final String accountName;
  final String accountNo;
  final String ifscSwiftCode;
  final String? ibanNo;
  final String bankName;
  final String? bankAddress;
  final String country;
  final String? bookBankPath;
  final String? comment;
  final String status;
  final String? createdAt;
  final String? updatedAt;

  BankDetailsData({
    this.id,
    required this.accountName,
    required this.accountNo,
    required this.ifscSwiftCode,
    this.ibanNo,
    required this.bankName,
    this.bankAddress,
    required this.country,
    this.bookBankPath,
    this.comment,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory BankDetailsData.fromJson(Map<String, dynamic> json) {
    return BankDetailsData(
      id: json['id'],
      accountName: json['account_name'] ?? '',
      accountNo: json['account_no'] ?? '',
      ifscSwiftCode: json['ifsc'] ?? '',
      ibanNo: json['iban'],
      bankName: json['bank_name'] ?? '',
      bankAddress: json['address'],
      country: json['country'] ?? '',
      bookBankPath: json['book_bank'],
      comment: json['comment'],
      status: json['status'] ?? 'Pending',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'account_name': accountName,
      'account_no': accountNo,
      'ifsc_swift_code': ifscSwiftCode,
      'iban_no': ibanNo,
      'bank_name': bankName,
      'bank_address': bankAddress,
      'country': country,
      'book_bank_path': bookBankPath,
      'comment': comment,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class AddBankDetailsModel {
  final String accountName;
  final String accountNo;
  final String ifscSwiftCode;
  final String? ibanNo;
  final String bankName;
  final String? bankAddress;
  final String country;
  final String? bookBankPath;

  AddBankDetailsModel({
    required this.accountName,
    required this.accountNo,
    required this.ifscSwiftCode,
    this.ibanNo,
    required this.bankName,
    this.bankAddress,
    required this.country,
    this.bookBankPath,
  });

  Map<String, dynamic> toJson() {
    return {
      'account_name': accountName,
      'account_no': accountNo,
      'ifsc': ifscSwiftCode,
      'iban': ibanNo,
      'bank_name': bankName,
      'address': bankAddress,
      'country': country,
      'book_bank': bookBankPath,
    };
  }
}
