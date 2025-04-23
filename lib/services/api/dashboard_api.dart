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
  TokenResponse? _tokenResponse;

  DashboardApi({required this.dio, required this.sharedPreferences}) {
    _setupInterceptors();
  }

  // Separate method to set up token
  void _setupToken() {
    try {
      final _encodeData = sharedPreferences.getString('token');
      if (_encodeData != null) {
        final _data = json.decode(_encodeData);
        _tokenResponse = TokenResponse.fromJson(_data);
        log("Token setup: ${_tokenResponse?.token}");

        // Set the authorization header
        if (_tokenResponse?.token != null) {
          dio.options.headers['Authorization'] =
              "Bearer ${_tokenResponse!.token}";
          log(
            "Bearer token set successfully: ${dio.options.headers['Authorization']}",
          );
        } else {
          log("Token is null, cannot set authorization header");
        }
      } else {
        log("No token found in SharedPreferences");
      }
    } catch (e) {
      log("Error setting up token: $e");
    }
  }

  // Separate method for interceptors
  void _setupInterceptors() {
    dio.interceptors.addAll([
      if (kDebugMode)
        LogInterceptor(
          request: true,
          requestHeader: true,
          responseHeader: false,
          requestBody: true,
          responseBody: true,
          // logPrint: (obj) {
          //   log(obj.toString());
          // },
        ),
      InterceptorsWrapper(
        onResponse: (response, handler) {
          var htmlRegex = RegExp(Constant.htmlRegex);

          if (htmlRegex.hasMatch(response.data.toString()) &&
              response.data.toString().contains("Honorfx Portal | Account")) {
            log("Session expired, logging out");
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
          log("API Error: ${error.message}");

          if (error.response != null) {
            log("Error status code: ${error.response!.statusCode}");

            if (error.response!.statusCode == 302) {
              var htmlRegex = RegExp(Constant.htmlRegex);
              if (htmlRegex.hasMatch(error.response!.data.toString())) {
                log("Session expired in error handler, logging out");
                getIt<AuthCubit>().logout();
                if (getcontroller.Get.isRegistered<DashboardController>()) {
                  getcontroller.Get.delete<DashboardController>();
                }
                getIt<AppRouter>().goToLogin();
              } else {
                handler.next(error);
              }
            } else if (error.response!.statusCode == 401) {
              // Handle unauthorized errors
              log("Unauthorized error (401), token may be invalid");
              getIt<AuthCubit>().logout();
              getIt<AppRouter>().goToLogin();
            } else {
              handler.next(error);
            }
          } else {
            handler.next(error);
          }
        },
      ),
    ]);
  }

  // Public method to refresh token if needed
  Future<void> refreshToken() async {
    _setupToken();
  }

  @override
  Future<Either<ServerError, AccountListingTypeModel>> getAccounts() async {
    try {
      _setupToken();
      const url = "/accountlist";
      log("Making API call to: $url");
      final response = await dio.get(url);

      return right(AccountListingTypeModel.fromJson(response.data));
    } on DioError catch (e) {
      log("DioError in getAccounts: ${e.message}");
      return left(ServerError.withError(error: e));
    } catch (e) {
      log("General error in getAccounts: $e");
      return left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ServerError, AccountDetailsResponse>> accountDetails({
    required String accountId,
  }) async {
    try {
      _setupToken();

      final url = "/accountdetails/$accountId";
      log("Making API call to: $url");
      final response = await dio.get(url);

      return right(AccountDetailsResponse.fromJson(response.data));
    } on DioError catch (e) {
      log("DioError in accountDetails: ${e.message}");
      return left(ServerError.withError(error: e));
    } catch (e) {
      log("General error in accountDetails: $e");
      return left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<TokenResponse> getTokenData() async {
    try {
      final _encodeData = sharedPreferences.getString('token');
      if (_encodeData == null) {
        throw Exception("No token found in SharedPreferences");
      }

      final _data = json.decode(_encodeData);
      final tokenData = TokenResponse.fromJson(_data);

      // Also update the stored token response and headers
      _tokenResponse = tokenData;
      if (tokenData.token != null) {
        dio.options.headers['Authorization'] = "Bearer ${tokenData.token}";
        log(
          "Bearer token updated in getTokenData: ${dio.options.headers['Authorization']}",
        );
      }

      return tokenData;
    } catch (e) {
      log("Error in getTokenData: $e");
      rethrow;
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
