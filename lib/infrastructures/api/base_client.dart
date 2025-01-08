import "package:chopper/chopper.dart";
import "package:flutter/foundation.dart";

/// Main client for all API calls.
final baseClient = ChopperClient(
  baseUrl: Uri.tryParse("https://story-api.dicoding.dev/v1"),
  converter: const JsonConverter(),
  errorConverter: const JsonConverter(),
  interceptors: !kDebugMode
      ? null
      : [HttpLoggingInterceptor(level: Level.basic, logger: chopperLogger)],
);
