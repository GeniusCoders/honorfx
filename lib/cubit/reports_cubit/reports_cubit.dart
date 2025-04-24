import 'package:bloc/bloc.dart';
import 'package:honorfx/models/dashboard/reports_model/deposit_report_model.dart';
import 'package:honorfx/models/dashboard/reports_model/withdraw_report_model.dart';
import 'package:honorfx/services/repo/dashboard_repo.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'reports_state.dart';

@injectable
class ReportsCubit extends Cubit<ReportsState> {
  final DashboardRepo _dashboardRepo;
  ReportsCubit({required DashboardRepo dashboardRepo})
    : _dashboardRepo = dashboardRepo,
      super(ReportsInitial());

  Future<void> getDepositReport() async {
    emit(ReportsLoading());
    final result = await _dashboardRepo.depositReport();
    result.fold(
      (l) => emit(ReportsError(error: l.message ?? "Something went wrong")),
      (r) => emit(DepositReportLoaded(depositReport: r.data ?? [])),
    );
  }

  Future<void> getWithdrawReport() async {
    emit(ReportsLoading());
    final result = await _dashboardRepo.withdrawReport();
    result.fold(
      (l) => emit(ReportsError(error: l.message ?? "Something went wrong")),
      (r) => emit(WithdrawReportLoaded(withdrawReport: r.data ?? [])),
    );
  }
}
