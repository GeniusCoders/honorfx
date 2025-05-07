import 'package:honorfx/models/ib_program/ib_dashboard_response.dart';
import 'package:honorfx/models/ib_program/ib_monthly_commission_response.dart';

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

class IbDashboardAndMonthlyCommissionLoaded extends IbDashboardState {
  final IbDashboardData dashboardData;
  final IbMonthlyCommissionData monthlyCommissionData;

  IbDashboardAndMonthlyCommissionLoaded({
    required this.dashboardData,
    required this.monthlyCommissionData,
  });
}
