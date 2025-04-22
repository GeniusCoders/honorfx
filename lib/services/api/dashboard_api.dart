import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:honorfx/models/dashboard/account_listing_type_model.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dartz/dartz.dart';
import 'package:honorfx/services/core/server_error.dart';
import 'package:honorfx/services/repo/dashboard_repo.dart';

@Injectable(as: DashboardRepo)
class DashboardApi extends DashboardRepo {
  final Dio dio;
  final SharedPreferences sharedPreferences;

  DashboardApi({required this.dio, required this.sharedPreferences}) {
    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          request: false,
          requestHeader: false,
          responseHeader: false,
          requestBody: true,
          responseBody: true,
          logPrint: (message) {
            log(message.toString());
          },
        ),
      );
    }
  }

  @override
  Future<Either<ServerError, AccountListingTypeModel>> getAccounts() async {
    try {
      final tokenJson = sharedPreferences.getString('token');
      if (tokenJson == null) {
        return left(ServerError(message: 'Not authenticated'));
      }

      final tokenData = jsonDecode(tokenJson);
      final token = tokenData['token'];

      if (token == null) {
        return left(ServerError(message: 'Invalid token'));
      }

      dio.options.headers['Authorization'] = 'Bearer $token';
      const url = "/accountlist";
      final response = await dio.get(url);

      return right(AccountListingTypeModel.fromJson(response.data));
    } on DioError catch (e) {
      return left(ServerError.withError(error: e));
    } catch (e) {
      return left(ServerError(message: e.toString()));
    }
  }

  // Additional dashboard API methods implementation:
  // @override
  // Future<Either<ServerError, PositionListModel>> getOpenPositions() async {
  //   // Implementation here
  // }

  // @override
  // Future<Either<ServerError, TransactionListModel>> getTransactions() async {
  //   // Implementation here
  // }
}
