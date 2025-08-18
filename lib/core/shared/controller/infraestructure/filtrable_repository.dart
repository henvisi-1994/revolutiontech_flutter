import 'package:dio/dio.dart';
import 'package:template_flutter/core/shared/http/domain/endpoint.dart';
import 'package:template_flutter/core/shared/http/infraestructure/dio_http_repository.dart';
import 'package:template_flutter/core/shared/error/domain/api_error.dart';
import 'package:template_flutter/core/shared/http/domain/http_response.dart';
import 'package:template_flutter/core/shared/controller/domain/response_item.dart';

class FiltrableRepository<T> {
  final DioHttpRepository _httpRepository = DioHttpRepository.getInstance();
  final Endpoint endpoint;

  FiltrableRepository(this.endpoint);

  Future<ResponseItem<List<C>, HttpResponseGet<HttpResponseList<C>>>>
      filtrar<C>(
    String uri,
    C Function(Map<String, dynamic>) fromJsonC,
  ) async {
    try {
      // Construcción de la ruta
      final baseRuta = _httpRepository.getEndpoint(endpoint: endpoint);
      final ruta = uri.startsWith('?') ? "$baseRuta$uri" : "$baseRuta?$uri";

      // Llamada GET
      final response = await _httpRepository.get<Map<String, dynamic>>(ruta);

      // Normalizamos data
      final rawData = response.data?['data'];
      final normalized = rawData is Map<String, dynamic>
          ? rawData
          : {'results': rawData ?? []};

      // Parseamos la lista de C
      final dataList = HttpResponseList<C>.fromJson(
        normalized,
        (item) => fromJsonC(item as Map<String, dynamic>),
      );

      // Parseamos a HttpResponseGet
      final responseData = HttpResponseGet<HttpResponseList<C>>(
        data: dataList,
        status: response.data?['status'] ?? 'success',
      );

      return ResponseItem<List<C>, HttpResponseGet<HttpResponseList<C>>>(
        response: responseData,
        result: dataList.results,
      );
    } on DioException catch (error) {
      throw ApiError.fromDioError(error);
    }
  }
}
