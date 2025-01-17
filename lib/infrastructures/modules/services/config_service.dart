import "package:envied/envied.dart";

import "package:dicoding_story_fl/domain/services.dart";
import "package:injectable/injectable.dart";

part "config_service.g.dart";

@LazySingleton(as: ConfigService)
final class ConfigServiceImpl implements ConfigService {
  @override
  ConfigServiceEnv get env {
    return ConfigServiceEnv(
      debugGoogleMapsApiKey: _Env.debugGoogleMapsKey,
    );
  }
}

@Envied(useConstantCase: true, obfuscate: true)
abstract final class _Env {
  @EnviedField(defaultValue: "")
  static final String debugGoogleMapsKey = __Env.debugGoogleMapsKey;
}
