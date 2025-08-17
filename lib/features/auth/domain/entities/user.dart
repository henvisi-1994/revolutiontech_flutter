import 'package:template_flutter/core/entities/base_entity.dart';

class User extends BaseEntity {
  final String name;
  final String email;

  const User({
    super.id,
    required this.name,
    required this.email,
    super.createdAt,
    super.updatedAt,
  });
}
