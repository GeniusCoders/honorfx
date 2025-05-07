import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:honorfx/cubit/ib_dashboard/ib_dashboard_state.dart';
import 'package:honorfx/models/ib_program/client_transaction_response.dart';
import 'package:honorfx/models/ib_program/ib_dashboard_response.dart';
import 'package:honorfx/models/ib_program/ib_monthly_commission_response.dart';
import 'package:honorfx/models/ib_program/ib_withdraw_list_response.dart';
import 'package:honorfx/models/ib_program/my_clients_response.dart';
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
  List<IbWithdrawItem>? _withdrawListData;

  // Store clients data at each level
  List<ClientData>? _clientsLevel1;
  List<ClientData>? _clientsLevel2;
  List<ClientData>? _clientsLevel3;
  List<ClientData>? _clientsLevel4;
  List<ClientData>? _clientsLevel5;
  List<ClientData>? _clientsLevel6;
  List<ClientData>? _clientsLevel7;

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
            _withdrawListData = response.data;
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
            _clientsLevel1 = response.data;
            emit(MyClientsLevel1Loaded(data: response.data!));
          } else if (response.status == 301 &&
              response.msg == "No data found.") {
            _clientsLevel1 = [];
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
            _clientsLevel2 = response.data;
            emit(MyClientsLevel2Loaded(data: response.data!));
          } else if (response.status == 301 &&
              response.msg == "No data found.") {
            _clientsLevel2 = [];
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
            _clientsLevel3 = response.data;
            emit(MyClientsLevel3Loaded(data: response.data!));
          } else if (response.status == 301 &&
              response.msg == "No data found.") {
            _clientsLevel3 = [];
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
            _clientsLevel4 = response.data;
            emit(MyClientsLevel4Loaded(data: response.data!));
          } else if (response.status == 301 &&
              response.msg == "No data found.") {
            _clientsLevel4 = [];
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
            _clientsLevel5 = response.data;
            emit(MyClientsLevel5Loaded(data: response.data!));
          } else if (response.status == 301 &&
              response.msg == "No data found.") {
            _clientsLevel5 = [];
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
            _clientsLevel6 = response.data;
            emit(MyClientsLevel6Loaded(data: response.data!));
          } else if (response.status == 301 &&
              response.msg == "No data found.") {
            _clientsLevel6 = [];
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
            _clientsLevel7 = response.data;
            emit(MyClientsLevel7Loaded(data: response.data!));
          } else if (response.status == 301 &&
              response.msg == "No data found.") {
            _clientsLevel7 = [];
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
    } else if (_withdrawListData != null) {
      emit(IbWithdrawListLoaded(data: _withdrawListData!));
    }
  }
}
