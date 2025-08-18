import 'dart:convert';

import 'package:template_flutter/core/entities/base_entity.dart';
import 'package:template_flutter/core/shared/controller/domain/controller.dart';
import 'package:template_flutter/core/shared/controller/domain/response_item.dart';
import 'package:template_flutter/core/shared/controller/infraestructure/consultable_repository.dart';
import 'package:template_flutter/core/shared/controller/infraestructure/guardable_repository.dart';
import 'package:template_flutter/core/shared/controller/infraestructure/editable_repository.dart';
import 'package:template_flutter/core/shared/controller/infraestructure/eliminable_repository.dart';
import 'package:template_flutter/core/shared/controller/infraestructure/filtrable_repository.dart';
import 'package:template_flutter/core/shared/controller/infraestructure/listado/descargable_repository.dart';
import 'package:template_flutter/core/shared/http/domain/endpoint.dart';
import 'package:template_flutter/core/shared/http/domain/http_response.dart';

abstract class TransaccionSimpleController<T extends BaseEntity>
    extends Controller<T> {
  final ConsultableRepository<T> _consultableRepository;
  final GuardableRepository<T> _guardableRepository;
  final EditableRepository<T> _editableRepository;
  final EliminableRepository<T> _eliminableRepository;
  final FiltrableRepository<T> _filtrableRepository;
  final DescargableRepository _descargableRepository;

  /// Solo se pide el endpoint
  TransaccionSimpleController(Endpoint endpoint)
      : _consultableRepository = ConsultableRepository<T>(endpoint),
        _guardableRepository = GuardableRepository<T>(endpoint),
        _editableRepository = EditableRepository<T>(endpoint),
        _eliminableRepository = EliminableRepository<T>(endpoint),
        _filtrableRepository = FiltrableRepository<T>(endpoint),
        _descargableRepository = DescargableRepository(endpoint);

  @override
  Future<ResponseItem<T, HttpResponseGet<T>>> consultar(
    int? id, {
    Map<String, dynamic>? params,
  }) {
    if (id == null) {
      throw ArgumentError('El ID no puede ser null para consultar');
    }
    return _consultableRepository.consultar(id, params: params);
  }

  @override
  Future<ResponseItem<T, HttpResponsePost<T>>> guardar(
    T item, {
    Map<String, dynamic>? params,
  }) {
    return _guardableRepository.guardar(item, params: params);
  }

  @override
  Future<ResponseItem<T, HttpResponsePut<T>>> editar(
    T item, {
    Map<String, dynamic>? params,
  }) {
    final dynamic id = (item as dynamic).id;
    if (id == null) {
      throw ArgumentError('El ID de la entidad no puede ser null para editar');
    }
    return _editableRepository.editar(id, item, (json) => item, params: params);
  }

  @override
  Future<ResponseItem<T, HttpResponseDelete<T>>> eliminar(
    int? id, {
    Map<String, dynamic>? params,
  }) {
    if (id == null) {
      throw ArgumentError('El ID no puede ser null para eliminar');
    }
    return _eliminableRepository.eliminar(id);
  }

  Future<ResponseItem<List<C>, HttpResponseGet<HttpResponseList<C>>>>
      filtrar<C>(
    String uri,
    C Function(dynamic) fromJsonC,
  ) {
    return _filtrableRepository.filtrar<C>(uri, fromJsonC);
  }

  @override
  Future<ResponseItem<List<C>, HttpResponseGet<HttpResponseList<C>>>>
      listar<C>({
    Map<String, dynamic>? params,
  }) {
    // Delegamos a _filtrableRepository
    return _filtrableRepository.filtrar<C>(
      '',
      (json) => json as C,
    );
  }

  Future<Map<String, dynamic>> descargarListado(
      {Map<String, dynamic>? params}) async {
    final responseItem =
        await _descargableRepository.descargarListado(params: params);
    final bytes = responseItem.result;
    final jsonString = utf8.decode(bytes);
    final Map<String, dynamic> jsonData = json.decode(jsonString);
    return jsonData;
  }
}
