import "package:flutter/foundation.dart";

import "package:dicoding_story_fl/core/entities.dart";

/// Asynchronous [ValueNotifier].
///
/// Had utility to handle asynchronous process.
///
/// ```dart
/// final class MyNotifier extends AsyncValueNotifier<int> {
///   MyNotifier([super.initialValue]);
///
///   Future<void> fetch() async {
///     isLoading = true;
///
///     try {
///       value = await myAsyncProcess();
///     } catch (err, trace) {
///       setError(err, trace); // set error and stop loading.
///     }
///   }
/// }
/// ```
abstract base class AsyncValueNotifier<T> extends ValueNotifier<T?> {
  AsyncValueNotifier([super.initialValue]);

  bool _isLoading = false;
  bool _isError = false;

  /// Asynchronous process running.
  bool get isLoading => _isLoading;
  @protected
  set isLoading(bool value) {
    if (_isLoading == value) return;

    _isLoading = value;
    notifyListeners();
  }

  /// Asynchronous process failed.
  ///
  /// [error] may not be null.
  bool get isError => _isError;

  /// Check if [value] is not null.
  bool get hasValue => value != null;

  @protected
  @override
  set value(T? newValue) {
    _isError = false;
    _isLoading = false;
    super.value = newValue;
  }

  Object? _error;
  StackTrace? _trace;

  /// Error that may occur during asynchronous process.
  Object? get error => _error;

  /// [error] trace.
  StackTrace? get trace => _trace;

  /// Set [error] and [trace].
  ///
  /// [isError] will be set to true. Setting [value] will reset [isError].
  @protected
  void setError(Object? err, [StackTrace? stackTrace]) {
    _isError = true;
    _error = err;
    _trace = err is SimpleException ? err.trace : stackTrace;
    isLoading = false;
  }
}
