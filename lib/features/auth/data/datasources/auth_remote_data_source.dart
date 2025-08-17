import 'package:template_flutter/core/services/api_service.dart';

import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final api = ApiService();

  @override
  Future<UserModel> login(String email, String password) async {
    final response = await api.post(
      "/auth/login",
      data: {"email": email, "password": password},
    );
    final token = response.data["access_token"];
    api.setToken(token);
    return UserModel(name: "Henry", email: email);
  }
}
