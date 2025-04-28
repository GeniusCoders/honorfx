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
import 'package:honorfx/models/dashboard/reports_model/deposit_report_model.dart';
import 'package:honorfx/models/dashboard/reports_model/withdraw_report_model.dart';
import 'package:honorfx/models/login_model.dart';
import 'package:honorfx/router/app_router.dart';
import 'package:honorfx/utils/constant/strings.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dartz/dartz.dart';
import 'package:honorfx/services/core/server_error.dart';
import 'package:honorfx/services/repo/dashboard_repo.dart';
import 'package:honorfx/models/dashboard/open_positions_model.dart';
import 'package:honorfx/models/dashboard/group_list_model.dart';
import 'package:honorfx/models/dashboard/leverage_list_model.dart';
import 'package:honorfx/models/dashboard/open_account_response.dart';
import 'package:honorfx/models/dashboard/internal_transfer_response.dart';
import 'package:honorfx/models/dashboard/withdraw_response.dart';
import 'package:honorfx/models/dashboard/wallet_transfer_response.dart';

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

  @override
  Future<Either<ServerError, OpenPositionsResponse>>
  openPositionsReport() async {
    try {
      _setupToken();

      String url = "/openpositions";

      final response = await dio.get(url);

      return right(OpenPositionsResponse.fromJson(response.data));
    } on DioError catch (e) {
      log("DioError in openPositionsReport: ${e.message}");
      return left(ServerError.withError(error: e));
    } catch (e) {
      log("General error in openPositionsReport: $e");
      return left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ServerError, DepositReportResponse>> depositReport() async {
    Response response;
    try {
      const _url = "/depositlist";
      response = await dio.get(_url);
      return right(DepositReportResponse.fromJson(response.data));
    } on DioError catch (e) {
      return left(ServerError.withError(error: e));
    }
  }

  @override
  Future<Either<ServerError, WithdrawReportResponse>> withdrawReport() async {
    Response response;
    try {
      const _url = "/withdrawlist";
      response = await dio.get(_url);
      return right(WithdrawReportResponse.fromJson(response.data));
    } on DioError catch (e) {
      return left(ServerError.withError(error: e));
    }
  }

  @override
  Future<Either<ServerError, GroupListResponse>> getGroupList() async {
    try {
      _setupToken();
      const url = "/grouplist";
      final response = await dio.get(url);
      return right(GroupListResponse.fromJson(response.data));
    } on DioError catch (e) {
      log("DioError in getGroupList: ${e.message}");
      return left(ServerError.withError(error: e));
    } catch (e) {
      log("General error in getGroupList: $e");
      return left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ServerError, LeverageListResponse>> getLeverageList() async {
    try {
      _setupToken();
      const url = "/leveragelist";
      final response = await dio.get(url);
      return right(LeverageListResponse.fromJson(response.data));
    } on DioError catch (e) {
      log("DioError in getLeverageList: ${e.message}");
      return left(ServerError.withError(error: e));
    } catch (e) {
      log("General error in getLeverageList: $e");
      return left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ServerError, OpenAccountResponse>> openLiveAccount({
    required String group,
    required String leverage,
    required String mainPassword,
    required String investorPassword,
  }) async {
    try {
      _setupToken();
      const url = "/openliveaccount";
      final Map<String, dynamic> data = {
        'group': group,
        'leverage': leverage,
        'main_password': mainPassword,
        'investor_password': investorPassword,
      };

      final response = await dio.post(url, data: data);
      return right(OpenAccountResponse.fromJson(response.data));
    } on DioError catch (e) {
      log("DioError in openLiveAccount: ${e.message}");
      return left(ServerError.withError(error: e));
    } catch (e) {
      log("General error in openLiveAccount: $e");
      return left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ServerError, InternalTransferResponse>> internalTransfer({
    required String fromAccount,
    required String toAccount,
    required String amount,
  }) async {
    try {
      _setupToken();
      const url = "/internaltransfer";
      final Map<String, dynamic> data = {
        'from': fromAccount,
        'to': toAccount,
        'amount': amount,
      };

      final response = await dio.post(url, data: data);
      return right(InternalTransferResponse.fromJson(response.data));
    } on DioError catch (e) {
      log("DioError in internalTransfer: ${e.message}");
      return left(ServerError.withError(error: e));
    } catch (e) {
      log("General error in internalTransfer: $e");
      return left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ServerError, WithdrawResponse>> withdraw({
    required String mt5id,
    required String withdrawTo,
    required String amount,
    required String note,
    required String paymentMethod,
  }) async {
    try {
      _setupToken();
      const url = "/withdraw";
      final Map<String, dynamic> data = {
        'mt5id': mt5id,
        'withdraw_to': withdrawTo,
        'amount': amount,
        'paymentmethod': paymentMethod,
        'note': note,
      };

      final response = await dio.post(url, data: data);
      return right(WithdrawResponse.fromJson(response.data));
    } on DioError catch (e) {
      return left(ServerError.withError(error: e));
    } catch (e) {
      return left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ServerError, WalletTransferResponse>> walletToMt5({
    required String mt5id,
    required String amount,
    required String note,
  }) async {
    try {
      _setupToken();
      const url = "/wallettomt5";
      final Map<String, dynamic> data = {
        'mt5id': mt5id,
        'amount': amount,
        'note': note,
      };

      final response = await dio.post(url, data: data);
      return right(WalletTransferResponse.fromJson(response.data));
    } on DioError catch (e) {
      log("DioError in walletToMt5: ${e.message}");
      return left(ServerError.withError(error: e));
    } catch (e) {
      log("General error in walletToMt5: $e");
      return left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ServerError, WalletTransferResponse>> mt5ToWallet({
    required String mt5id,
    required String amount,
    required String note,
  }) async {
    try {
      _setupToken();
      const url = "/mt5towallet";
      final Map<String, dynamic> data = {
        'mt5id': mt5id,
        'amount': amount,
        'note': note,
      };

      final response = await dio.post(url, data: data);
      return right(WalletTransferResponse.fromJson(response.data));
    } on DioError catch (e) {
      log("DioError in mt5ToWallet: ${e.message}");
      return left(ServerError.withError(error: e));
    } catch (e) {
      log("General error in mt5ToWallet: $e");
      return left(ServerError(message: e.toString()));
    }
  }
}
