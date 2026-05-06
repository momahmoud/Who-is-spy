import 'package:dio/dio.dart';

abstract class ApiConsumer {
  Future<dynamic> get({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    ResponseType responseType,
  });

  Future<dynamic> post({
    required String path,
    Map<String, dynamic>? queryParameters,
    Object? body,
    Map<String, String>? headers,
    ResponseType responseType,
  });

  Future<dynamic> put({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    ResponseType responseType,
  });

  Future<dynamic> delete({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    ResponseType responseType,
  });
}
