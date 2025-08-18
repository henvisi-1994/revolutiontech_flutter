import 'package:dio/dio.dart';
import 'package:template_flutter/core/shared/http/domain/endpoint.dart';
import 'package:template_flutter/core/shared/http/infraestructure/dio_http_repository.dart';
import 'package:template_flutter/core/shared/controller/domain/response_item.dart';
import 'package:template_flutter/core/shared/error/domain/api_error.dart';
import 'package:template_flutter/core/shared/http/domain/http_response.dart';

class EliminableFileRepository<T> {
  final DioHttpRepository _httpRepository = DioHttpRepository.getInstance();
  final Endpoint endpoint;

  EliminableFileRepository(this.endpoint);

  Future<ResponseItem<T, HttpResponseDelete<T>>> eliminarFile(
    int id, {
    Map<String, dynamic>? params,
  }) async {
    try {
      // Armamos la ruta con endpoint + id
      final ruta =
          _httpRepository.getEndpoint(endpoint: endpoint, args: params, id: id);

      // Llamada DELETE
      final response = await _httpRepository.delete(ruta);

      // Parseamos la respuesta
      final responseData = HttpResponseDelete<T>.fromJson(
        response.data,
        (data) => data as T,
      );
      return ResponseItem<T, HttpResponseDelete<T>>(
        response: responseData,
        result: responseData.data.modelo, // en TS usabas response.data.mensaje
      );
    } on DioException catch (error) {
      throw ApiError.fromDioError(error);
    }
  }
}
