import 'package:template_flutter/core/shared/http/domain/base_entity.dart';

class User extends BaseEntity {
  String name;
  String email;
  String? photoProfile;

  User({
    super.id,
    super.createdAt,
    super.updatedAt,
    this.photoProfile,
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
        "photoProfile": photoProfile
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
        photoProfile: json["photoProfile"],
      );

  @override
  User empty() => User(name: "", email: "", photoProfile: "");
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
        photoProfile: json["photoProfile"] ?? "",
      );

  static User emptyFactory() => User(name: "", email: "", photoProfile: "");
}
