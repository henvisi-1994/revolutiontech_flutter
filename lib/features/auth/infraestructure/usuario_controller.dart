import 'package:template_flutter/core/entities/api.dart';
import 'package:template_flutter/core/shared/contenedor/modules/simple/infraestructure/transaccion_simple_controller.dart';
import 'package:template_flutter/features/auth/domain/entities/user.dart';

class UsuarioController extends TransaccionSimpleController<User> {
  UsuarioController() : super(ApiEndpoints.usuarios);
}
