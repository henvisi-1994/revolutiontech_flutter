import 'package:dio/dio.dart';
import 'package:template_flutter/core/shared/controller/domain/response_item.dart';
import 'package:template_flutter/core/shared/error/domain/api_error.dart';
import 'package:template_flutter/core/shared/http/domain/endpoint.dart';
import 'package:template_flutter/core/shared/http/domain/http_response.dart';
import 'package:template_flutter/core/shared/http/infraestructure/dio_http_repository.dart';

class ConsultableRepository<T> {
  final Endpoint endpoint;
  final T Function(dynamic json) fromJson;
  final Future<DioHttpRepository> _httpRepository;

  ConsultableRepository(this.endpoint, this.fromJson)
      : _httpRepository = DioHttpRepository.getInstance();

  Future<ResponseItem<T, HttpResponseGet<T>>> consultar(
    int id, {
    Map<String, dynamic>? params,
  }) async {
    try {
      // Esperamos a que el singleton esté inicializado
      final httpRepo = await _httpRepository;

      final ruta = httpRepo.getEndpoint(
        endpoint: endpoint,
        id: id,
        args: params,
      );

      final response = await httpRepo.get(ruta, queryParams: params);

      final HttpResponseGet<T> parsed = HttpResponseGet.fromJson(
        response.data as Map<String, dynamic>,
        fromJson,
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
