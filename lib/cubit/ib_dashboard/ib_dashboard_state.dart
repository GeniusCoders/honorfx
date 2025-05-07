import 'package:honorfx/models/ib_program/ib_dashboard_response.dart';

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
