import 'package:envied/envied.dart';

part 'env.g.dart';

/// Environment variables from ".env" file on project root dir.
@Envied(useConstantCase: true, obfuscate: false, allowOptionalFields: true)
abstract class Env {
  /// Whether to use hash url or not on web build.
  @EnviedField(defaultValue: false)
  static const bool isNoHashUrl = _Env.isNoHashUrl;

  /// Google Maps API key used on web build.
  /// 
  /// May `null` if you forget to set it.
  @EnviedField()
  static const String? gMapsWebApiKey = _Env.gMapsWebApiKey;
}
