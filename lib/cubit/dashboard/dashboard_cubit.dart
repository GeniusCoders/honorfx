import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:honorfx/cubit/dashboard/dashboard_state.dart';
import 'package:honorfx/services/repo/dashboard_repo.dart';

@injectable
class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepo _dashboardRepo;

  DashboardCubit({required DashboardRepo dashboardRepo})
    : _dashboardRepo = dashboardRepo,
      super(DashboardInitial());

  Future<void> getAccounts() async {
    emit(AccountsLoading());
    try {
      final result = await _dashboardRepo.getAccounts();
      result.fold(
        (error) => emit(
          AccountsError(message: error.message ?? 'Failed to load accounts'),
        ),
        (accountList) {
          if (accountList.status == 200) {
            if (accountList.data != null) {
              emit(AccountsLoaded(accounts: accountList.data!));
            } else {
              emit(AccountsLoaded(accounts: []));
            }
          } else {
            emit(
              AccountsError(
                message: accountList.msg ?? 'Failed to load accounts',
              ),
            );
          }
        },
      );
    } catch (e) {
      emit(AccountsError(message: e.toString()));
    }
  }

  // Additional methods for other dashboard data
  // Future<void> getOpenPositions() async {
  //   // Implementation
  // }

  // Future<void> getTransactions() async {
  //   // Implementation
  // }
}
