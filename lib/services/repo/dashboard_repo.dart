import 'package:dartz/dartz.dart';
import 'package:honorfx/models/dashboard/account_listing_type_model.dart';
import 'package:honorfx/services/core/server_error.dart';

abstract class DashboardRepo {
  Future<Either<ServerError, AccountListingTypeModel>> getAccounts();
}
