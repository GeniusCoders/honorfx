import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:honorfx/cubit/ib_dashboard/ib_dashboard_state.dart';
import 'package:honorfx/models/ib_program/client_transaction_response.dart';
import 'package:honorfx/models/ib_program/ib_dashboard_response.dart';
import 'package:honorfx/models/ib_program/ib_monthly_commission_response.dart';
import 'package:honorfx/models/ib_program/top_earning_response.dart';
import 'package:honorfx/services/repo/ib_dashboard_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class IbDashboardCubit extends Cubit<IbDashboardState> {
  final IbDashboardRepo _ibDashboardRepo;
  IbDashboardData? _dashboardData;
  IbMonthlyCommissionData? _monthlyCommissionData;
  ClientTransactionData? _clientTransactionData;
  List<TopEarningData>? _topEarningData;

  IbDashboardCubit({required IbDashboardRepo ibDashboardRepo})
    : _ibDashboardRepo = ibDashboardRepo,
      super(IbDashboardInitial());

  Future<void> getIbDashboardData() async {
    emit(IbDashboardLoading());
    try {
      final result = await _ibDashboardRepo.getIbDashboardData();
      result.fold(
        (error) => emit(
          IbDashboardError(
            message: error.message ?? 'Failed to load IB dashboard data',
          ),
        ),
        (response) {
          if (response.status == 200 && response.data != null) {
            _dashboardData = response.data;

            // Emit appropriate state based on what data we already have
            _emitCombinedState();
          } else {
            emit(
              IbDashboardError(
                message: response.msg ?? 'Failed to load IB dashboard data',
              ),
            );
          }
        },
      );
    } catch (e) {
      emit(IbDashboardError(message: e.toString()));
    }
  }

  Future<void> getIbMonthlyCommission() async {
    emit(IbMonthlyCommissionLoading());
    try {
      final result = await _ibDashboardRepo.getIbMonthlyCommission();
      result.fold(
        (error) => emit(
          IbMonthlyCommissionError(
            message:
                error.message ?? 'Failed to load IB monthly commission data',
          ),
        ),
        (response) {
          if (response.status == 200 && response.data != null) {
            _monthlyCommissionData = response.data;

            // Emit appropriate state based on what data we already have
            _emitCombinedState();
          } else {
            emit(
              IbMonthlyCommissionError(
                message:
                    response.msg ?? 'Failed to load IB monthly commission data',
              ),
            );
          }
        },
      );
    } catch (e) {
      emit(IbMonthlyCommissionError(message: e.toString()));
    }
  }

  Future<void> getMyClientTransaction() async {
    emit(ClientTransactionLoading());
    try {
      final result = await _ibDashboardRepo.getMyClientTransaction();
      result.fold(
        (error) => emit(
          ClientTransactionError(
            message: error.message ?? 'Failed to load client transaction data',
          ),
        ),
        (response) {
          if (response.status == 200 && response.data != null) {
            _clientTransactionData = response.data;

            // Emit appropriate state based on what data we already have
            _emitCombinedState();
          } else {
            emit(
              ClientTransactionError(
                message:
                    response.msg ?? 'Failed to load client transaction data',
              ),
            );
          }
        },
      );
    } catch (e) {
      emit(ClientTransactionError(message: e.toString()));
    }
  }

  Future<void> getTopEarning() async {
    emit(TopEarningLoading());
    try {
      final result = await _ibDashboardRepo.getTopEarning();
      result.fold(
        (error) => emit(
          TopEarningError(
            message: error.message ?? 'Failed to load top earning data',
          ),
        ),
        (response) {
          if (response.status == 200 && response.data != null) {
            _topEarningData = response.data;

            // Emit appropriate state based on what data we already have
            _emitCombinedState();
          } else {
            emit(
              TopEarningError(
                message: response.msg ?? 'Failed to load top earning data',
              ),
            );
          }
        },
      );
    } catch (e) {
      emit(TopEarningError(message: e.toString()));
    }
  }

  // Helper method to emit state based on what data we have already loaded
  void _emitCombinedState() {
    if (_dashboardData != null &&
        _monthlyCommissionData != null &&
        _clientTransactionData != null) {
      emit(
        IbDashboardCompleteDataLoaded(
          dashboardData: _dashboardData!,
          monthlyCommissionData: _monthlyCommissionData!,
          clientTransactionData: _clientTransactionData!,
          topEarningData: _topEarningData,
        ),
      );
    } else if (_dashboardData != null && _monthlyCommissionData != null) {
      emit(
        IbDashboardAndMonthlyCommissionLoaded(
          dashboardData: _dashboardData!,
          monthlyCommissionData: _monthlyCommissionData!,
        ),
      );
    } else if (_dashboardData != null) {
      emit(IbDashboardLoaded(data: _dashboardData!));
    } else if (_monthlyCommissionData != null) {
      emit(IbMonthlyCommissionLoaded(data: _monthlyCommissionData!));
    } else if (_clientTransactionData != null) {
      emit(ClientTransactionLoaded(data: _clientTransactionData!));
    } else if (_topEarningData != null) {
      emit(TopEarningLoaded(data: _topEarningData!));
    }
  }

  Future<void> loadAllIbData() async {
    emit(IbDashboardLoading());
    await getIbDashboardData();
    await getIbMonthlyCommission();
    await getMyClientTransaction();
    await getTopEarning();
  }
}
