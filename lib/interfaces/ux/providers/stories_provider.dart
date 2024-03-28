import 'package:flutter/foundation.dart';

import 'package:dicoding_story_fl/container.dart' as container;
import 'package:dicoding_story_fl/core/entities.dart';
import 'package:dicoding_story_fl/core/use_cases.dart';

class StoriesProvider extends ValueNotifier<List<Story>?> {
  StoriesProvider([List<Story>? initialValue]) : super(initialValue);

  /// Asynchronous process running.
  bool isLoading = false;

  /// Check if [value] is not null.
  bool get hasValue => value != null;

  @override
  set value(List<Story>? newValue) {
    isLoading = false;
    super.value = newValue;
  }

  Object? _error;
  StackTrace? _trace;

  /// Error that may occur during asynchronous process.
  Object? get error => _error;

  /// [error] trace.
  StackTrace? get trace => _trace;

  void _setError(Object? err, StackTrace? trace) {
    _error = err;
    _trace = trace;
    isLoading = false;
    notifyListeners();
  }

  /// Fetch stories and set it to [value].
  Future<void> fetchStories(
    UserCreds userCreds, {
    int page = 1,
    int size = 10,
    bool? hasCordinate,
  }) async {
    try {
      isLoading = true;

      final stories = await container.get<GetStoriesCase>().execute(
            userCreds,
            page: page,
            size: size,
            hasCordinate: hasCordinate,
          );

      value = stories;
    } catch (err, trace) {
      _setError(err, trace);
      rethrow;
    }
  }
}
