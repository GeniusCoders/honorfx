import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:honorfx/cubit/dashboard/dashboard_state.dart';
import 'package:honorfx/services/repo/dashboard_repo.dart';
import 'package:honorfx/models/dashboard/account_listing_type_model.dart';
import 'package:honorfx/models/dashboard/group_list_model.dart';
import 'package:honorfx/models/dashboard/leverage_list_model.dart';

@injectable
class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepo _dashboardRepo;

  DashboardCubit({required DashboardRepo dashboardRepo})
    : _dashboardRepo = dashboardRepo,
      super(DashboardInitial());

  Future<void> getTokenData() async {
    emit(DashboardLoading());
    try {
      final tokenData = await _dashboardRepo.getTokenData();
      emit(TokenResponseDataState(tokenResponse: tokenData));
    } catch (e) {
      emit(DashboardError(message: e.toString()));
    }
  }

  Future<void> getAccounts() async {
    emit(DashboardLoading());
    try {
      final result = await _dashboardRepo.getAccounts();
      result.fold(
        (error) => emit(
          AccountsError(message: error.message ?? 'Failed to load accounts'),
        ),
        (accountList) {
          if (accountList.status == 200) {
            if (accountList.data != null && accountList.data!.isNotEmpty) {
              emit(AccountsLoaded(accounts: accountList.data!));
              // Fetch account details for the first account by default
              getAccountDetails(
                accountId: accountList.data!.first.mtUserid.toString(),
              );
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

  Future<void> getAccountDetails({
    required String accountId,
    int? selectedIndex,
  }) async {
    List<AccountListingTypeData> accounts = [];
    int selectedAccountIdx = selectedIndex ?? 0;

    // Handle both states
    if (state is AccountsLoaded) {
      final currentState = state as AccountsLoaded;
      accounts = currentState.accounts;
      selectedAccountIdx =
          selectedIndex ?? currentState.selectedAccountIndex ?? 0;
    } else if (state is AccountDetailsLoaded) {
      final currentState = state as AccountDetailsLoaded;
      accounts = currentState.accounts;
      selectedAccountIdx = selectedIndex ?? currentState.selectedAccountIndex;
    } else {
      return;
    }

    emit(DashboardLoading());

    try {
      final result = await _dashboardRepo.accountDetails(accountId: accountId);
      result.fold(
        (error) {
          emit(
            DashboardError(
              message: error.message ?? 'Failed to load account details',
            ),
          );
        },
        (response) {
          if (response.status == 200 && response.data != null) {
            emit(
              AccountDetailsLoaded(
                accounts: accounts,
                selectedAccountIndex: selectedAccountIdx,
                accountDetails: response.data!,
              ),
            );
          } else {
            emit(
              DashboardError(
                message: response.msg ?? 'Failed to load account details',
              ),
            );
          }
        },
      );
    } catch (e) {
      emit(DashboardError(message: e.toString()));
    }
  }

  void selectAccount(int index) {
    print("selectAccount");
    // Handle both AccountsLoaded and AccountDetailsLoaded states
    List<AccountListingTypeData> accounts = [];

    if (state is AccountsLoaded) {
      final currentState = state as AccountsLoaded;
      accounts = currentState.accounts;
    } else if (state is AccountDetailsLoaded) {
      final currentState = state as AccountDetailsLoaded;
      accounts = currentState.accounts;
    } else {
      return;
    }

    if (index >= 0 && index < accounts.length) {
      final selectedAccount = accounts[index];

      // First update the selection state based on current state type
      if (state is AccountsLoaded) {
        emit(AccountsLoaded(accounts: accounts, selectedAccountIndex: index));
      } else if (state is AccountDetailsLoaded) {
        // Keep the current account details but update the selected index
        emit(AccountsLoaded(accounts: accounts, selectedAccountIndex: index));
      }

      // Call API to get account details
      getAccountDetails(
        accountId: selectedAccount.mtUserid.toString(),
        selectedIndex: index,
      );
    } else {}
  }

  Future<void> getGroupList() async {
    emit(DashboardLoading());
    try {
      final result = await _dashboardRepo.getGroupList();
      result.fold(
        (error) => emit(
          GroupListError(message: error.message ?? 'Failed to load groups'),
        ),
        (groupList) {
          if (groupList.status == 200) {
            if (groupList.data != null && groupList.data!.isNotEmpty) {
              emit(GroupListLoaded(groups: groupList.data!));
            } else {
              emit(GroupListLoaded(groups: []));
            }
          } else {
            emit(
              GroupListError(message: groupList.msg ?? 'Failed to load groups'),
            );
          }
        },
      );
    } catch (e) {
      emit(GroupListError(message: e.toString()));
    }
  }

  Future<void> getLeverageList() async {
    emit(DashboardLoading());
    try {
      final result = await _dashboardRepo.getLeverageList();
      result.fold(
        (error) => emit(
          LeverageListError(
            message: error.message ?? 'Failed to load leverages',
          ),
        ),
        (leverageList) {
          if (leverageList.status == 200) {
            if (leverageList.data != null && leverageList.data!.isNotEmpty) {
              emit(LeverageListLoaded(leverages: leverageList.data!));
            } else {
              emit(LeverageListLoaded(leverages: []));
            }
          } else {
            emit(
              LeverageListError(
                message: leverageList.msg ?? 'Failed to load leverages',
              ),
            );
          }
        },
      );
    } catch (e) {
      emit(LeverageListError(message: e.toString()));
    }
  }

  Future<void> openLiveAccount({
    required String group,
    required String leverage,
    required String mainPassword,
    required String investorPassword,
  }) async {
    emit(DashboardLoading());
    try {
      final result = await _dashboardRepo.openLiveAccount(
        group: group,
        leverage: leverage,
        mainPassword: mainPassword,
        investorPassword: investorPassword,
      );

      result.fold(
        (error) => emit(
          OpenAccountError(message: error.message ?? 'Failed to open account'),
        ),
        (response) {
          if (response.status == 200) {
            emit(
              OpenAccountSuccess(
                message:
                    response.data?.message ?? 'Account created successfully',
              ),
            );
            // Refresh accounts list
            getAccounts();
          } else {
            emit(
              OpenAccountError(
                message: response.msg ?? 'Failed to open account',
              ),
            );
          }
        },
      );
    } catch (e) {
      emit(OpenAccountError(message: e.toString()));
    }
  }

  Future<void> internalTransfer({
    required String fromAccount,
    required String toAccount,
    required String amount,
  }) async {
    emit(DashboardLoading());
    try {
      final result = await _dashboardRepo.internalTransfer(
        fromAccount: fromAccount,
        toAccount: toAccount,
        amount: amount,
      );

      result.fold(
        (error) => emit(
          InternalTransferError(message: error.message ?? 'Transfer failed'),
        ),
        (response) {
          if (response.status == 200) {
            emit(
              InternalTransferSuccess(
                message: response.msg ?? 'Transfer successful',
              ),
            );
            // Refresh accounts list to show updated balances
            getAccounts();
          } else {
            emit(
              InternalTransferError(message: response.msg ?? 'Transfer failed'),
            );
          }
        },
      );
    } catch (e) {
      emit(InternalTransferError(message: e.toString()));
    }
  }

  Future<void> withdraw({
    required String mt5id,
    required String withdrawTo,
    required String amount,
    required String note,
    required String paymentMethod,
  }) async {
    emit(DashboardLoading());
    try {
      final result = await _dashboardRepo.withdraw(
        mt5id: mt5id,
        withdrawTo: withdrawTo,
        amount: amount,
        note: note,
        paymentMethod: paymentMethod,
      );

      result.fold(
        (error) =>
            emit(WithdrawError(message: error.message ?? 'Withdrawal failed')),
        (response) {
          if (response.status == 200) {
            emit(
              WithdrawSuccess(
                message:
                    response.msg ?? 'Withdrawal request processed successfully',
              ),
            );
            // Refresh accounts list to show updated balances
            getAccounts();
          } else {
            emit(WithdrawError(message: response.msg ?? 'Withdrawal failed'));
          }
        },
      );
    } catch (e) {
      emit(WithdrawError(message: e.toString()));
    }
  }

  // Wallet to MT5 transfer
  Future<void> walletToMt5({
    required String mt5id,
    required String amount,
    required String note,
  }) async {
    emit(DashboardLoading());
    try {
      final result = await _dashboardRepo.walletToMt5(
        mt5id: mt5id,
        amount: amount,
        note: note,
      );

      result.fold(
        (error) =>
            emit(WalletToMt5Error(message: error.message ?? 'Transfer failed')),
        (response) {
          if (response.status == 200) {
            emit(
              WalletToMt5Success(
                message: response.msg ?? 'Transfer successful',
              ),
            );
            // Refresh accounts list to show updated balances
            getAccounts();
          } else {
            emit(WalletToMt5Error(message: response.msg ?? 'Transfer failed'));
          }
        },
      );
    } catch (e) {
      emit(WalletToMt5Error(message: e.toString()));
    }
  }

  // MT5 to Wallet transfer
  Future<void> mt5ToWallet({
    required String mt5id,
    required String amount,
    required String note,
  }) async {
    emit(DashboardLoading());
    try {
      final result = await _dashboardRepo.mt5ToWallet(
        mt5id: mt5id,
        amount: amount,
        note: note,
      );

      result.fold(
        (error) =>
            emit(Mt5ToWalletError(message: error.message ?? 'Transfer failed')),
        (response) {
          if (response.status == 200) {
            emit(
              Mt5ToWalletSuccess(
                message: response.msg ?? 'Transfer successful',
              ),
            );
            // Refresh accounts list to show updated balances
            getAccounts();
          } else {
            emit(Mt5ToWalletError(message: response.msg ?? 'Transfer failed'));
          }
        },
      );
    } catch (e) {
      emit(Mt5ToWalletError(message: e.toString()));
    }
  }

  // Get wallet history
  Future<void> getWalletHistory() async {
    emit(DashboardLoading());
    try {
      final result = await _dashboardRepo.walletHistory();

      result.fold(
        (error) => emit(
          WalletHistoryError(
            message: error.message ?? 'Failed to load wallet history',
          ),
        ),
        (response) {
          if (response.status == 200) {
            if (response.data != null && response.data!.isNotEmpty) {
              emit(WalletHistoryLoaded(transactions: response.data!));
            } else {
              emit(WalletHistoryLoaded(transactions: []));
            }
          } else {
            emit(
              WalletHistoryError(
                message: response.msg ?? 'Failed to load wallet history',
              ),
            );
          }
        },
      );
    } catch (e) {
      emit(WalletHistoryError(message: e.toString()));
    }
  }

  // Get dashboard data
  Future<void> getDashboardData() async {
    emit(DashboardLoading());
    try {
      final result = await _dashboardRepo.getDashboardData();

      result.fold(
        (error) => emit(
          DashboardDataError(
            message: error.message ?? 'Failed to load dashboard data',
          ),
        ),
        (response) {
          if (response.status == 200) {
            if (response.data != null) {
              emit(DashboardDataLoaded(dashboardData: response.data!));
            } else {
              emit(DashboardDataError(message: 'No dashboard data available'));
            }
          } else {
            emit(
              DashboardDataError(
                message: response.msg ?? 'Failed to load dashboard data',
              ),
            );
          }
        },
      );
    } catch (e) {
      emit(DashboardDataError(message: e.toString()));
    }
  }
}
