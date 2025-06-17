import 'package:dartz/dartz.dart';
import 'package:honorfx/models/common/response_details.dart';
import 'package:honorfx/models/dashboard/account_details_response.dart';
import 'package:honorfx/models/dashboard/account_listing_type_model.dart';
import 'package:honorfx/models/dashboard/bank_details_model.dart';
import 'package:honorfx/models/dashboard/crypto_deposit_response.dart';
import 'package:honorfx/models/dashboard/dashboard_data_response.dart';
import 'package:honorfx/models/dashboard/deal_report_response.dart';
import 'package:honorfx/models/dashboard/document_upload_model.dart';
import 'package:honorfx/models/dashboard/group_list_model.dart';
import 'package:honorfx/models/dashboard/internal_transfer_response.dart';
import 'package:honorfx/models/dashboard/leverage_list_model.dart';
import 'package:honorfx/models/dashboard/open_account_response.dart';
import 'package:honorfx/models/dashboard/open_positions_model.dart';
import 'package:honorfx/models/dashboard/reports_model/add_deposit_model.dart';
import 'package:honorfx/models/dashboard/reports_model/deposit_report_model.dart';
import 'package:honorfx/models/dashboard/reports_model/withdraw_report_model.dart';
import 'package:honorfx/models/dashboard/support_ticket_model.dart';
import 'package:honorfx/models/dashboard/upi_qr_code_response.dart';
import 'package:honorfx/models/dashboard/wallet_history_response.dart';
import 'package:honorfx/models/dashboard/wallet_transfer_response.dart';
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

  // Wallet to MT5 transfer
  Future<Either<ServerError, WalletTransferResponse>> walletToMt5({
    required String mt5id,
    required String amount,
    required String note,
  });

  // MT5 to Wallet transfer
  Future<Either<ServerError, WalletTransferResponse>> mt5ToWallet({
    required String mt5id,
    required String amount,
    required String note,
  });

  // Wallet History
  Future<Either<ServerError, WalletHistoryResponse>> walletHistory();

  // Get Dashboard Data
  Future<Either<ServerError, DashboardDataResponse>> getDashboardData();

  // Get Deal Report
  Future<Either<ServerError, DealReportResponse>> getDealReport({
    required String mt5id,
    required String from,
    required String to,
  });

  Future<Either<ServerError, ResponseDetails>> addDeposit({
    required AddDepositModel model,
  });

  Future<Either<ServerError, UpiQrCodeResponse>> upiQrCode();

  Future<Either<ServerError, CryptoDepositResponse>> cregisDeposit({
    required String amount,
    required String mt5id,
  });

  // Bank Details methods
  Future<Either<ServerError, BankDetailsResponse>> getBankDetailsList();
  Future<Either<ServerError, ResponseDetails>> addBankDetails({
    required AddBankDetailsModel model,
  });

  // Document Upload methods
  Future<Either<ServerError, DocumentUploadResponse>> getDocumentUploadList();
  Future<Either<ServerError, ResponseDetails>> uploadDocuments({
    required UploadDocumentModel model,
  });

  // Support Ticket methods
  Future<Either<ServerError, CreateTicketResponse>> createTicket({
    required CreateTicketRequest request,
  });
  Future<Either<ServerError, MyTicketsResponse>> getMyTickets();
  Future<Either<ServerError, AddCommentResponse>> addComment({
    required AddCommentRequest request,
  });

  Future<UpiQrCodeData> getUpiQrCode();

  Future<CryptoDepositData> getCryptoDeposit({
    required String amount,
    required String mt5id,
  });
}
