import "package:freezed_annotation/freezed_annotation.dart";
import "package:flutter/foundation.dart";

part "app_exception_entity.freezed.dart";

@freezed
class AppException with _$AppException implements Exception {
  const factory AppException({
    @Default("Internal App Error") String name,
    @Default("Sorry for the inconvenience") String message,

    /// Raw error instance.
    Object? error,

    /// Stack trace of the [error].
    StackTrace? trace,
  }) = _AppException;
}
