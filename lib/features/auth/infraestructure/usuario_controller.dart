import 'package:template_flutter/core/entities/api.dart';
import 'package:template_flutter/core/shared/controller/infraestructure/base_controller.dart';
import 'package:template_flutter/features/auth/domain/entities/user.dart';

class UsuarioController extends BaseController<User> {
  UsuarioController() : super(ApiEndpoints.usuarios, User.fromJson);
}
