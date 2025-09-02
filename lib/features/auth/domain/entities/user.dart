import 'package:template_flutter/core/shared/http/domain/base_entity.dart';

class User extends BaseEntity {
  late final String name;
  late final String email;

  User({
    super.id,
    super.createdAt,
    super.updatedAt,
    required this.name,
    required this.email,
  });

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "name": name,
        "email": email,
      };

  @override
  User fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : null,
        updatedAt: json["updatedAt"] != null
            ? DateTime.parse(json["updatedAt"])
            : null,
        name: json["name"],
        email: json["email"],
      );

  @override
  User empty() => User(name: "", email: "");
}

extension UserFactory on User {
  static User fromJsonFactory(Map<String, dynamic> json) => User(
        id: json["id"],
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : null,
        updatedAt: json["updatedAt"] != null
            ? DateTime.parse(json["updatedAt"])
            : null,
        name: json["name"] ?? "",
        email: json["email"] ?? "",
      );

  static User emptyFactory() => User(name: "", email: "");
}
