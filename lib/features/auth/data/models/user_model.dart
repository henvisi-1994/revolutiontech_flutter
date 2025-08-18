import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.name,
    required super.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        name: json["name"],
        email: json["email"],
      );
}
