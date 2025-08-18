import 'package:dio/dio.dart';
import 'package:template_flutter/core/shared/http/domain/endpoint.dart';
import 'package:template_flutter/core/shared/http/infraestructure/dio_http_repository.dart';
import 'package:template_flutter/core/shared/controller/domain/response_item.dart';
import 'package:template_flutter/core/shared/error/domain/api_error.dart';
import 'package:template_flutter/core/shared/http/domain/http_response.dart';

class ListableRepository<T> {
  final DioHttpRepository _httpRepository = DioHttpRepository.getInstance();
  final Endpoint endpoint;

  /// Función para convertir JSON a T
  final T Function(Map<String, dynamic>) fromJsonT;

  ListableRepository(this.endpoint, {required this.fromJsonT});

  Future<ResponseItem<List<T>, HttpResponseGet<HttpResponseList<T>>>> listar({
    Map<String, dynamic>? params,
  }) async {
    try {
      // Construimos la ruta
      final ruta =
          _httpRepository.getEndpoint(endpoint: endpoint, args: params);

      // Llamada GET
      final response = await _httpRepository.get<Map<String, dynamic>>(ruta);

      // Parseamos HttpResponseList<T>
      final dataList = HttpResponseList<T>.fromJson(
        response.data?['data'] ?? {},
        (item) => fromJsonT(item),
      );

      // Parseamos HttpResponseGet
      final responseData = HttpResponseGet<HttpResponseList<T>>(
        data: dataList,
        status: response.data?['status'] ?? 'success',
      );

      return ResponseItem<List<T>, HttpResponseGet<HttpResponseList<T>>>(
        response: responseData,
        result: dataList.results,
      );
    } on DioException catch (error) {
      throw ApiError.fromDioError(error);
    }
  }
}
