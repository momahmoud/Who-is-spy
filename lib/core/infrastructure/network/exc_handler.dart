import 'package:salfah/core/error_handling/index.dart';
import 'package:salfah/core/infrastructure/network/status_code.dart';
import 'package:salfah/core/utilities/app_logger.dart';
import 'package:dio/dio.dart';

class DioHandlerExc implements Exception {
  final Failure failure;

  DioHandlerExc.handle(dynamic error) : failure = _handleError(error);

  static Failure _handleError(dynamic error) {
    if (error is DioException) {
      return _handleDioError(error);
    } else if (error is DioHandlerExc) {
      return error.failure;
    } else {
      return ServerFailure('Something went wrong');
    }
  }

  static Failure _handleDioError(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ServerFailure('Connection timeout');
      case DioExceptionType.badResponse:
        final int? statusCode = exception.response?.statusCode;
        final String message = _getErrorMessageForStatusCode(statusCode);
        AppLogger().error('Error message:Error message: $message');
        return ServerFailure(message);
      case DioExceptionType.cancel:
        return ServerFailure('Request was cancelled');
      case DioExceptionType.unknown:
      case DioExceptionType.badCertificate:
      case DioExceptionType.connectionError:
      return ServerFailure('Unknown Error');
    }
  }

  static String _getErrorMessageForStatusCode(int? statusCode) {
    AppLogger().info('The Status Code Is $statusCode');
    switch (statusCode) {
      case StatusCode.badRequest:
        return '';
      case StatusCode.unauthorized:
        return '';
      case StatusCode.forbidden:
        return '';
      case StatusCode.notFound:
        return '';
      case StatusCode.internalServerError:
        return '';
      default:
        return '';
    }
  }
}
