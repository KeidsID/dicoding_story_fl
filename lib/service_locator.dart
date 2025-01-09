import "dart:async";

import "package:get_it/get_it.dart";
import "package:injectable/injectable.dart";

import "service_locator.config.dart";

/// The actual service locator.
///
/// Defined as private to prevent direct service registration.
final _locator = GetIt.instance;

/// Simple service locator.
///
/// Backed by [get_it](https://pub.dev/packages/get_it) with
/// [injectable](https://pub.dev/packages/injectable).
///
/// ```dart
/// import "package:sv/service_locator.dart";
///
/// Future<void> main() async {
///   await ServiceLocator.init();
///
///   final myService = ServiceLocator.find<MyService>();
/// }
/// ```
abstract final class ServiceLocator {
  /// Get [T] instance from the service locator.
  ///
  /// Don't forget to call [init] first.
  static T find<T extends Object>() => _locator.get<T>();

  /// Initialize [injectable](https://pub.dev/packages/injectable) services and
  /// check if all registered services are ready to use.
  static Future<void> init() async {
    await _injectableInit();

    return _locator.allReady();
  }
}

@InjectableInit(preferRelativeImports: true)
FutureOr<GetIt> _injectableInit() => _locator.init();
