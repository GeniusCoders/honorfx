import 'package:dartz/dartz.dart';
import 'package:honorfx/models/ib_program/ib_dashboard_response.dart';
import 'package:honorfx/services/core/server_error.dart';

abstract class IbDashboardRepo {
  Future<Either<ServerError, IbDashboardResponse>> getIbDashboardData();
}
