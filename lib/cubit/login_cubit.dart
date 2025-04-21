import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:honorfx/models/login_model.dart';
import 'package:honorfx/services/repo/login_repo.dart';
import 'package:injectable/injectable.dart';

part 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  final LoginRepo loginRepo;

  LoginCubit({required this.loginRepo}) : super(LoginInitial());

  Future<void> login({required String email, required String password}) async {
    emit(LoginLoading());
    final result = await loginRepo.login(email: email, password: password);
    result.fold(
      (error) => emit(LoginFailed(error: error.message ?? 'Login failed')),
      (loginModel) async {
        if (loginModel.responseDetails!.status == 200) {
          if (loginModel.data!.status == "1") {
            await loginRepo.storeLoginData(
              json: loginModel.data!.toJson(),
              password: password,
            );

            emit(LoginSuccess(loginModel: loginModel));
          } else {
            emit(
              LoginFailed(
                error: loginModel.responseDetails!.msg ?? 'Login failed',
              ),
            );
          }
        } else {
          emit(
            LoginFailed(
              error: loginModel.responseDetails!.msg ?? 'Login failed',
            ),
          );
        }
      },
    );
  }
}
