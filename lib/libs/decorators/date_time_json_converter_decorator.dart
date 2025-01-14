import "package:freezed_annotation/freezed_annotation.dart";

const dateTimeJsonConverter = DateTimeJsonConverter();

final class DateTimeJsonConverter implements JsonConverter<DateTime, String> {
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
