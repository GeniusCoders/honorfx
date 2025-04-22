import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:honorfx/cubit/signup/signup_state.dart';
import 'package:honorfx/models/signup_model.dart';
import 'package:honorfx/services/repo/signup_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class SignupCubit extends Cubit<SignupState> {
  final SignupRepo signupRepo;

  SignupCubit({required this.signupRepo}) : super(SignupInitial());

  Future<void> signup({required SignupModel signupModel}) async {
    emit(SignupLoading());

    try {
      final result = await signupRepo.signup(signupModel);

      result.fold((failure) => emit(SignupError(failure.message ?? '')), (
        response,
      ) {
        if (response.responseDetails?.status == 200) {
          emit(SignupSuccess());
        } else {
          emit(SignupError(response.responseDetails?.msg ?? ''));
        }
      });
    } catch (e) {
      emit(SignupError(e.toString()));
    }
  }
}
