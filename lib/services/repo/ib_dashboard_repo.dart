import 'package:dartz/dartz.dart';
import 'package:honorfx/models/ib_program/client_transaction_response.dart';
import 'package:honorfx/models/ib_program/ib_dashboard_response.dart';
import 'package:honorfx/models/ib_program/ib_monthly_commission_response.dart';
import 'package:honorfx/models/ib_program/ib_withdraw_list_response.dart';
import 'package:honorfx/models/ib_program/my_clients_response.dart';
import 'package:honorfx/models/ib_program/top_earning_response.dart';
import 'package:honorfx/services/core/server_error.dart';

abstract class IbDashboardRepo {
  Future<Either<ServerError, IbDashboardResponse>> getIbDashboardData();
  Future<Either<ServerError, IbMonthlyCommissionResponse>>
  getIbMonthlyCommission();
  Future<Either<ServerError, ClientTransactionResponse>>
  getMyClientTransaction();
  Future<Either<ServerError, TopEarningResponse>> getTopEarning();
  Future<Either<ServerError, IbWithdrawListResponse>> getIbWithdrawList();

  // New methods for fetching clients at different levels
  Future<Either<ServerError, MyClientsResponse>> getMyClientsLevel1();
  Future<Either<ServerError, MyClientsResponse>> getMyClientsLevel2();
  Future<Either<ServerError, MyClientsResponse>> getMyClientsLevel3();
  Future<Either<ServerError, MyClientsResponse>> getMyClientsLevel4();
  Future<Either<ServerError, MyClientsResponse>> getMyClientsLevel5();
  Future<Either<ServerError, MyClientsResponse>> getMyClientsLevel6();
  Future<Either<ServerError, MyClientsResponse>> getMyClientsLevel7();
}
