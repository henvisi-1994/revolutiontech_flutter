import 'package:dio/dio.dart';
import 'package:template_flutter/core/shared/http/domain/endpoint.dart';
import 'package:template_flutter/core/shared/http/infraestructure/dio_http_repository.dart';
import 'package:template_flutter/core/shared/controller/domain/response_item.dart';
import 'package:template_flutter/core/shared/error/domain/api_error.dart';

class DescargableRepository {
  final DioHttpRepository _httpRepository = DioHttpRepository.getInstance();
  final Endpoint endpoint;

  DescargableRepository(this.endpoint);

  /// Descargar listado como archivo binario (bytes)
  Future<ResponseItem<List<int>, Response>> descargarListado(
      {Map<String, dynamic>? params}) async {
    try {
      final ruta =
          _httpRepository.getEndpoint(endpoint: endpoint, args: params);

      final response = await _httpRepository.get<List<int>>(
        ruta,
        options: Options(responseType: ResponseType.bytes),
      );

      return ResponseItem<List<int>, Response>(
        response: response,
        result: response.data ?? [],
      );
    } on DioException catch (error) {
      throw ApiError.fromDioError(error);
    } catch (e) {
      throw Exception('Error inesperado al descargar listado: $e');
    }
  }
}
