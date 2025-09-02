import 'package:template_flutter/core/shared/controller/domain/entity_factory.dart';
import 'package:template_flutter/core/shared/http/domain/base_entity.dart';
import 'package:template_flutter/core/shared/http/domain/endpoint.dart';
import 'package:template_flutter/core/shared/http/infraestructure/dio_http_repository.dart';

abstract class BaseController<T extends BaseEntity> {
  final DioHttpRepository _apiService = DioHttpRepository();
  final Endpoint endpoint;
  final EntityFactory<T> factory;

  BaseController(this.endpoint, this.factory);

  Future<T> guardar(T item) async {
    final response =
        await _apiService.post(endpoint.accessor, data: item.toJson());
    return factory.fromJson(response.data);
  }

  Future<T> actualizar(String id, T item) async {
    final response =
        await _apiService.put('${endpoint.accessor}/$id', data: item.toJson());
    return factory.fromJson(response.data);
  }

  Future<void> eliminar(String id) async {
    await _apiService.delete('${endpoint.accessor}/$id');
  }

  Future<T> obtenerPorId(String id) async {
    final response = await _apiService.get('${endpoint.accessor}/$id');
    return factory.fromJson(response.data);
  }

  Future<List<T>> obtenerTodos({Map<String, dynamic>? queryParams}) async {
    final response =
        await _apiService.get(endpoint.accessor, queryParams: queryParams);

    final List data =
        response.data is List ? response.data : (response.data["items"] ?? []);

    return data.map((item) => factory.fromJson(item)).toList();
  }

  /// 🔹 Reset genérico
  T reset() => factory.empty();

  /// 🔹 Refrescar genérico
  T refrescar(T origen) => factory.fromJson(origen.toJson());
}
