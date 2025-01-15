import "package:freezed_annotation/freezed_annotation.dart";

/// Ignore freezed json_serializable on specific fields.
const ignoreJsonSerializable = JsonKey(
  includeFromJson: false,
  includeToJson: false,
);
