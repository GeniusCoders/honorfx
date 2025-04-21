import 'package:dartz/dartz.dart';
import 'package:honorfx/models/login_model.dart';
import 'package:honorfx/services/core/server_error.dart';

abstract class LoginRepo {
  Future<Either<ServerError, LoginModel>> login({
    required String email,
    required String password,
  });

  Future<void> storeLoginData({
    required Map<String, dynamic> json,
    required String password,
  });
}
