import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:honorfx/models/dashboard/account_details_response.dart';
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

  @override
  Future<Either<ServerError, AccountDetailsResponse>> accountDetails({
    required String accountId,
  }) async {
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
      final url = "/accountdetails/$accountId";
      final response = await dio.get(url);
      dynamic _data = {};
      if (accountId == "965215") {
        _data = {
          "status": 200,
          "msg": "Success",
          "data": {
            "Login": 965215,
            "CurrencyDigits": 2,
            "Balance": "100.0000",
            "Credit": "0.0000",
            "Margin": 0,
            "MarginLeverage": 10,
            "Profit": 0,
            "Equity": "0.0000",
            "Assets": 0,
            "Registration": "22 Apr 2025",
            "Leverage": 10,
            "EquityPrevDay": "0.0000",
          },
        };
      } else if (accountId == "965216") {
        _data = {
          "status": 200,
          "msg": "Success",
          "data": {
            "Login": 965216,
            "CurrencyDigits": 2,
            "Balance": "10.0000",
            "Credit": "0.0000",
            "Margin": 0,
            "MarginLeverage": 100,
            "Profit": 0,
            "Equity": "0.0000",
            "Assets": 0,
            "Registration": "22 Apr 2025",
            "Leverage": 100,
            "EquityPrevDay": "0.0000",
          },
        };
      }

      return right(AccountDetailsResponse.fromJson(_data));
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
