import 'package:dio/dio.dart';
import 'package:template_flutter/core/shared/error/domain/api_error.dart';
import 'package:template_flutter/core/shared/http/domain/endpoint.dart';
import 'package:template_flutter/core/shared/http/infraestructure/dio_http_repository.dart';
import 'package:template_flutter/core/shared/controller/domain/response_item.dart';
import 'package:template_flutter/core/shared/http/domain/http_response.dart';

class GuardableRepository<T> {
  final Endpoint endpoint;
  final T Function(dynamic json) fromJson;

  GuardableRepository(this.endpoint, this.fromJson);

  Future<ResponseItem<T, HttpResponsePost<T>>> guardar(
    dynamic entidad, {
    Map<String, dynamic>? params,
  }) async {
    try {
      // Esperamos la instancia singleton de DioHttpRepository
      final httpRepo = await DioHttpRepository.getInstance();

      // Construimos la ruta con parámetros opcionales
      final ruta = httpRepo.getEndpoint(endpoint: endpoint, args: params);
      // Hacemos POST
      final response = await httpRepo.post(ruta, data: entidad);
      // Parseamos la respuesta de manera genérica
      final responseData = HttpResponsePost<T>.fromJson(
          response.data as Map<String, dynamic>, fromJson);

      return ResponseItem<T, HttpResponsePost<T>>(
        response: responseData,
        result: responseData.data.modelo,
      );
    } on DioException catch (error) {
      throw ApiError.fromDioError(error);
    } catch (e) {
      throw ApiError(
        mensaje: 'Error inesperado al guardar: $e',
        erroresValidacion: [],
        status: null,
      );
    }
  }
}
