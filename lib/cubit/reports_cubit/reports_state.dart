part of 'reports_cubit.dart';

@immutable
sealed class ReportsState {}

final class ReportsInitial extends ReportsState {}

final class ReportsLoading extends ReportsState {}

final class ReportsError extends ReportsState {
  final String error;
  ReportsError({required this.error});
}

final class DepositReportLoaded extends ReportsState {
  final List<DepositReportData> depositReport;
  DepositReportLoaded({required this.depositReport});
}

final class WithdrawReportLoaded extends ReportsState {
  final List<WithdrawReportData> withdrawReport;
  WithdrawReportLoaded({required this.withdrawReport});
}

// Open Positions state
class OpenPositionsReportLoaded extends ReportsState {
  final List<OpenPositionData> data;

  OpenPositionsReportLoaded({required this.data});
}
