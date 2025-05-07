import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:honorfx/cubit/ib_dashboard/ib_dashboard_state.dart';
import 'package:honorfx/services/repo/ib_dashboard_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class IbDashboardCubit extends Cubit<IbDashboardState> {
  final IbDashboardRepo _ibDashboardRepo;

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
            emit(IbDashboardLoaded(data: response.data!));
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
}
