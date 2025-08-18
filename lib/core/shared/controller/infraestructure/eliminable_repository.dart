import 'package:dio/dio.dart';
import 'package:template_flutter/core/shared/http/domain/endpoint.dart';
import 'package:template_flutter/core/shared/http/infraestructure/dio_http_repository.dart';
import 'package:template_flutter/core/shared/error/domain/api_error.dart';
import 'package:template_flutter/core/shared/http/domain/http_response.dart';
import 'package:template_flutter/core/shared/controller/domain/response_item.dart';

class EliminableRepository<T> {
  final Endpoint endpoint;

  EliminableRepository(this.endpoint);

  Future<ResponseItem<T, HttpResponseDelete<T>>> eliminar(int id) async {
    try {
      // Esperamos la instancia singleton de DioHttpRepository
      final httpRepo = await DioHttpRepository.getInstance();

      // Armamos la ruta con endpoint + id
      final ruta = httpRepo.getEndpoint(
        endpoint: endpoint,
        id: id,
      );

      // Llamamos al DELETE en DioHttpRepository
      final response = await httpRepo.delete(ruta);

      // Adaptamos la respuesta al modelo HttpResponseDelete<T>
      final responseData = HttpResponseDelete<T>.fromJson(
        response.data as Map<String, dynamic>,
        (data) => data as T,
      );

      return ResponseItem<T, HttpResponseDelete<T>>(
        response: responseData,
        result: responseData.data.modelo,
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
