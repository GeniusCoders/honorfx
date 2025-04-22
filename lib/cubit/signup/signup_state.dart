abstract class SignupState {}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupSuccess extends SignupState {
  SignupSuccess();
}

class SignupError extends SignupState {
  final String message;

  SignupError(this.message);
}
