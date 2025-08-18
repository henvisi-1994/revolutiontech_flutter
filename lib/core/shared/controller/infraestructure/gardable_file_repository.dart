import 'package:dio/dio.dart';
import 'package:template_flutter/core/shared/http/domain/endpoint.dart';
import 'package:template_flutter/core/shared/http/infraestructure/dio_http_repository.dart';
import 'package:template_flutter/core/shared/controller/domain/response_item.dart';
import 'package:template_flutter/core/shared/error/domain/api_error.dart';
import 'package:template_flutter/core/shared/http/domain/http_response.dart';

class GuardableFileRepository<T> {
  final Endpoint endpoint;

  GuardableFileRepository(this.endpoint);

  Future<ResponseItem<T, HttpResponsePost<T>>> guardarArchivos(
    int id,
    T entidad,
    T Function(dynamic) fromJsonT,
  ) async {
    try {
      // Esperamos la instancia singleton de DioHttpRepository
      final httpRepo = await DioHttpRepository.getInstance();

      // Construcción de ruta
      final ruta = "${httpRepo.getEndpoint(endpoint: endpoint)}/files/$id";

      // Llamada POST
      final response = await httpRepo.post(ruta, data: entidad);

      // Parseamos a HttpResponsePost<T>
      final responseData = HttpResponsePost<T>.fromJson(
        response.data as Map<String, dynamic>,
        fromJsonT,
      );

      return ResponseItem<T, HttpResponsePost<T>>(
        response: responseData,
        result: responseData.data.modelo, // 👈 aquí el modelo
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
