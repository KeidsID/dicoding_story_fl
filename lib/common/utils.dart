import 'package:dicoding_story_fl/core/entities.dart';

extension ObjectX on Object? {
  /// Utility to convert [Object] to [SimpleException].
  SimpleException toSimpleException([StackTrace? trace]) {
    if (this is SimpleException) return this as SimpleException;

    return SimpleException(error: this, trace: trace);
  }
}
