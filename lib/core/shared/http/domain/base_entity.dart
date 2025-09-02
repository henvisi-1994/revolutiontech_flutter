import 'package:template_flutter/core/shared/controller/domain/cloneable.dart';
import 'package:template_flutter/core/shared/controller/domain/json_serializable.dart';

abstract class BaseEntity extends JsonSerializable with Cloneable<BaseEntity> {
  final int? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BaseEntity({
    this.id,
    this.createdAt,
    this.updatedAt,
  });
}
