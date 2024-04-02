import 'package:dicoding_story_fl/common/constants.dart';
import 'package:dicoding_story_fl/interfaces/ux/providers/auth_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import 'package:dicoding_story_fl/core/entities.dart';
import 'package:dicoding_story_fl/core/use_cases.dart';
import 'package:dicoding_story_fl/container.dart' as container;

class StoryDetailProvider extends ValueNotifier<StoryDetail?> {
  StoryDetailProvider({required this.storyId, required this.userCreds})
      : super(null) {
    Future.microtask(() async {
      try {
        await refresh();
      } catch (err) {
        // ignore error on init
        return;
      }
    });
  }

  final String storyId;
  final UserCreds userCreds;

  bool _isLoading = false;

  /// Asynchronous process running.
  bool get isLoading => _isLoading;

  /// Update [isLoading] and notify listeners.
  @protected
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Check if [value] is not null.
  bool get hasValue => value != null;

  @protected
  @override
  set value(StoryDetail? newValue) {
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

  /// Refresh [value].
  Future<void> refresh() async {
    isLoading = true;

    try {
      value = await container.get<GetStoryDetailCase>().execute(
            storyId,
            userCredentials: userCreds,
          );
    } catch (err, trace) {
      _setError(err, trace);
      rethrow;
    }
  }
}
