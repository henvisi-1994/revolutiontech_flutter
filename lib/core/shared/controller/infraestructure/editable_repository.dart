import 'package:dio/dio.dart';
import 'package:template_flutter/core/shared/controller/domain/response_item.dart';
import 'package:template_flutter/core/shared/error/domain/api_error.dart';
import 'package:template_flutter/core/shared/http/domain/endpoint.dart';
import 'package:template_flutter/core/shared/http/domain/http_response.dart';
import 'package:template_flutter/core/shared/http/infraestructure/dio_http_repository.dart';

class EditableRepository<T> {
  final Endpoint endpoint;

  EditableRepository(this.endpoint);

  /// PUT completo de la entidad
  Future<ResponseItem<T, HttpResponsePut<T>>> editar(
      int? id,
      dynamic entidad, // puede ser Map o modelo
      T Function(dynamic json) fromJsonT, // factory para parsear T
      {Map<String, dynamic>? params}) async {
    try {
      final httpRepo = await DioHttpRepository.getInstance();

      final ruta = httpRepo.getEndpoint(
        endpoint: endpoint,
        id: id,
        args: params,
      );

      final response = await httpRepo.put(
        ruta,
        data: entidad,
      );

      final responseData = HttpResponsePut<T>.fromJson(
        response.data as Map<String, dynamic>,
        fromJsonT,
      );

      return ResponseItem<T, HttpResponsePut<T>>(
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

  /// PATCH parcial de algunos campos
  Future<ResponseItem<T, HttpResponsePut<T>>> editarParcial(
      int id,
      Map<String, dynamic> data,
      T Function(dynamic json) fromJsonT, // factory para parsear T
      {Map<String, dynamic>? params}) async {
    try {
      final httpRepo = await DioHttpRepository.getInstance();

      final ruta = httpRepo.getEndpoint(
        endpoint: endpoint,
        id: id,
        args: params,
      );

      final response = await httpRepo.patch(
        ruta,
        data: data,
      );

      final responseData = HttpResponsePut<T>.fromJson(
        response.data as Map<String, dynamic>,
        fromJsonT,
      );

      return ResponseItem<T, HttpResponsePut<T>>(
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
