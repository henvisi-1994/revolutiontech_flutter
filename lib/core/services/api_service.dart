import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final Dio _dio;
  String? _token;
  late final String baseUrl;

  ApiService() : _dio = Dio() {
    // Cargar variables de entorno solo si no están ya cargadas
    _loadEnv().then((_) {
      baseUrl = dotenv.env['API_BASE_URL'] ?? ' ';
      _dio.options = BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          "Content-Type": "application/json",
        },
      );

      _dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (_token != null && _token!.isNotEmpty) {
              options.headers["Authorization"] = "Bearer $_token";
            }
            print("➡️ [${options.method}] ${options.uri}");
            if (options.data != null) print("📤 Body: ${options.data}");
            return handler.next(options);
          },
          onResponse: (response, handler) {
            print("✅ [${response.statusCode}] ${response.data}");
            return handler.next(response);
          },
          onError: (DioException e, handler) {
            print("❌ Error [${e.response?.statusCode}] ${e.message}");
            return handler.next(e);
          },
        ),
      );
    });
  }

  Future<void> _loadEnv() async {
    try {
      await dotenv.load(fileName: ".env");
    } catch (e) {
      throw Exception('Error al cargar el archivo .env: $e');
    }
  }

  /// Espera a que el servicio esté completamente inicializado
  Future<void> ensureInitialized() async {
    while (baseUrl == null) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  /// Guardar token en memoria
  void setToken(String token) {
    _token = token;
  }

  /// Limpiar token
  void clearToken() {
    _token = null;
  }

  /// Métodos HTTP genéricos
  Future<Response> get(String endpoint,
      {Map<String, dynamic>? queryParams, Options? options}) async {
    await ensureInitialized();
    return await _dio.get(endpoint,
        queryParameters: queryParams, options: options);
  }

  Future<Response> post(String endpoint,
      {dynamic data, Options? options}) async {
    await ensureInitialized();
    return await _dio.post(endpoint, data: data, options: options);
  }

  Future<Response> put(String endpoint,
      {dynamic data, Options? options}) async {
    await ensureInitialized();
    return await _dio.put(endpoint, data: data, options: options);
  }

  Future<Response> delete(String endpoint,
      {dynamic data, Options? options}) async {
    await ensureInitialized();
    return await _dio.delete(endpoint, data: data, options: options);
  }
}
