import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class AppInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('REQUEST[${options.method}] => PATH: ${options.path}');


    final Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
    };

    options.headers.addAll(headers);

    super.onRequest(options, handler);
  }


  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    super.onError(err, handler);
  }
}
