import 'package:dio/dio.dart';
import 'package:template_flutter/core/shared/controller/domain/response_item.dart';
import 'package:template_flutter/core/shared/error/domain/api_error.dart';
import 'package:template_flutter/core/shared/http/domain/endpoint.dart';
import 'package:template_flutter/core/shared/http/domain/http_response.dart';
import 'package:template_flutter/core/shared/http/infraestructure/dio_http_repository.dart';

class EditableRepository<T> {
  final DioHttpRepository _httpRepository = DioHttpRepository.getInstance();
  final Endpoint endpoint;

  EditableRepository(this.endpoint);

  /// PUT completo de la entidad
  Future<ResponseItem<T, HttpResponsePut<T>>> editar(
      int? id,
      dynamic entidad, // 👈 lo recibo como dynamic por si es Map o modelo
      T Function(dynamic json) fromJsonT, // 👈 factory para parsear T
      {Map<String, dynamic>? params}) async {
    try {
      final ruta = _httpRepository.getEndpoint(
        endpoint: endpoint,
        id: id,
        args: params,
      );

      final response = await _httpRepository.put(
        ruta,
        data: entidad,
      );

      final responseData = HttpResponsePut<T>.fromJson(
        response.data as Map<String, dynamic>, // 👈 seguridad extra
        fromJsonT,
      );

      return ResponseItem<T, HttpResponsePut<T>>(
        response: responseData,
        result: responseData.data.modelo, // caso simple
      );
    } on DioException catch (error) {
      throw ApiError.fromDioError(error);
    }
  }

  /// PATCH parcial de algunos campos
  Future<ResponseItem<T, HttpResponsePut<T>>> editarParcial(
      int id,
      Map<String, dynamic> data,
      T Function(dynamic json) fromJsonT, // 👈 igual que arriba
      {Map<String, dynamic>? params}) async {
    try {
      final ruta = _httpRepository.getEndpoint(
        endpoint: endpoint,
        id: id,
        args: params,
      );

      final response = await _httpRepository.patch(
        ruta,
        data: data,
      );

      final responseData = HttpResponsePut<T>.fromJson(
        response.data as Map<String, dynamic>,
        fromJsonT,
      );

      return ResponseItem<T, HttpResponsePut<T>>(
          response: responseData, result: responseData.data.modelo);
    } on DioException catch (error) {
      throw ApiError.fromDioError(error);
    }
  }
}
