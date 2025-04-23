import 'package:honorfx/models/dashboard/account_details_response.dart';
import 'package:honorfx/models/dashboard/account_listing_type_model.dart';
import 'package:honorfx/models/login_model.dart';

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

// Token Response state
class TokenResponseDataState extends DashboardState {
  final TokenResponse tokenResponse;

  TokenResponseDataState({required this.tokenResponse});
}

// Account-related states
class AccountsLoading extends DashboardState {}

class AccountsLoaded extends DashboardState {
  final List<AccountListingTypeData> accounts;
  final int? selectedAccountIndex;

  AccountsLoaded({required this.accounts, this.selectedAccountIndex = 0});
}

class AccountsError extends DashboardState {
  final String message;

  AccountsError({required this.message});
}

// Account details states
class AccountDetailsLoading extends DashboardState {}

class AccountDetailsLoaded extends DashboardState {
  final List<AccountListingTypeData> accounts;
  final int selectedAccountIndex;
  final AccountDetailsData accountDetails;

  AccountDetailsLoaded({
    required this.accounts,
    required this.selectedAccountIndex,
    required this.accountDetails,
  });
}

class AccountDetailsError extends DashboardState {
  final String message;

  AccountDetailsError({required this.message});
}

// You can add more dashboard-related states here
// class PositionsLoading extends DashboardState {}
// class PositionsLoaded extends DashboardState {...}
// class TransactionsLoading extends DashboardState {}
// class TransactionsLoaded extends DashboardState {...}
