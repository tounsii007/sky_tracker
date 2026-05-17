import 'package:dio/dio.dart';

import 'package:sky_tracker/core/constants/config.dart';

class AppHttpClient {
  const AppHttpClient._();

  static Dio create({
    Duration connectTimeout = AppConfig.apiTimeout,
    Duration receiveTimeout = AppConfig.longTimeout,
    String? baseUrl,
  }) {
    return Dio(
      BaseOptions(
        baseUrl: baseUrl ?? '',
        connectTimeout: connectTimeout,
        receiveTimeout: receiveTimeout,
        validateStatus: (status) => status != null && status < 500,
      ),
    );
  }
}
