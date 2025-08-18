import 'package:dio/dio.dart';
import 'package:template_flutter/core/shared/http/domain/endpoint.dart';
import 'package:template_flutter/core/shared/http/infraestructure/dio_http_repository.dart';
import 'package:template_flutter/core/shared/controller/domain/response_item.dart';
import 'package:template_flutter/core/shared/error/domain/api_error.dart';
import 'package:template_flutter/core/shared/http/domain/http_response.dart';

class ListableFileRepository<T> {
  final DioHttpRepository _httpRepository = DioHttpRepository.getInstance();
  final Endpoint endpoint;

  /// Conversor JSON -> T
  final T Function(Map<String, dynamic>) fromJsonT;

  ListableFileRepository(this.endpoint, {required this.fromJsonT});

  Future<ResponseItem<List<T>, HttpResponseGet<HttpResponseList<T>>>>
      listarArchivos(int id, {Map<String, dynamic>? params}) async {
    try {
      // Construcción de la ruta
      final baseRuta = _httpRepository.getEndpoint(endpoint: endpoint);
      final ruta = params != null && params.isNotEmpty
          ? "$baseRuta/files/$id${_httpRepository.mapearArgumentos(params)}"
          : "$baseRuta/files/$id";

      // Llamada GET
      final response = await _httpRepository.get<Map<String, dynamic>>(ruta);

      // Normalizamos el JSON recibido
      final rawData = response.data?['data'];
      final normalized = rawData is Map<String, dynamic>
          ? rawData
          : {'results': rawData ?? []};

      // Parseamos la lista
      final dataList = HttpResponseList<T>.fromJson(
        normalized,
        (item) => fromJsonT(item as Map<String, dynamic>),
      );

      // Empaquetamos en HttpResponseGet
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
