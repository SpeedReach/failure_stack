import 'package:dio/dio.dart';

import '../domain/repository_failure.dart';

extension DioExceptionAdapter on DioException {
  RepositoryFailure intoRepositoryFailure() {
    switch (type) {
      case DioExceptionType.connectionTimeout:
        return const ConnectionFailure();
      case DioExceptionType.sendTimeout:
        return const ConnectionFailure();
      case DioExceptionType.receiveTimeout:
        return const ConnectionFailure();
      case DioExceptionType.badCertificate:
        return UnExpectedFailure(error);
      case DioExceptionType.badResponse:
        if (response == null || response!.statusCode == null) {
          return const UnExpectedFailure(null);
        } else if (response!.statusCode == 401) {
          return const UnAuthorizeFailure();
        } else if (response!.statusCode! >= 500) {
          return const ServerFailure();
        } else if (response!.statusCode! >= 400) {
          return IllegalActionFailure(response!.statusMessage ?? "");
        }
        return const UnExpectedFailure(null);
      case DioExceptionType.cancel:
        return const RequestCanceledFailure();
      case DioExceptionType.connectionError:
        return const ConnectionFailure();
      case DioExceptionType.unknown:
        return const UnExpectedFailure(null);
    }
  }
}
