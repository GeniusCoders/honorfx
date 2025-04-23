import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:honorfx/cubit/dashboard/dashboard_state.dart';
import 'package:honorfx/services/repo/dashboard_repo.dart';
import 'package:honorfx/models/dashboard/account_listing_type_model.dart';

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
}
