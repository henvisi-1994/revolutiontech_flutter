/// Cada modelo que quiera usarse en un BaseController debe implementar esto
abstract class JsonSerializable {
  Map<String, dynamic> toJson();
}
