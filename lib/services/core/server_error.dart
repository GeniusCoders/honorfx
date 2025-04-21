import 'package:dio/dio.dart';

class ServerError {
  final String? message;
  final int? code;

  ServerError({this.message, this.code});

  factory ServerError.withError({required dynamic error}) {
    if (error is DioError) {
      return ServerError(
        message: error.response?.data['message'] ?? error.message,
        code: error.response?.statusCode,
      );
    }
    return ServerError(message: error.toString());
  }
}
