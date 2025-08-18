import 'package:dio/dio.dart';
import 'package:template_flutter/core/shared/http/domain/endpoint.dart';
import 'package:template_flutter/core/shared/http/infraestructure/dio_http_repository.dart';
import 'package:template_flutter/core/shared/controller/domain/response_item.dart';
import 'package:template_flutter/core/shared/error/domain/api_error.dart';
import 'package:template_flutter/core/shared/http/domain/http_response.dart';

class GuardableRepository<T> {
  final DioHttpRepository _httpRepository = DioHttpRepository.getInstance();
  final Endpoint endpoint;

  GuardableRepository(this.endpoint);

  Future<ResponseItem<T, HttpResponsePost<T>>> guardar(
    dynamic entidad, {
    Map<String, dynamic>? params,
  }) async {
    try {
      final ruta =
          _httpRepository.getEndpoint(endpoint: endpoint, args: params);

      final response = await _httpRepository.post(ruta, data: entidad);

      // Retornamos la respuesta tal cual sin parsear con fromJsonT
      final responseData = HttpResponsePost<T>.fromJson(
        response.data,
        (json) =>
            json as T, // simple cast, T puede ser Map u objeto ya convertido
      );

      return ResponseItem<T, HttpResponsePost<T>>(
        response: responseData,
        result: responseData.data.modelo,
      );
    } on DioException catch (error) {
      throw ApiError.fromDioError(error);
    }
  }
}
