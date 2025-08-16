// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/login_user.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';

void main() {
  final remoteDataSource = AuthRemoteDataSourceImpl();
  final repository = AuthRepositoryImpl(remoteDataSource);
  final loginUser = LoginUser(repository);

  runApp(MyApp(loginUser: loginUser));
}

class MyApp extends StatelessWidget {
  final LoginUser loginUser;

  const MyApp({required this.loginUser, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Clean Arch Demo',
      home: BlocProvider(
        create: (_) => AuthBloc(loginUser),
        child: LoginPage(),
      ),
    );
  }
}
