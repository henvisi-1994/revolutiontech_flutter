import 'package:template_flutter/core/services/api_service.dart';
import 'package:template_flutter/features/auth/domain/entities/user.dart';
import 'package:template_flutter/features/auth/infraestructure/usuario_controller.dart';

import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  //final api = ApiService();
  final controller = UsuarioController();
  @override
  Future<UserModel> login(String email, String password) async {
    /*final response = await api.post(
      "/auth/login",
      data: {"email": email, "password": password},
    );*/
    controller.guardar(User(name: 'Henry', email: email));
    //final token = response.data["access_token"];
    // api.setToken(token);
    return UserModel(name: "Henry", email: email);
  }
}
