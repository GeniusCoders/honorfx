import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:honorfx/models/common/response_details.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:honorfx/models/ib_program/client_transaction_response.dart';
import 'package:honorfx/models/ib_program/ib_dashboard_response.dart';
import 'package:honorfx/models/ib_program/ib_monthly_commission_response.dart';
import 'package:honorfx/models/ib_program/ib_withdraw_list_response.dart';
import 'package:honorfx/models/ib_program/my_clients_response.dart';
import 'package:honorfx/models/ib_program/my_commission_response.dart';
import 'package:honorfx/models/ib_program/top_earning_response.dart';
import 'package:honorfx/models/login_model.dart';
import 'package:honorfx/services/core/server_error.dart';
import 'package:honorfx/services/repo/ib_dashboard_repo.dart';

@Injectable(as: IbDashboardRepo)
class IbDashboardApi extends IbDashboardRepo {
  final Dio dio;
  final SharedPreferences sharedPreferences;
  TokenResponse? _tokenResponse;

  IbDashboardApi({required this.dio, required this.sharedPreferences}) {
    _setupToken();
  }

  // Set up token for authentication
  void _setupToken() {
    try {
      final _encodeData = sharedPreferences.getString('token');
      if (_encodeData != null) {
        final _data = json.decode(_encodeData);
        _tokenResponse = TokenResponse.fromJson(_data);

        // Set the authorization header
        if (_tokenResponse?.token != null) {
          dio.options.headers['Authorization'] =
              "Bearer ${_tokenResponse!.token}";
          log(
            "Bearer token set for IB Dashboard API: ${dio.options.headers['Authorization']}",
          );
        } else {
          log(
            "Token is null, cannot set authorization header for IB Dashboard API",
          );
        }
      } else {
        log("No token found in SharedPreferences for IB Dashboard API");
      }
    } catch (e) {
      log("Error setting up token for IB Dashboard API: $e");
    }
  }

  @override
  Future<Either<ServerError, IbDashboardResponse>> getIbDashboardData() async {
    try {
      _setupToken();
      const url = "/ibdashboarddata";
      log("Making API call to IB Dashboard: $url");

      final response = await dio.get(url);
      return right(IbDashboardResponse.fromJson(response.data));
    } on DioError catch (e) {
      log("DioError in getIbDashboardData: ${e.message}");
      return left(ServerError.withError(error: e));
    } catch (e) {
      log("General error in getIbDashboardData: $e");
      return left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ServerError, IbMonthlyCommissionResponse>>
  getIbMonthlyCommission() async {
    try {
      _setupToken();
      const url = "/ibmonthlycommission";
      log("Making API call to IB Monthly Commission: $url");

      final response = await dio.get(url);
      return right(IbMonthlyCommissionResponse.fromJson(response.data));
    } on DioError catch (e) {
      log("DioError in getIbMonthlyCommission: ${e.message}");
      return left(ServerError.withError(error: e));
    } catch (e) {
      log("General error in getIbMonthlyCommission: $e");
      return left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ServerError, ClientTransactionResponse>>
  getMyClientTransaction() async {
    try {
      _setupToken();
      const url = "/myclienttransaction";
      log("Making API call to My Client Transaction: $url");

      final response = await dio.get(url);
      return right(ClientTransactionResponse.fromJson(response.data));
    } on DioError catch (e) {
      log("DioError in getMyClientTransaction: ${e.message}");
      return left(ServerError.withError(error: e));
    } catch (e) {
      log("General error in getMyClientTransaction: $e");
      return left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ServerError, TopEarningResponse>> getTopEarning() async {
    try {
      _setupToken();
      const url = "/topearning";
      log("Making API call to Top Earning: $url");

      final response = await dio.get(url);
      return right(TopEarningResponse.fromJson(response.data));
    } on DioError catch (e) {
      log("DioError in getTopEarning: ${e.message}");
      return left(ServerError.withError(error: e));
    } catch (e) {
      log("General error in getTopEarning: $e");
      return left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ServerError, IbWithdrawListResponse>>
  getIbWithdrawList() async {
    try {
      _setupToken();
      const url = "/ibwithdrawlist";
      log("Making API call to IB Withdraw List: $url");

      final response = await dio.get(url);
      return right(IbWithdrawListResponse.fromJson(response.data));
    } on DioError catch (e) {
      log("DioError in getIbWithdrawList: ${e.message}");
      return left(ServerError.withError(error: e));
    } catch (e) {
      log("General error in getIbWithdrawList: $e");
      return left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ServerError, ResponseDetails>> submitIbWithdraw(
    String paymentMethod,
    String withdrawTo,
    String amount,
    String note,
  ) async {
    try {
      _setupToken();
      const url = "/ibwithdraw";
      log("Making API call to submit IB Withdraw: $url");

      final data = {
        'paymentmethod': paymentMethod,
        'withdraw_to': withdrawTo,
        'amount': amount,
        'note': note,
      };

      log("Submitting data: $data");
      final response = await dio.post(url, data: data);
      return right(ResponseDetails.fromJson(response.data));
    } on DioError catch (e) {
      log("DioError in submitIbWithdraw: ${e.message}");
      return left(ServerError.withError(error: e));
    } catch (e) {
      log("General error in submitIbWithdraw: $e");
      return left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ServerError, MyCommissionResponse>> getMyCommission(
    String from,
    String to,
  ) async {
    try {
      _setupToken();
      const url = "/mycommission";
      log("Making API call to My Commission: $url with from=$from, to=$to");

      final response = await dio.post(url, data: {'from': from, 'to': to});
      return right(MyCommissionResponse.fromJson(response.data));
    } on DioError catch (e) {
      log("DioError in getMyCommission: ${e.message}");
      return left(ServerError.withError(error: e));
    } catch (e) {
      log("General error in getMyCommission: $e");
      return left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ServerError, MyClientsResponse>> getMyClientsLevel1() async {
    return _getMyClients("/myclientslevel1");
  }

  @override
  Future<Either<ServerError, MyClientsResponse>> getMyClientsLevel2() async {
    return _getMyClients("/myclientslevel2");
  }

  @override
  Future<Either<ServerError, MyClientsResponse>> getMyClientsLevel3() async {
    return _getMyClients("/myclientslevel3");
  }

  @override
  Future<Either<ServerError, MyClientsResponse>> getMyClientsLevel4() async {
    return _getMyClients("/myclientslevel4");
  }

  @override
  Future<Either<ServerError, MyClientsResponse>> getMyClientsLevel5() async {
    return _getMyClients("/myclientslevel5");
  }

  @override
  Future<Either<ServerError, MyClientsResponse>> getMyClientsLevel6() async {
    return _getMyClients("/myclientslevel6");
  }

  @override
  Future<Either<ServerError, MyClientsResponse>> getMyClientsLevel7() async {
    return _getMyClients("/myclientslevel7");
  }

  // Helper method to reduce code duplication
  Future<Either<ServerError, MyClientsResponse>> _getMyClients(
    String endpoint,
  ) async {
    try {
      _setupToken();
      log("Making API call to: $endpoint");

      final response = await dio.get(endpoint);
      return right(MyClientsResponse.fromJson(response.data));
    } on DioError catch (e) {
      log("DioError in $endpoint: ${e.message}");
      return left(ServerError.withError(error: e));
    } catch (e) {
      log("General error in $endpoint: $e");
      return left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ServerError, ResponseDetails>> requestIbStatus() async {
    try {
      _setupToken();
      const url = "/ibrequest";
      log("Making API call to request IB status: $url");

      final response = await dio.post(url);
      return right(ResponseDetails.fromJson(response.data));
    } on DioError catch (e) {
      log("DioError in requestIbStatus: ${e.message}");
      return left(ServerError.withError(error: e));
    } catch (e) {
      log("General error in requestIbStatus: $e");
      return left(ServerError(message: e.toString()));
    }
  }
}
