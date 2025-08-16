import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserModel> login(String email, String password) async {
    // Aquí harías la llamada HTTP
    await Future.delayed(Duration(seconds: 1));
    return UserModel(id: "1", name: "Henry", email: email);
  }
}
