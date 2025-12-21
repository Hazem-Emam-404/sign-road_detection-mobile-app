import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';

class HttpClient {
  HttpClient._internal() {
    _dio = Dio(
      BaseOptions(
        // Increased timeouts so camera/frame uploads and server processing
        // have more time before Dio aborts the request.
        connectTimeout: const Duration(seconds: 100),
        receiveTimeout: const Duration(seconds: 1000),
      ),
    );

    _dio.interceptors.add(
      RetryInterceptor(
        dio: _dio,
        retries: 2,
        retryDelays: const [
          Duration(milliseconds: 500),
          Duration(milliseconds: 1000),
        ],
      ),
    );
  }

  static final HttpClient _instance = HttpClient._internal();

  factory HttpClient() => _instance;

  late final Dio _dio;

  Dio get dio => _dio;
}
