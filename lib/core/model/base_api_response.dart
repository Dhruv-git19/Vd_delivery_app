class DataResponse {
  final int returnCode;
  final String responseDateTime;
  final String description;

  DataResponse({
    required this.returnCode,
    required this.responseDateTime,
    required this.description,
  });

  factory DataResponse.fromJson(Map<String, dynamic> json) {
    return DataResponse(
      returnCode: json['returnCode'] ?? 0,
      responseDateTime: json['responseDateTime'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class BaseApiResponse<T> {
  final DataResponse dataResponse;
  final T? data;

  BaseApiResponse({required this.dataResponse, this.data});

  factory BaseApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromDataJson,
  ) {
    return BaseApiResponse<T>(
      dataResponse: DataResponse.fromJson(json['dataResponse'] ?? {}),
      data: json.containsKey('data') && fromDataJson != null && json['data'] != null
          ? fromDataJson(json['data'])
          : null,
    );
  }
}
