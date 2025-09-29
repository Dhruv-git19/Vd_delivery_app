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
      returnCode: json['returnCode'],
      responseDateTime: json['responseDateTime'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'returnCode': returnCode,
      'responseDateTime': responseDateTime,
      'description': description,
    };
  }
}