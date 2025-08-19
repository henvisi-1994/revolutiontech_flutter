import 'package:template_flutter/core/shared/controller/domain/json_serializable.dart';
import 'package:template_flutter/core/shared/http/domain/endpoint.dart';
import 'package:template_flutter/core/shared/http/infraestructure/dio_http_repository.dart';

abstract class BaseController<T extends JsonSerializable> {
  final DioHttpRepository _apiService = DioHttpRepository();
  final Endpoint endpoint;

  /// Recibe una función constructora para instanciar T desde JSON
  final T Function(Map<String, dynamic>) fromJson;

  BaseController(this.endpoint, this.fromJson);

  /// Guardar un nuevo recurso
  Future<T> guardar(T item) async {
    final response =
        await _apiService.post(endpoint.accessor, data: item.toJson());
    return fromJson(response.data);
  }

  /// Actualizar un recurso existente
  Future<T> actualizar(String id, T item) async {
    final response =
        await _apiService.put('$endpoint/$id', data: item.toJson());
    return fromJson(response.data);
  }

  /// Eliminar un recurso
  Future<void> eliminar(String id) async {
    await _apiService.delete('$endpoint/$id');
  }

  /// Obtener un recurso por id
  Future<T> obtenerPorId(String id) async {
    var url = endpoint.accessor;
    final response = await _apiService.get('$url/$id');
    return fromJson(response.data);
  }

  /// Obtener lista de recursos
  Future<List<T>> obtenerTodos({Map<String, dynamic>? queryParams}) async {
    final response =
        await _apiService.get(endpoint.accessor, queryParams: queryParams);

    final List data =
        response.data is List ? response.data : (response.data["items"] ?? []);

    return data.map((item) => fromJson(item)).toList();
  }
}
