import 'package:template_flutter/core/shared/controller/domain/json_serializable.dart';

mixin Cloneable<T extends JsonSerializable> on JsonSerializable {
  /// Debe proveer un constructor desde JSON
  T fromJson(Map<String, dynamic> json);

  /// 🔹 Clona la instancia actual
  T clone() => fromJson(toJson());

  /// 🔹 Refresca el destino con los valores de origen
  T refrescar(T origen) => fromJson(origen.toJson());

  /// 🔹 Reset genérico, requiere que se implemente `empty`
  T empty();
}
