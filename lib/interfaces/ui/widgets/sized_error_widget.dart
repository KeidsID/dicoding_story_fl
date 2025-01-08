import "package:fl_utilities/fl_utilities.dart";
import "package:flutter/material.dart";

import "package:dicoding_story_fl/core/entities.dart";

final class SizedErrorWidget extends StatelessWidget {
  const SizedErrorWidget({
    super.key,
    this.width,
    this.height,
    this.error,
    StackTrace? trace,
    this.action,
  }) : _trace = trace;

  const SizedErrorWidget.expand({
    super.key,
    this.error,
    StackTrace? trace,
    this.action,
  })  : _trace = trace,
        width = double.infinity,
        height = double.infinity;

  const SizedErrorWidget.shrink({
    super.key,
    this.error,
    StackTrace? trace,
    this.action,
  })  : _trace = trace,
        width = 0.0,
        height = 0.0;

  SizedErrorWidget.fromSize({
    super.key,
    Size? size,
    this.error,
    StackTrace? trace,
    this.action,
  })  : _trace = trace,
        width = size?.width,
        height = size?.height;

  const SizedErrorWidget.square({
    super.key,
    double? dimension,
    this.error,
    StackTrace? trace,
    this.action,
  })  : _trace = trace,
        width = dimension,
        height = dimension;

  final double? width;
  final double? height;

  final Object? error;
  final StackTrace? _trace;

  StackTrace? get trace {
    return error is SimpleException ? (error as SimpleException).trace : _trace;
  }

  /// An action at the bottom.
  ///
  /// Typically an [ElevatedButton].
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    final SimpleException simpleException = error is SimpleException
        ? (error as SimpleException)
        : SimpleException(error: error, trace: trace);

    final statusCodeText = simpleException is SimpleHttpException
        ? Text(
            "${simpleException.statusCode}",
            style: textTheme.headlineMedium,
          )
        : const SizedBox.shrink();

    return SizedBox(
      width: width,
      height: height,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            statusCodeText,
            Text(simpleException.name, style: textTheme.titleLarge),
            const Divider(),
            Text(simpleException.message),
            const SizedBox(height: 16.0),
            action ?? const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
