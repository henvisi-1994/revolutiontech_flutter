import 'package:template_flutter/core/shared/http/domain/base_entity.dart';
import 'package:template_flutter/core/shared/controller/domain/json_serializable.dart';

class User extends BaseEntity implements JsonSerializable {
  final String name;
  final String email;

  User({required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
      };
}
