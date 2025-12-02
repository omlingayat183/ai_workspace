import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  static final Dio dio = Dio(
    BaseOptions(
      // baseUrl: "http://localhost:5000/api",
      baseUrl: "http://10.0.2.2:5000/api",
      headers: {"Content-Type": "application/json"},
    ),
  );

  static final _storage = FlutterSecureStorage();
  static FlutterSecureStorage get storage => _storage;

  static init() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: "token");
          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
          }
          return handler.next(options);
        },
      ),
    );
  }
}
