import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:honorfx/models/ib_program/ib_dashboard_response.dart';
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
}
