class CommonResponse {
  const CommonResponse({
    required this.error,
    required this.message,
  });

  final bool error;
  final String message;

  factory CommonResponse.fromJson(Map<String, dynamic> json) => CommonResponse(
        error: json["error"],
        message: json["message"],
      );
}
