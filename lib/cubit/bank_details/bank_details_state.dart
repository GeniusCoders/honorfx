import 'package:honorfx/models/dashboard/bank_details_model.dart';

abstract class BankDetailsState {}

class BankDetailsInitial extends BankDetailsState {}

class BankDetailsLoading extends BankDetailsState {}

class BankDetailsListLoaded extends BankDetailsState {
  final List<BankDetailsData> bankDetailsList;

  BankDetailsListLoaded({required this.bankDetailsList});
}

class BankDetailsListError extends BankDetailsState {
  final String message;

  BankDetailsListError({required this.message});
}

class BankDetailsAddSuccess extends BankDetailsState {
  final String message;

  BankDetailsAddSuccess({required this.message});
}

class BankDetailsAddError extends BankDetailsState {
  final String message;

  BankDetailsAddError({required this.message});
}
