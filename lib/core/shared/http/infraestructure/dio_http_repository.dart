import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:template_flutter/core/shared/http/domain/endpoint.dart';

/// Equivalente a AxiosHttpRepository en TypeScript
class DioHttpRepository {
  static DioHttpRepository? _instance;
  static Dio? _dio;

  DioHttpRepository._internal();

  /// Inicializa Dio con configuración base
  static void _initialize() {
    final apiUrl = dotenv.env['API_BASE_URL'] ?? "";

    _dio = Dio(BaseOptions(
      baseUrl: apiUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        "Content-Type": "application/json",
      },
    ));

    // Interceptor para logs y token
    _dio!.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _token;
          if (token != null && token.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
          }
          print("➡️ [${options.method}] ${options.uri}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print("✅ [${response.statusCode}] ${response.data}");
          return handler.next(response);
        },
        onError: (e, handler) {
          print("❌ Error [${e.response?.statusCode}] ${e.message}");
          return handler.next(e);
        },
      ),
    );
  }

  /// Singleton getter
  static DioHttpRepository getInstance() {
    _instance ??= DioHttpRepository._internal();
    if (_dio == null) {
      _initialize();
    }
    return _instance!;
  }

  // ==== TOKEN ====
  static String? _token;

  static void setToken(String token) => _token = token;
  static void clearToken() => _token = null;

  // ==== MÉTODOS HTTP ====
  Future<Response<T>> get<T>(String url,
      {Map<String, dynamic>? queryParams, Options? options}) async {
    return await _dio!
        .get<T>(url, queryParameters: queryParams, options: options);
  }

  Future<Response<T>> post<T>(String url,
      {dynamic data, Options? options}) async {
    return await _dio!.post<T>(url, data: data, options: options);
  }

  Future<Response<T>> put<T>(String url,
      {dynamic data, Options? options}) async {
    return await _dio!.put<T>(url, data: data, options: options);
  }

  Future<Response<T>> delete<T>(String url,
      {dynamic data, Options? options}) async {
    return await _dio!.delete<T>(url, data: data, options: options);
  }

  Future<Response<T>> patch<T>(String url,
      {dynamic data, Options? options}) async {
    return await _dio!.patch<T>(url, data: data, options: options);
  }

  // ==== HELPERS ====

  /// Genera endpoint con `api/` prefix y opcional `id`
  String getEndpoint({
    required Endpoint endpoint,
    int? id,
    bool includeApiPath = true,
    Map<String, dynamic>? args,
  }) {
    String path = endpoint.toString();

    if (id != null) {
      path = "$path/$id";
    }

    if (includeApiPath) {
      path = "api/$path";
    }

    if (args != null && args.isNotEmpty) {
      path += mapearArgumentos(args);
    }

    return path;
  }

  /// Equivalente a `mapearArgumentos` en TS
  String mapearArgumentos(Map<String, dynamic> args, {bool filtrar = false}) {
    final query = <String>[];

    args.forEach((key, value) {
      if (value != null) {
        if (!filtrar) {
          final operador = key == "filter" ? "" : "=";
          final clave = key;
          query.add("$clave$operador$value");
        } else {
          query.add("$key[like]=%$value%");
        }
      }
    });

    var cadena = "?${query.join('&')}";
    if (cadena.contains('&filter')) {
      cadena = cadena.replaceFirst('&filter', '|');
    }
    if (cadena.contains('filter')) {
      cadena = cadena.replaceFirst('filter', '');
    }
    return cadena;
  }
}
