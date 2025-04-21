import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dartz/dartz.dart';
import 'package:honorfx/models/login_model.dart';
import 'package:honorfx/services/core/server_error.dart';
import 'package:honorfx/services/repo/login_repo.dart';

@Injectable(as: LoginRepo)
class LoginApi extends LoginRepo {
  final Dio dio;
  final SharedPreferences sharedPreferences;

  LoginApi({required this.dio, required this.sharedPreferences}) {
    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          request: false,
          requestHeader: false,
          responseHeader: false,
          requestBody: true,
          responseBody: true,
        ),
      );
    }
  }

  @override
  Future<Either<ServerError, LoginModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      const _url = "/login";
      final response = await dio.post(
        _url,
        data: FormData.fromMap({"email": email, "password": password}),
      );

      return right(LoginModel.fromJson(response.data));
    } on DioError catch (e) {
      return left(ServerError.withError(error: e));
    }
  }

  @override
  Future<void> storeLoginData({
    required Map<String, dynamic> json,
    required String password,
  }) async {
    await sharedPreferences.setString('token', jsonEncode(json));
  }
}
