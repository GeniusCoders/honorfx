import 'package:honorfx/models/dashboard/account_details_response.dart';
import 'package:honorfx/models/dashboard/account_listing_type_model.dart';
import 'package:honorfx/models/dashboard/open_positions_model.dart';
import 'package:honorfx/models/login_model.dart';

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardFailed extends DashboardState {
  final String error;

  DashboardFailed({required this.error});
}

// Token Response state
class TokenResponseDataState extends DashboardState {
  final TokenResponse tokenResponse;

  TokenResponseDataState({required this.tokenResponse});
}

// Open Positions state
class OpenPositionsReportState extends DashboardState {
  final List<OpenPositionData> data;

  OpenPositionsReportState({required this.data});
}

class AccountsLoaded extends DashboardState {
  final List<AccountListingTypeData> accounts;
  final int? selectedAccountIndex;

  AccountsLoaded({required this.accounts, this.selectedAccountIndex = 0});
}

class AccountsError extends DashboardState {
  final String message;

  AccountsError({required this.message});
}

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

class DashboardError extends DashboardState {
  final String message;

  DashboardError({required this.message});
}

// You can add more dashboard-related states here
// class PositionsLoading extends DashboardState {}
// class PositionsLoaded extends DashboardState {...}
// class TransactionsLoading extends DashboardState {}
// class TransactionsLoaded extends DashboardState {...}
