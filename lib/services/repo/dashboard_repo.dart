import 'package:dartz/dartz.dart';
import 'package:honorfx/models/dashboard/account_details_response.dart';
import 'package:honorfx/models/dashboard/account_listing_type_model.dart';
import 'package:honorfx/models/dashboard/open_positions_model.dart';
import 'package:honorfx/models/login_model.dart';
import 'package:honorfx/services/core/server_error.dart';

abstract class DashboardRepo {
  Future<Either<ServerError, AccountListingTypeModel>> getAccounts();
  Future<Either<ServerError, AccountDetailsResponse>> accountDetails({
    required String accountId,
  });
  Future<TokenResponse> getTokenData();
  Future<Either<ServerError, OpenPositionsResponse>> openPositionsReport();
}
