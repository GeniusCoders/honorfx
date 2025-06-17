import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:honorfx/cubit/bank_details/bank_details_state.dart';
import 'package:honorfx/models/dashboard/bank_details_model.dart';
import 'package:honorfx/services/repo/dashboard_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class BankDetailsCubit extends Cubit<BankDetailsState> {
  final DashboardRepo _dashboardRepo;

  BankDetailsCubit({required DashboardRepo dashboardRepo})
    : _dashboardRepo = dashboardRepo,
      super(BankDetailsInitial());

  Future<void> getBankDetailsList() async {
    emit(BankDetailsLoading());
    try {
      final result = await _dashboardRepo.getBankDetailsList();
      result.fold(
        (error) => emit(
          BankDetailsListError(
            message: error.message ?? 'Failed to load bank details',
          ),
        ),
        (response) {
          if (response.status == 200 && response.data != null) {
            emit(BankDetailsListLoaded(bankDetailsList: response.data!));
          } else {
            emit(
              BankDetailsListError(
                message: response.msg ?? 'Failed to load bank details',
              ),
            );
          }
        },
      );
    } catch (e) {
      emit(BankDetailsListError(message: e.toString()));
    }
  }

  Future<void> addBankDetails(AddBankDetailsModel model) async {
    emit(BankDetailsLoading());
    try {
      final result = await _dashboardRepo.addBankDetails(model: model);
      result.fold(
        (error) => emit(
          BankDetailsAddError(
            message: error.message ?? 'Failed to add bank details',
          ),
        ),
        (response) {
          if (response.status == 200) {
            emit(
              BankDetailsAddSuccess(
                message: response.msg ?? 'Bank details added successfully',
              ),
            );
            // Refresh the list after successful addition
            getBankDetailsList();
          } else {
            emit(
              BankDetailsAddError(
                message: response.msg ?? 'Failed to add bank details',
              ),
            );
          }
        },
      );
    } catch (e) {
      emit(BankDetailsAddError(message: e.toString()));
    }
  }
}
