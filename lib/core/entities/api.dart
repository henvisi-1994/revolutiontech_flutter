import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../shared/http/domain/endpoint.dart';

class ApiConfig {
  static String get baseUrl =>
      dotenv.env['API_URL'] ?? ''; // Valor por defecto si no está en .env
}

class ApiEndpoints {
  // Autenticación
  static final csrfCookie = Endpoint('api/csrf-cookie', false);
  static final usuarios = Endpoint('usuarios');
  static final configuracion = Endpoint('configuracion');
  static final auditorias = Endpoint('auditorias');
  static final login = Endpoint('usuarios/login');
  static final register = Endpoint('usuarios/registro');
  static final logout = Endpoint('usuarios/logout');
  static final cambiarContrasena = Endpoint('usuarios/cambiar-contrasena');
  static final enviarCorreoRecuperacion =
      Endpoint('usuarios/recuperar-password');
  static final recuperacionCuenta = Endpoint('usuarios/validar-token');
  static final apiUser = Endpoint('user');
}
