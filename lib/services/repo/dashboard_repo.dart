import 'package:dartz/dartz.dart';
import 'package:honorfx/models/dashboard/account_details_response.dart';
import 'package:honorfx/models/dashboard/account_listing_type_model.dart';
import 'package:honorfx/models/dashboard/group_list_model.dart';
import 'package:honorfx/models/dashboard/internal_transfer_response.dart';
import 'package:honorfx/models/dashboard/leverage_list_model.dart';
import 'package:honorfx/models/dashboard/open_account_response.dart';
import 'package:honorfx/models/dashboard/open_positions_model.dart';
import 'package:honorfx/models/dashboard/reports_model/deposit_report_model.dart';
import 'package:honorfx/models/dashboard/reports_model/withdraw_report_model.dart';
import 'package:honorfx/models/dashboard/withdraw_response.dart';
import 'package:honorfx/models/login_model.dart';
import 'package:honorfx/services/core/server_error.dart';

abstract class DashboardRepo {
  Future<Either<ServerError, AccountListingTypeModel>> getAccounts();
  Future<Either<ServerError, AccountDetailsResponse>> accountDetails({
    required String accountId,
  });
  Future<TokenResponse> getTokenData();
  Future<Either<ServerError, OpenPositionsResponse>> openPositionsReport();
  Future<Either<ServerError, DepositReportResponse>> depositReport();
  Future<Either<ServerError, WithdrawReportResponse>> withdrawReport();

  // New methods for open account feature
  Future<Either<ServerError, GroupListResponse>> getGroupList();
  Future<Either<ServerError, LeverageListResponse>> getLeverageList();
  Future<Either<ServerError, OpenAccountResponse>> openLiveAccount({
    required String group,
    required String leverage,
    required String mainPassword,
    required String investorPassword,
  });

  // Internal transfer method
  Future<Either<ServerError, InternalTransferResponse>> internalTransfer({
    required String fromAccount,
    required String toAccount,
    required String amount,
  });

  // Withdraw method
  Future<Either<ServerError, WithdrawResponse>> withdraw({
    required String mt5id,
    required String withdrawTo,
    required String amount,
    required String note,
    required String paymentMethod,
  });
}
