import "package:dicoding_story_fl/domain/entities.dart";

extension NullableObjectExtension on Object? {
  AppException toAppException({String? message, StackTrace? trace}) {
    if (this is AppException) return this as AppException;

    return AppException(
      message: message ?? "Internal App Error",
      error: this,
      trace: trace,
    );
  }

  String? toNullableString() => this == null ? null : "$this";
}
