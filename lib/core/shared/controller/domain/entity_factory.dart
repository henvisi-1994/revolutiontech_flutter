import 'package:template_flutter/core/shared/http/domain/base_entity.dart';

/// Helper genérico para construir entidades
class EntityFactory<T extends BaseEntity> {
  final T Function(Map<String, dynamic>) fromJson;
  final T Function() empty;

  const EntityFactory({
    required this.fromJson,
    required this.empty,
  });
}
