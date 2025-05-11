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

  Future<void> getIbMonthlyCommission() async {
    emit(IbDashboardLoading());
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
            emit(IbMonthlyCommissionLoaded(data: response.data!));
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
    emit(IbDashboardLoading());
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
            emit(ClientTransactionLoaded(data: response.data!));
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
    emit(IbDashboardLoading());
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
            emit(TopEarningLoaded(data: response.data!));
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

  Future<void> getIbWithdrawList() async {
    emit(IbWithdrawListLoading());
    try {
      final result = await _ibDashboardRepo.getIbWithdrawList();
      result.fold(
        (error) => emit(
          IbWithdrawListError(
            message: error.message ?? 'Failed to load withdraw list data',
          ),
        ),
        (response) {
          if (response.status == 200 && response.data != null) {
            emit(IbWithdrawListLoaded(data: response.data!));
          } else {
            emit(
              IbWithdrawListError(
                message: response.msg ?? 'Failed to load withdraw list data',
              ),
            );
          }
        },
      );
    } catch (e) {
      emit(IbWithdrawListError(message: e.toString()));
    }
  }

  Future<void> submitIbWithdraw(
    String paymentMethod,
    String withdrawTo,
    String amount,
    String note,
  ) async {
    emit(IbWithdrawSubmitting());
    try {
      final result = await _ibDashboardRepo.submitIbWithdraw(
        paymentMethod,
        withdrawTo,
        amount,
        note,
      );

      result.fold(
        (error) => emit(
          IbWithdrawSubmitError(
            message: error.message ?? 'Failed to submit withdrawal request',
          ),
        ),
        (response) {
          if (response.status == 200) {
            emit(
              IbWithdrawSubmitted(
                message: response.msg ?? 'Withdrawal submitted successfully',
              ),
            );
          } else {
            emit(
              IbWithdrawSubmitError(
                message: response.msg ?? 'Failed to submit withdrawal request',
              ),
            );
          }
        },
      );
    } catch (e) {
      emit(IbWithdrawSubmitError(message: e.toString()));
    }
  }

  Future<void> requestIbStatus() async {
    emit(IbRequestSubmitting());
    try {
      final result = await _ibDashboardRepo.requestIbStatus();

      result.fold(
        (error) => emit(
          IbRequestError(
            message: error.message ?? 'Failed to submit IB request',
          ),
        ),
        (response) {
          if (response.status == 200) {
            emit(
              IbRequestSubmitted(
                message: response.msg ?? 'IB request submitted successfully',
              ),
            );
          } else {
            emit(
              IbRequestError(
                message: response.msg ?? 'Failed to submit IB request',
              ),
            );
          }
        },
      );
    } catch (e) {
      emit(IbRequestError(message: e.toString()));
    }
  }

  Future<void> getMyCommission(String from, String to) async {
    emit(MyCommissionLoading());
    try {
      final result = await _ibDashboardRepo.getMyCommission(from, to);
      result.fold(
        (error) => emit(
          MyCommissionError(
            message: error.message ?? 'Failed to load commission data',
          ),
        ),
        (response) {
          if (response.status == 200 && response.data != null) {
            emit(MyCommissionLoaded(data: response.data!));
          } else {
            emit(
              MyCommissionError(
                message: response.msg ?? 'Failed to load commission data',
              ),
            );
          }
        },
      );
    } catch (e) {
      emit(MyCommissionError(message: e.toString()));
    }
  }

  // Methods for fetching clients at different levels
  Future<void> getMyClientsLevel1() async {
    emit(MyClientsLoading());
    try {
      final result = await _ibDashboardRepo.getMyClientsLevel1();
      result.fold(
        (error) => emit(
          MyClientsError(
            message: error.message ?? 'Failed to load level 1 clients data',
          ),
        ),
        (response) {
          if (response.status == 200 && response.data != null) {
            emit(MyClientsLevel1Loaded(data: response.data!));
          } else if (response.status == 301 &&
              response.msg == "No data found.") {
            emit(MyClientsLevel1Loaded(data: []));
          } else {
            emit(
              MyClientsError(
                message: response.msg ?? 'Failed to load level 1 clients data',
              ),
            );
          }
        },
      );
    } catch (e) {
      emit(MyClientsError(message: e.toString()));
    }
  }

  Future<void> getMyClientsLevel2() async {
    emit(MyClientsLoading());
    try {
      final result = await _ibDashboardRepo.getMyClientsLevel2();
      result.fold(
        (error) => emit(
          MyClientsError(
            message: error.message ?? 'Failed to load level 2 clients data',
          ),
        ),
        (response) {
          if (response.status == 200 && response.data != null) {
            emit(MyClientsLevel2Loaded(data: response.data!));
          } else if (response.status == 301 &&
              response.msg == "No data found.") {
            emit(MyClientsLevel2Loaded(data: []));
          } else {
            emit(
              MyClientsError(
                message: response.msg ?? 'Failed to load level 2 clients data',
              ),
            );
          }
        },
      );
    } catch (e) {
      emit(MyClientsError(message: e.toString()));
    }
  }

  Future<void> getMyClientsLevel3() async {
    emit(MyClientsLoading());
    try {
      final result = await _ibDashboardRepo.getMyClientsLevel3();
      result.fold(
        (error) => emit(
          MyClientsError(
            message: error.message ?? 'Failed to load level 3 clients data',
          ),
        ),
        (response) {
          if (response.status == 200 && response.data != null) {
            emit(MyClientsLevel3Loaded(data: response.data!));
          } else if (response.status == 301 &&
              response.msg == "No data found.") {
            emit(MyClientsLevel3Loaded(data: []));
          } else {
            emit(
              MyClientsError(
                message: response.msg ?? 'Failed to load level 3 clients data',
              ),
            );
          }
        },
      );
    } catch (e) {
      emit(MyClientsError(message: e.toString()));
    }
  }

  Future<void> getMyClientsLevel4() async {
    emit(MyClientsLoading());
    try {
      final result = await _ibDashboardRepo.getMyClientsLevel4();
      result.fold(
        (error) => emit(
          MyClientsError(
            message: error.message ?? 'Failed to load level 4 clients data',
          ),
        ),
        (response) {
          if (response.status == 200 && response.data != null) {
            emit(MyClientsLevel4Loaded(data: response.data!));
          } else if (response.status == 301 &&
              response.msg == "No data found.") {
            emit(MyClientsLevel4Loaded(data: []));
          } else {
            emit(
              MyClientsError(
                message: response.msg ?? 'Failed to load level 4 clients data',
              ),
            );
          }
        },
      );
    } catch (e) {
      emit(MyClientsError(message: e.toString()));
    }
  }

  Future<void> getMyClientsLevel5() async {
    emit(MyClientsLoading());
    try {
      final result = await _ibDashboardRepo.getMyClientsLevel5();
      result.fold(
        (error) => emit(
          MyClientsError(
            message: error.message ?? 'Failed to load level 5 clients data',
          ),
        ),
        (response) {
          if (response.status == 200 && response.data != null) {
            emit(MyClientsLevel5Loaded(data: response.data!));
          } else if (response.status == 301 &&
              response.msg == "No data found.") {
            emit(MyClientsLevel5Loaded(data: []));
          } else {
            emit(
              MyClientsError(
                message: response.msg ?? 'Failed to load level 5 clients data',
              ),
            );
          }
        },
      );
    } catch (e) {
      emit(MyClientsError(message: e.toString()));
    }
  }

  Future<void> getMyClientsLevel6() async {
    emit(MyClientsLoading());
    try {
      final result = await _ibDashboardRepo.getMyClientsLevel6();
      result.fold(
        (error) => emit(
          MyClientsError(
            message: error.message ?? 'Failed to load level 6 clients data',
          ),
        ),
        (response) {
          if (response.status == 200 && response.data != null) {
            emit(MyClientsLevel6Loaded(data: response.data!));
          } else if (response.status == 301 &&
              response.msg == "No data found.") {
            emit(MyClientsLevel6Loaded(data: []));
          } else {
            emit(
              MyClientsError(
                message: response.msg ?? 'Failed to load level 6 clients data',
              ),
            );
          }
        },
      );
    } catch (e) {
      emit(MyClientsError(message: e.toString()));
    }
  }

  Future<void> getMyClientsLevel7() async {
    emit(MyClientsLoading());
    try {
      final result = await _ibDashboardRepo.getMyClientsLevel7();
      result.fold(
        (error) => emit(
          MyClientsError(
            message: error.message ?? 'Failed to load level 7 clients data',
          ),
        ),
        (response) {
          if (response.status == 200 && response.data != null) {
            emit(MyClientsLevel7Loaded(data: response.data!));
          } else if (response.status == 301 &&
              response.msg == "No data found.") {
            emit(MyClientsLevel7Loaded(data: []));
          } else {
            emit(
              MyClientsError(
                message: response.msg ?? 'Failed to load level 7 clients data',
              ),
            );
          }
        },
      );
    } catch (e) {
      emit(MyClientsError(message: e.toString()));
    }
  }

  Future<void> loadAllIbData() async {
    emit(IbDashboardLoading());
    await Future.wait([
      getIbDashboardData(),
      getIbMonthlyCommission(),
      getMyClientTransaction(),
      getTopEarning(),
    ]);
  }
}
