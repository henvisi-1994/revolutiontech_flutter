import 'package:dio/dio.dart';
import 'package:template_flutter/core/shared/http/domain/endpoint.dart';
import 'package:template_flutter/core/shared/http/infraestructure/dio_http_repository.dart';
import 'package:template_flutter/core/shared/controller/domain/response_item.dart';
import 'package:template_flutter/core/shared/error/domain/api_error.dart';
import 'package:template_flutter/core/shared/http/domain/http_response.dart';

class EliminableFileRepository<T> {
  final Endpoint endpoint;

  EliminableFileRepository(this.endpoint);

  Future<ResponseItem<T, HttpResponseDelete<T>>> eliminarFile(
    int id, {
    Map<String, dynamic>? params,
  }) async {
    try {
      // Esperamos la instancia singleton de DioHttpRepository
      final httpRepo = await DioHttpRepository.getInstance();

      // Armamos la ruta con endpoint + id
      final ruta = httpRepo.getEndpoint(
        endpoint: endpoint,
        id: id,
        args: params,
      );

      // Llamada DELETE
      final response = await httpRepo.delete(ruta);

      // Parseamos la respuesta
      final responseData = HttpResponseDelete<T>.fromJson(
        response.data as Map<String, dynamic>,
        (data) => data as T,
      );

      return ResponseItem<T, HttpResponseDelete<T>>(
        response: responseData,
        result: responseData.data.modelo, // en TS usabas response.data.mensaje
      );
    } on DioException catch (error) {
      throw ApiError.fromDioError(error);
    } catch (e) {
      throw ApiError(
        mensaje: e.toString(),
        erroresValidacion: [],
        status: null,
      );
    }
  }
}
