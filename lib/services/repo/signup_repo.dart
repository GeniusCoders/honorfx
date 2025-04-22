import 'package:dartz/dartz.dart';
import 'package:honorfx/models/login_model.dart';
import 'package:honorfx/models/signup_model.dart';
import 'package:honorfx/services/core/server_error.dart';

abstract class SignupRepo {
  Future<Either<ServerError, LoginModel>> signup(SignupModel signupModel);
}
