abstract class BaseEntity {
  final String? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const BaseEntity({
    this.id,
    this.createdAt,
    this.updatedAt,
  });
}
