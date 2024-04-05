import 'package:dicoding_story_fl/core/entities.dart';

/// Extension on nullable [Object].
extension NullableObjectX on Object? {
  /// Utility to convert [Object] to [SimpleException].
  SimpleException toSimpleException([StackTrace? trace]) {
    if (this is SimpleException) return this as SimpleException;

    return SimpleException(error: this, trace: trace);
  }

  /// Return `null` instead `"null"` string on `null` value.
  /// 
  /// Otherwise, return the original [toString] result.
  String? toNullableString() => this == null ? null : '$this';
}
