import 'package:dio/dio.dart';

class ApiError implements Exception {
  final String mensaje;
  final List<String> erroresValidacion;
  final int? status;

  ApiError({
    required this.mensaje,
    required this.erroresValidacion,
    this.status,
  });

  factory ApiError.fromDioError(DioException error) {
    final response = error.response;
    final data = response?.data;

    String mensaje = data?['mensaje'] ?? error.message ?? "Error desconocido";
    List<String> erroresValidacion = [];

    // Similar a Object.values(error.response.data.errors) en TS
    if (data != null && data['errors'] != null) {
      final errorsMap = data['errors'] as Map<String, dynamic>;
      for (var value in errorsMap.values) {
        if (value is List) {
          erroresValidacion.addAll(value.map((e) => e.toString()));
        } else {
          erroresValidacion.add(value.toString());
        }
      }
    }

    return ApiError(
      mensaje: mensaje,
      erroresValidacion: erroresValidacion,
      status: response?.statusCode,
    );
  }

  @override
  String toString() {
    return "ApiError(status: $status, mensaje: $mensaje, errores: $erroresValidacion)";
  }
}
