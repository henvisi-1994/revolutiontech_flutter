import 'package:template_flutter/core/shared/controller/domain/listable_controller.dart';
import 'package:template_flutter/core/shared/controller/domain/response_item.dart';
import 'package:template_flutter/core/shared/http/domain/http_response.dart';

abstract class Controller<T> extends ListableController<T> {
  Future<ResponseItem<T, HttpResponseGet<T>>> consultar(
    int? id, {
    Map<String, dynamic>? params,
  });

  Future<ResponseItem<T, HttpResponsePost<T>>> guardar(
    T item, {
    Map<String, dynamic>? params,
  });

  Future<ResponseItem<T, HttpResponsePut<T>>> editar(
    T item, {
    Map<String, dynamic>? params,
  });

  /// Eliminar un ítem por id
  Future<ResponseItem<T, HttpResponseDelete<T>>> eliminar(
    int? id, {
    Map<String, dynamic>? params,
  });
}
