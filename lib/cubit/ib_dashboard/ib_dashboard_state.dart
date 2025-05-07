import 'package:honorfx/models/ib_program/client_transaction_response.dart';
import 'package:honorfx/models/ib_program/ib_dashboard_response.dart';
import 'package:honorfx/models/ib_program/ib_monthly_commission_response.dart';
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
