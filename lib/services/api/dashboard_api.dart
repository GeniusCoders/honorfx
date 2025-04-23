import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:honorfx/controllers/dashboard_controller.dart';
import 'package:honorfx/cubit/auth/auth_cubit.dart';
import 'package:honorfx/injection.dart';
import 'package:get/get.dart' as getcontroller;
import 'package:honorfx/models/dashboard/account_details_response.dart';
import 'package:honorfx/models/dashboard/account_listing_type_model.dart';
import 'package:honorfx/models/login_model.dart';
import 'package:honorfx/router/app_router.dart';
import 'package:honorfx/utils/constant/strings.dart';
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
    final _encodeData = sharedPreferences.getString('token');
    final _data = json.decode(_encodeData!);
    final TokenResponse _tokenResponse = TokenResponse.fromJson(_data);
    log(_tokenResponse.token.toString());
    dio.options.headers['Authorization'] = "Bearer ${_tokenResponse.token}";
    dio.interceptors.addAll([
      if (kDebugMode)
        LogInterceptor(
          request: true,
          requestHeader: false,
          responseHeader: false,
          requestBody: true,
          responseBody: true,
          logPrint: (obj) {
            log(obj.toString());
          },
        ),
      InterceptorsWrapper(
        onResponse: (response, handler) {
          var htmlRegex = RegExp(Constant.htmlRegex);

          if (htmlRegex.hasMatch(response.data.toString()) &&
              response.data.toString().contains("Honorfx Portal | Account")) {
            getIt<AuthCubit>().logout();
            if (getcontroller.Get.isRegistered<DashboardController>()) {
              getcontroller.Get.delete<DashboardController>();
            }
            getIt<AppRouter>().goToLogin();
          } else {
            handler.next(response);
          }
        },
        onError: (error, handler) {
          if (error.response != null) {
            if (error.response!.statusCode == 302) {
              var htmlRegex = RegExp(Constant.htmlRegex);
              if (htmlRegex.hasMatch(error.response!.data.toString())) {
                getIt<AuthCubit>().logout();
                if (getcontroller.Get.isRegistered<DashboardController>()) {
                  getcontroller.Get.delete<DashboardController>();
                }
                getIt<AppRouter>().goToLogin();
              } else {
                handler.next(error);
              }
            }
          }
        },
      ),
    ]);
  }

  @override
  Future<Either<ServerError, AccountListingTypeModel>> getAccounts() async {
    try {
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
      final url = "/accountdetails/$accountId";
      final response = await dio.get(url);

      return right(AccountDetailsResponse.fromJson(response.data));
    } on DioError catch (e) {
      return left(ServerError.withError(error: e));
    } catch (e) {
      return left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<TokenResponse> getTokenData() async {
    final _encodeData = sharedPreferences.getString('token');
    final _data = json.decode(_encodeData!);
    final tokenData = TokenResponse.fromJson(_data);
    return tokenData;
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
