import 'package:honorfx/models/dashboard/account_listing_type_model.dart';

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

// Account-related states
class AccountsLoading extends DashboardState {}

class AccountsLoaded extends DashboardState {
  final List<AccountListingTypeData> accounts;

  AccountsLoaded({required this.accounts});
}

class AccountsError extends DashboardState {
  final String message;

  AccountsError({required this.message});
}

// You can add more dashboard-related states here
// class PositionsLoading extends DashboardState {}
// class PositionsLoaded extends DashboardState {...}
// class TransactionsLoading extends DashboardState {}
// class TransactionsLoaded extends DashboardState {...}
