import 'package:dio/dio.dart';
import 'package:template_flutter/core/shared/http/domain/endpoint.dart';
import 'package:template_flutter/core/shared/http/infraestructure/dio_http_repository.dart';
import 'package:template_flutter/core/shared/controller/domain/response_item.dart';
import 'package:template_flutter/core/shared/error/domain/api_error.dart';
import 'package:template_flutter/core/shared/http/domain/http_response.dart';

class GuardableFormDataRepository<T> {
  final DioHttpRepository _httpRepository = DioHttpRepository.getInstance();
  final Endpoint endpoint;

  GuardableFormDataRepository(this.endpoint);

  Future<ResponseItem<T, HttpResponsePost<T>>> guardar(
    T entidad,
    T Function(dynamic) fromJsonT, {
    Map<String, dynamic>? params,
  }) async {
    try {
      // Construimos la ruta con parámetros
      final ruta =
          _httpRepository.getEndpoint(endpoint: endpoint, args: params);

      // Convertimos entidad a FormData
      final formData = convertirJsonAFormData(entidad);

      // Hacemos POST con FormData
      final response = await _httpRepository.post(ruta, data: formData);

      // Parseamos la respuesta
      final responseData = HttpResponsePost<T>.fromJson(
        response.data,
        fromJsonT,
      );

      return ResponseItem<T, HttpResponsePost<T>>(
        response: responseData,
        result: responseData.data.modelo,
      );
    } on DioException catch (error) {
      throw ApiError.fromDioError(error);
    }
  }

  /// Convierte un objeto JSON a FormData
  FormData convertirJsonAFormData(dynamic entidad) {
    final formData = FormData();

    if (entidad is Map<String, dynamic>) {
      entidad.forEach((key, value) {
        if (value != null) {
          if (value is List<int>) {
            // 👈 Ejemplo: bytes de archivo
            formData.files.add(MapEntry(
              key,
              MultipartFile.fromBytes(value, filename: "$key.bin"),
            ));
          } else if (value is MultipartFile) {
            // 👈 Ejemplo: archivo ya preparado
            formData.files.add(MapEntry(key, value));
          } else {
            formData.fields.add(MapEntry(key, value.toString()));
          }
        }
      });
    } else {
      throw ArgumentError("Entidad debe ser un Map<String, dynamic>");
    }

    return formData;
  }
}
