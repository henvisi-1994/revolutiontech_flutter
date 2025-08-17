import 'package:dio/dio.dart';
import 'package:template_flutter/core/shared/controller/domain/response_item.dart';
import 'package:template_flutter/core/shared/error/domain/api_error.dart';
import 'package:template_flutter/core/shared/http/domain/endpoint.dart';
import 'package:template_flutter/core/shared/http/domain/http_response.dart';
import 'package:template_flutter/core/shared/http/infraestructure/dio_http_repository.dart';

class ConsultableRepository<T> {
  final DioHttpRepository _httpRepository = DioHttpRepository.getInstance();
  final Endpoint endpoint;

  ConsultableRepository(this.endpoint);

  Future<ResponseItem<T, HttpResponseGet<T>>> consultar(
    int id, {
    Map<String, dynamic>? params,
  }) async {
    try {
      final ruta = _httpRepository.getEndpoint(
        endpoint: endpoint,
        id: id,
        args: params,
      );

      // Aquí asumimos que DioHttpRepository.get<T>() devuelve un HttpResponseGet<T>
      final response = await _httpRepository.get(
        ruta,
        queryParams: params,
      );

      final HttpResponseGet<T> parsed = HttpResponseGet.fromJson(
        response.data as Map<String, dynamic>, // 👈 aquí accedes al JSON
        (data) => data as T,
      );

      return ResponseItem<T, HttpResponseGet<T>>(
        response: parsed,
        result: parsed.data,
      );
    } catch (error) {
      if (error is DioException) {
        throw ApiError.fromDioError(error);
      } else {
        throw ApiError(
          mensaje: error.toString(),
          erroresValidacion: [],
          status: null,
        );
      }
    }
  }
}
