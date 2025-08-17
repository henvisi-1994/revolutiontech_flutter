class ResponseData<T> {
  final String mensaje;
  final String errores;
  final T modelo;

  ResponseData({
    required this.mensaje,
    required this.errores,
    required this.modelo,
  });

  factory ResponseData.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return ResponseData(
      mensaje: json['mensaje'] ?? '',
      errores: json['errores'] ?? '',
      modelo: fromJsonT(json['modelo']),
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) => {
        'mensaje': mensaje,
        'errores': errores,
        'modelo': toJsonT(modelo),
      };
}

class HttpResponseGet<T> {
  final int status;
  final T data;

  HttpResponseGet({required this.status, required this.data});

  factory HttpResponseGet.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return HttpResponseGet(
      status: json['status'],
      data: fromJsonT(json['data']),
    );
  }
}

class HttpResponsePost<T> {
  final int status;
  final ResponseData<T> data;

  HttpResponsePost({required this.status, required this.data});

  factory HttpResponsePost.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return HttpResponsePost(
      status: json['status'],
      data: ResponseData.fromJson(json['data'], fromJsonT),
    );
  }
}

class HttpResponseList<T> {
  final int count;
  final String? next;
  final String? previous;
  final List<T> results;

  HttpResponseList({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  factory HttpResponseList.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return HttpResponseList(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results:
          (json['results'] as List).map((item) => fromJsonT(item)).toList(),
    );
  }
}

class HttpResponsePut<T> {
  final int status;
  final ResponseData<T> data;

  HttpResponsePut({required this.status, required this.data});

  factory HttpResponsePut.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return HttpResponsePut(
      status: json['status'],
      data: ResponseData.fromJson(json['data'], fromJsonT),
    );
  }
}

class HttpResponseDelete<T> {
  final int status;
  final ResponseData<T> data;

  HttpResponseDelete({required this.status, required this.data});

  factory HttpResponseDelete.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return HttpResponseDelete(
      status: json['status'],
      data: ResponseData.fromJson(json['data'], fromJsonT),
    );
  }
}
