import 'package:honorfx/models/dashboard/account_details_response.dart';
import 'package:honorfx/models/dashboard/account_listing_type_model.dart';
import 'package:honorfx/models/dashboard/dashboard_data_response.dart';
import 'package:honorfx/models/dashboard/deal_report_response.dart';
import 'package:honorfx/models/dashboard/group_list_model.dart';
import 'package:honorfx/models/dashboard/leverage_list_model.dart';
import 'package:honorfx/models/dashboard/support_ticket_model.dart';
import 'package:honorfx/models/dashboard/wallet_history_response.dart';
import 'package:honorfx/models/login_model.dart';

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class WalletTransferLoading extends DashboardState {}

class DashboardFailed extends DashboardState {
  final String error;

  DashboardFailed({required this.error});
}

// Token Response state
class TokenResponseDataState extends DashboardState {
  final TokenResponse tokenResponse;

  TokenResponseDataState({required this.tokenResponse});
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
  final int selectedAccountIndex;
  final AccountDetailsData accountDetails;

  AccountDetailsLoaded({
    required this.selectedAccountIndex,
    required this.accountDetails,
  });
}

class DashboardError extends DashboardState {
  final String message;

  DashboardError({required this.message});
}

// New states for open account feature
class GroupListLoaded extends DashboardState {
  final List<GroupData> groups;

  GroupListLoaded({required this.groups});
}

class GroupListError extends DashboardState {
  final String message;

  GroupListError({required this.message});
}

class LeverageListLoaded extends DashboardState {
  final List<LeverageData> leverages;

  LeverageListLoaded({required this.leverages});
}

class LeverageListError extends DashboardState {
  final String message;

  LeverageListError({required this.message});
}

class OpenAccountSuccess extends DashboardState {
  final String message;

  OpenAccountSuccess({required this.message});
}

class OpenAccountError extends DashboardState {
  final String message;

  OpenAccountError({required this.message});
}

// Internal transfer states
class InternalTransferSuccess extends DashboardState {
  final String message;

  InternalTransferSuccess({required this.message});
}

class InternalTransferError extends DashboardState {
  final String message;

  InternalTransferError({required this.message});
}

// Withdraw states
class WithdrawSuccess extends DashboardState {
  final String message;

  WithdrawSuccess({required this.message});
}

class WithdrawError extends DashboardState {
  final String message;

  WithdrawError({required this.message});
}

// Wallet to MT5 states
class WalletToMt5Success extends DashboardState {
  final String message;

  WalletToMt5Success({required this.message});
}

class WalletToMt5Error extends DashboardState {
  final String message;

  WalletToMt5Error({required this.message});
}

// MT5 to Wallet states
class Mt5ToWalletSuccess extends DashboardState {
  final String message;

  Mt5ToWalletSuccess({required this.message});
}

class Mt5ToWalletError extends DashboardState {
  final String message;

  Mt5ToWalletError({required this.message});
}

// Wallet History states
class WalletHistoryLoaded extends DashboardState {
  final List<WalletHistoryData> transactions;

  WalletHistoryLoaded({required this.transactions});
}

class WalletHistoryError extends DashboardState {
  final String message;

  WalletHistoryError({required this.message});
}

// Dashboard Data states
class DashboardDataLoaded extends DashboardState {
  final DashboardData dashboardData;

  DashboardDataLoaded({required this.dashboardData});
}

class DashboardDataError extends DashboardState {
  final String message;

  DashboardDataError({required this.message});
}

// Deal Report states
class DealReportLoaded extends DashboardState {
  final List<DealReportData> deals;

  DealReportLoaded({required this.deals});
}

class DealReportError extends DashboardState {
  final String message;

  DealReportError({required this.message});
}

class AddDepositSuccess extends DashboardState {
  final String message;

  AddDepositSuccess({required this.message});
}

class UpiQrCodeLoaded extends DashboardState {
  final String qrcode;

  UpiQrCodeLoaded({required this.qrcode});
}

class CryptoDepositSuccess extends DashboardState {
  final String url;
  final String message;

  CryptoDepositSuccess({required this.url, required this.message});
}

class CryptoDepositError extends DashboardState {
  final String message;

  CryptoDepositError({required this.message});
}

// Support Ticket states
class CreateTicketLoading extends DashboardState {}

class CreateTicketSuccess extends DashboardState {
  final String message;
  final String? ticketId;

  CreateTicketSuccess({required this.message, this.ticketId});
}

class CreateTicketError extends DashboardState {
  final String message;

  CreateTicketError({required this.message});
}

// My Tickets states
class MyTicketsLoading extends DashboardState {}

class MyTicketsLoaded extends DashboardState {
  final List<TicketData> tickets;

  MyTicketsLoaded({required this.tickets});
}

class MyTicketsError extends DashboardState {
  final String message;

  MyTicketsError({required this.message});
}

// Comment states
class AddCommentLoading extends DashboardState {}

class AddCommentSuccess extends DashboardState {
  final String message;

  AddCommentSuccess({required this.message});
}

class AddCommentError extends DashboardState {
  final String message;

  AddCommentError({required this.message});
}
