/// Container for locating a dependencies.
///
/// Call [init] before using [get].
///
/// ```dart
/// import 'package:dicoding_story_fl/container.dart' as container;
///
/// void main() async {
///   await container.init();
///
///   container.get<DependencyType>();
/// }
/// ```
library container;

import "container/container.dart" show init, get;

export "container/container.dart";
