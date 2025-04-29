import 'package:dio/dio.dart';

class AddDepositModel {
  final String accountNumber;
  final String amount;
  final String? filePath;
  final String refranceNumber;
  final String note;

  AddDepositModel(
      {required this.note,
      required this.accountNumber,
      required this.amount,
      this.filePath,
      required this.refranceNumber});

  Future<Map<String, dynamic>> toMap() async {
    String? _fileName;
    if (filePath != null) {
      _fileName = filePath!.split('/').last;
    }
    return {
      'mt5id': accountNumber,
      'amount': amount,
      'depositproof': _fileName != null
          ? await MultipartFile.fromFile(filePath!, filename: _fileName)
          : null,
      'paymentid': refranceNumber,
      "note": note,
      "paymentmethod": "bank"
    };
  }
}
