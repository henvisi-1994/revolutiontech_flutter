import 'package:dio/dio.dart';
import 'package:template_flutter/core/shared/http/domain/endpoint.dart';
import 'package:template_flutter/core/shared/http/infraestructure/dio_http_repository.dart';
import 'package:template_flutter/core/shared/controller/domain/response_item.dart';
import 'package:template_flutter/core/shared/error/domain/api_error.dart';

class DescargableRepository {
  final Endpoint endpoint;

  DescargableRepository(this.endpoint);

  /// Descargar listado como archivo binario (bytes)
  Future<ResponseItem<List<int>, Response>> descargarListado(
      {Map<String, dynamic>? params}) async {
    try {
      // Obtenemos la instancia de DioHttpRepository
      final httpRepo = await DioHttpRepository.getInstance();

      // Construimos la ruta
      final ruta = httpRepo.getEndpoint(endpoint: endpoint, args: params);

      // Llamada GET con tipo bytes
      final response = await httpRepo.get<List<int>>(
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
