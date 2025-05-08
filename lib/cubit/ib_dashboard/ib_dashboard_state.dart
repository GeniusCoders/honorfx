import 'package:honorfx/models/ib_program/client_transaction_response.dart';
import 'package:honorfx/models/ib_program/ib_dashboard_response.dart';
import 'package:honorfx/models/ib_program/ib_monthly_commission_response.dart';
import 'package:honorfx/models/ib_program/ib_withdraw_list_response.dart';
import 'package:honorfx/models/ib_program/my_clients_response.dart';
import 'package:honorfx/models/ib_program/my_commission_response.dart';
import 'package:honorfx/models/ib_program/top_earning_response.dart';

abstract class IbDashboardState {}

class IbDashboardInitial extends IbDashboardState {}

class IbDashboardLoading extends IbDashboardState {}

class IbDashboardLoaded extends IbDashboardState {
  final IbDashboardData data;

  IbDashboardLoaded({required this.data});
}

class IbDashboardError extends IbDashboardState {
  final String message;

  IbDashboardError({required this.message});
}

class IbMonthlyCommissionLoading extends IbDashboardState {}

class IbMonthlyCommissionLoaded extends IbDashboardState {
  final IbMonthlyCommissionData data;

  IbMonthlyCommissionLoaded({required this.data});
}

class IbMonthlyCommissionError extends IbDashboardState {
  final String message;

  IbMonthlyCommissionError({required this.message});
}

class ClientTransactionLoading extends IbDashboardState {}

class ClientTransactionLoaded extends IbDashboardState {
  final ClientTransactionData data;

  ClientTransactionLoaded({required this.data});
}

class ClientTransactionError extends IbDashboardState {
  final String message;

  ClientTransactionError({required this.message});
}

class TopEarningLoading extends IbDashboardState {}

class TopEarningLoaded extends IbDashboardState {
  final List<TopEarningData> data;

  TopEarningLoaded({required this.data});
}

class TopEarningError extends IbDashboardState {
  final String message;

  TopEarningError({required this.message});
}

class IbWithdrawListLoading extends IbDashboardState {}

class IbWithdrawListLoaded extends IbDashboardState {
  final List<IbWithdrawItem> data;

  IbWithdrawListLoaded({required this.data});
}

class IbWithdrawListError extends IbDashboardState {
  final String message;

  IbWithdrawListError({required this.message});
}

// My Clients States
class MyClientsLoading extends IbDashboardState {}

class MyClientsLevel1Loaded extends IbDashboardState {
  final List<ClientData> data;

  MyClientsLevel1Loaded({required this.data});
}

class MyClientsLevel2Loaded extends IbDashboardState {
  final List<ClientData> data;

  MyClientsLevel2Loaded({required this.data});
}

class MyClientsLevel3Loaded extends IbDashboardState {
  final List<ClientData> data;

  MyClientsLevel3Loaded({required this.data});
}

class MyClientsLevel4Loaded extends IbDashboardState {
  final List<ClientData> data;

  MyClientsLevel4Loaded({required this.data});
}

class MyClientsLevel5Loaded extends IbDashboardState {
  final List<ClientData> data;

  MyClientsLevel5Loaded({required this.data});
}

class MyClientsLevel6Loaded extends IbDashboardState {
  final List<ClientData> data;

  MyClientsLevel6Loaded({required this.data});
}

class MyClientsLevel7Loaded extends IbDashboardState {
  final List<ClientData> data;

  MyClientsLevel7Loaded({required this.data});
}

class MyClientsError extends IbDashboardState {
  final String message;

  MyClientsError({required this.message});
}

// My Commission States
class MyCommissionLoading extends IbDashboardState {}

class MyCommissionLoaded extends IbDashboardState {
  final List<MyCommissionItem> data;

  MyCommissionLoaded({required this.data});
}

class MyCommissionError extends IbDashboardState {
  final String message;

  MyCommissionError({required this.message});
}

class IbDashboardAndMonthlyCommissionLoaded extends IbDashboardState {
  final IbDashboardData dashboardData;
  final IbMonthlyCommissionData monthlyCommissionData;

  IbDashboardAndMonthlyCommissionLoaded({
    required this.dashboardData,
    required this.monthlyCommissionData,
  });
}

class IbDashboardCompleteDataLoaded extends IbDashboardState {
  final IbDashboardData dashboardData;
  final IbMonthlyCommissionData monthlyCommissionData;
  final ClientTransactionData clientTransactionData;
  final List<TopEarningData>? topEarningData;

  IbDashboardCompleteDataLoaded({
    required this.dashboardData,
    required this.monthlyCommissionData,
    required this.clientTransactionData,
    this.topEarningData,
  });
}
