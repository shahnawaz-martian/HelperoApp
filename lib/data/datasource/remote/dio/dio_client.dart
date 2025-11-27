import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../utils/app_constants.dart';
import 'logging_interceptor.dart';

class DioClient {
  final String baseUrl;
  final LoggingInterceptor loggingInterceptor;
  final SharedPreferences sharedPreferences;

  Dio? dio;
  String? token;

  DioClient(
      this.baseUrl,
      Dio? dioC, {
        required this.loggingInterceptor,
        required this.sharedPreferences,
      }) {
    token = sharedPreferences.getString(AppConstants.userLoginToken);
    if (kDebugMode) print("Initial token: $token");

    dio = dioC ?? Dio();
    dio
      ?..options.baseUrl = baseUrl
      ..options.connectTimeout = const Duration(seconds: 60)
      ..options.receiveTimeout = const Duration(seconds: 60)
      ..options.headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        if (token != null && token!.isNotEmpty) 'Authorization': 'Bearer $token',
      };

    dio!.interceptors.add(loggingInterceptor);
  }

  void updateHeader(String? newToken) {
    token = newToken ?? sharedPreferences.getString(AppConstants.userLoginToken);

    dio!.options.headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      if (token != null && token!.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    if (kDebugMode) {
      log(' Updated headers: ${dio!.options.headers}');
    }
  }

  Future<Response> get(
      String uri, {
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      _logRequest('GET', uri, queryParameters: queryParameters);
      final response = await dio!.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      _logResponse(uri, response);
      return response;
    } on SocketException catch (e) {
      _logError(uri, 'SocketException - $e');
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      _logError(uri, 'FormatException - Unable to process the data');
      throw const FormatException("Unable to process the data");
    } catch (e) {
      _logError(uri, e.toString());
      rethrow;
    }
  }

  Future<Response> post(
      String uri, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      _logRequest('POST', uri, body: data);
      final response = await dio!.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      _logResponse(uri, response);
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      _logError(uri, e.toString());
      rethrow;
    }
  }

  Future<Response> put(
      String uri, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      _logRequest('PUT', uri, body: data);
      final response = await dio!.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      _logResponse(uri, response);
      return response;
    } on FormatException catch (_) {
      _logError(uri, 'FormatException - Unable to process the data');
      throw const FormatException("Unable to process the data");
    } catch (e) {
      _logError(uri, e.toString());
      rethrow;
    }
  }

  Future<Response> delete(
      String uri, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    try {
      _logRequest('DELETE', uri, body: data);
      final response = await dio!.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      _logResponse(uri, response);
      return response;
    } on FormatException catch (_) {
      _logError(uri, 'FormatException - Unable to process the data');
      throw const FormatException("Unable to process the data");
    } catch (e) {
      _logError(uri, e.toString());
      rethrow;
    }
  }

  // Logging helpers
  void _logRequest(String method, String uri,
      {dynamic body, Map<String, dynamic>? queryParameters}) {
    if (kDebugMode) {
      log('┌─────────────────────── $method REQUEST ───────────────────────');
      log('│ URL: ${dio?.options.baseUrl}$uri');
      log('│ HEADERS: ${dio?.options.headers}');
      if (queryParameters != null) log('│ QUERY PARAMS: $queryParameters');
      if (body != null) log('│ BODY: $body');
      log('└────────────────────────────────────────────────────────────');
    }
  }

  void _logResponse(String uri, Response response) {
    if (kDebugMode) {
      log('┌─────────────────────── API RESPONSE ──────────────────────');
      log('│ URL: ${dio?.options.baseUrl}$uri');
      log('│ STATUS: ${response.statusCode}');
      log('│ RESPONSE: ${response.data}');
      log('└────────────────────────────────────────────────────────────');
    }
  }

  void _logError(String uri, String message) {
    if (kDebugMode) {
      log('┌─────────────────────── API ERROR ─────────────────────────');
      log('│ URL: ${dio?.options.baseUrl}$uri');
      log('│ ERROR: $message');
      log('└────────────────────────────────────────────────────────────');
    }
  }
}
