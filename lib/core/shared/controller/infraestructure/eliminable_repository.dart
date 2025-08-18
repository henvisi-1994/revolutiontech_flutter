import 'package:dio/dio.dart';
import 'package:template_flutter/core/shared/http/domain/endpoint.dart';
import 'package:template_flutter/core/shared/http/infraestructure/dio_http_repository.dart';
import 'package:template_flutter/core/shared/error/domain/api_error.dart';
import 'package:template_flutter/core/shared/http/domain/http_response.dart';
import 'package:template_flutter/core/shared/controller/domain/response_item.dart';

class EliminableRepository<T> {
  final DioHttpRepository _httpRepository = DioHttpRepository.getInstance();
  final Endpoint endpoint;

  EliminableRepository(this.endpoint);

  Future<ResponseItem<T, HttpResponseDelete<T>>> eliminar(int id) async {
    try {
      final ruta = _httpRepository.getEndpoint(
        endpoint: endpoint,
        id: id,
      );

      // Llamamos al DELETE en DioHttpRepository
      final response = await _httpRepository.delete(ruta);

      // Adaptamos la respuesta al modelo HttpResponseDelete<T>
      final responseData = HttpResponseDelete<T>.fromJson(
        response.data,
        (data) => data as T,
      );

      return ResponseItem<T, HttpResponseDelete<T>>(
        response: responseData,
        result: responseData.data.modelo,
      );
    } on DioException catch (error) {
      throw ApiError.fromDioError(error);
    }
  }
}
