import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../localization/app_localizations.dart';

class DioHttpClient {
  late final Dio dio;

  DioHttpClient(Locale locale, {String baseUrl = 'http://localhost:5153'}) {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Accept-Language': locale.languageCode == 'fa' ? 'fa-IR' : 'en-US',
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['Accept-Language'] =
              locale.languageCode == 'fa' ? 'fa-IR' : 'en-US';
          return handler.next(options);
        },
      ),
    );
  }
}

final httpClientProvider = Provider<DioHttpClient>((ref) {
  final locale = ref.watch(localeProvider);
  return DioHttpClient(locale);
});
