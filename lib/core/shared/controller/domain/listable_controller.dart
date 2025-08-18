import 'package:template_flutter/core/shared/controller/domain/response_item.dart';
import 'package:template_flutter/core/shared/http/domain/http_response.dart';

/// Equivalente a ListableController<T> de TypeScript
abstract class ListableController<T> {
  /// Listar ítems
  Future<ResponseItem<List<C>, HttpResponseGet<HttpResponseList<C>>>>
      listar<C>({
    Map<String, dynamic>? params,
  });
}
