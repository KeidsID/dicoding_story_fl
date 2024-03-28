import 'package:flutter/material.dart';

/// [SizedBox] base class without child.
///
/// Used for easy [SizedBox] constructors implementation on your own widget.
///
/// Note that this class only contain [width] and [height] and didn't build an
/// actual [SizedBox].
///
/// ```dart
/// @override
/// Widget build(BuildContext context) {
///   // implement like this to make use of this base class.
///   return SizedBox( // or maybe a [Container]
///     width: width,
///     height: height,
///     child: YourWidgetImplementation(),
///   );
/// }
/// ```
abstract base class SizedBoxBase extends StatelessWidget {
  const SizedBoxBase({super.key, this.width, this.height});

  const SizedBoxBase.expand({super.key})
      : width = double.infinity,
        height = double.infinity;

  const SizedBoxBase.shrink({super.key})
      : width = null,
        height = null;

  SizedBoxBase.fromSize({super.key, Size? size})
      : width = size?.width,
        height = size?.height;

  const SizedBoxBase.square({super.key, double? dimension})
      : width = dimension,
        height = dimension;

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) => SizedBox(width: width, height: height);
}
