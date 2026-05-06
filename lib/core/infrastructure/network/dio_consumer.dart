import 'dart:convert';

import 'package:salfah/core/di/index.dart';
import 'package:salfah/core/infrastructure/network/api_consumer.dart';
import 'package:salfah/core/infrastructure/network/app_interceptor.dart';
import 'package:salfah/core/infrastructure/network/exc_handler.dart';
import 'package:salfah/core/utilities/app_logger.dart';
import 'package:dio/dio.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
@LazySingleton(as: ApiConsumer)
class DioConsumer implements ApiConsumer {
  final Dio client;

  DioConsumer({required this.client}) {
    client.options.baseUrl = '';
    client.interceptors.add(di<AppInterceptors>());
    if (kDebugMode) {
      client.interceptors.add(
        PrettyDioLogger(requestHeader: true, requestBody: true),
      );
    }
  }

  @override
  Future<dynamic> get({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    ResponseType responseType = ResponseType.json,
  }) async {
    try {
      client.options.headers = headers;
      client.options.responseType = responseType;
      final Response<dynamic> response = await client.get<dynamic>(
        path,
        queryParameters: queryParameters,
      );
      return handleResponse(response);
    } on DioException catch (error) {
      AppLogger().error('Error in GET request: $error');
      throw DioHandlerExc.handle(error);
    }
  }

  @override
  Future<dynamic> post({
    required String path,
    Map<String, dynamic>? queryParameters,
    Object? body,
    Map<String, String>? headers,
    ResponseType responseType = ResponseType.json,
  }) async {
    try {
      client.options.headers = headers;
      client.options.responseType = responseType;
      final Response<dynamic> response = await client.post<dynamic>(
        path,
        queryParameters: queryParameters,
        data: body,
      );
      return handleResponse(response);
    } on DioException catch (error) {
      AppLogger().error('Error in POST request: $error');
      throw DioHandlerExc.handle(error);
    }
  }

  @override
  Future<dynamic> put({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    ResponseType responseType = ResponseType.json,
  }) async {
    try {
      client.options.headers = headers;
      client.options.responseType = responseType;
      final Response<dynamic> response = await client.put<dynamic>(
        path,
        queryParameters: queryParameters,
        data: body,
      );
      return handleResponse(response);
    } on DioException catch (error) {
      AppLogger().error('Error in PUT request: $error');
      throw DioHandlerExc.handle(error);
    }
  }

  @override
  Future<dynamic> delete({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    ResponseType responseType = ResponseType.json,
  }) async {
    try {
      client.options.headers = headers;
      client.options.responseType = responseType;
      final Response<dynamic> response = await client.delete<dynamic>(
        path,
        queryParameters: queryParameters,
        data: body,
      );
      return handleResponse(response);
    } on DioException catch (error) {
      AppLogger().error('Error in DELETE request: $error');
      throw DioHandlerExc.handle(error);
    }
  }
}

dynamic handleResponse(Response<dynamic> response) {
  if (response.requestOptions.responseType == ResponseType.bytes) {
    return response.data as Uint8List;
  } else if (response.requestOptions.responseType == ResponseType.plain) {
    return response.data as String;
  } else if (response.data is String) {
    try {
      return jsonDecode(response.data.toString());
    } catch (e) {
      return response.data.toString();
    }
  } else {
    return response.data;
  }
}
