import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:honorfx/models/login_model.dart';
import 'package:honorfx/models/signup_model.dart';
import 'package:honorfx/services/core/server_error.dart';
import 'package:honorfx/services/repo/signup_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: SignupRepo)
class SignupApi implements SignupRepo {
  final Dio dio;

  SignupApi({required this.dio});

  @override
  Future<Either<ServerError, LoginModel>> signup(
    SignupModel signupModel,
  ) async {
    try {
      print(signupModel.toJson());
      final response = await dio.post('/register', data: signupModel.toJson());

      return Right(LoginModel.fromJson(response.data));
    } on DioError catch (e) {
      return left(ServerError.withError(error: e));
    }
  }
}
