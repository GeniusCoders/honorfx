import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:honorfx/cubit/ib_dashboard/ib_dashboard_state.dart';
import 'package:honorfx/models/ib_program/ib_dashboard_response.dart';
import 'package:honorfx/models/ib_program/ib_monthly_commission_response.dart';
import 'package:honorfx/services/repo/ib_dashboard_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class IbDashboardCubit extends Cubit<IbDashboardState> {
  final IbDashboardRepo _ibDashboardRepo;
  IbDashboardData? _dashboardData;
  IbMonthlyCommissionData? _monthlyCommissionData;

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

            // If we already have monthly commission data, emit combined state
            if (_monthlyCommissionData != null) {
              emit(
                IbDashboardAndMonthlyCommissionLoaded(
                  dashboardData: _dashboardData!,
                  monthlyCommissionData: _monthlyCommissionData!,
                ),
              );
            } else {
              emit(IbDashboardLoaded(data: _dashboardData!));
            }
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

            // If we already have dashboard data, emit combined state
            if (_dashboardData != null) {
              emit(
                IbDashboardAndMonthlyCommissionLoaded(
                  dashboardData: _dashboardData!,
                  monthlyCommissionData: _monthlyCommissionData!,
                ),
              );
            } else {
              emit(IbMonthlyCommissionLoaded(data: _monthlyCommissionData!));
            }
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

  Future<void> loadAllIbData() async {
    emit(IbDashboardLoading());
    await getIbDashboardData();
    await getIbMonthlyCommission();
  }
}
