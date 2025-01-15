import "package:freezed_annotation/freezed_annotation.dart";

/// {@template ds.libs.decorators.DateTimeJsonConverter}
/// Handle freezed json serialization for [DateTime] field.
/// {@endtemplate}
const dateTimeJsonConverter = DateTimeJsonConverter();

/// {@macro ds.libs.decorators.DateTimeJsonConverter}
final class DateTimeJsonConverter implements JsonConverter<DateTime, String> {
  /// {@macro ds.libs.decorators.DateTimeJsonConverter}
  const DateTimeJsonConverter();

  @override
  DateTime fromJson(String json) {
    return DateTime.parse(json);
  }

  @override
  String toJson(DateTime object) {
    return object.toIso8601String();
  }
}
