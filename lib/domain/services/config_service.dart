import "package:freezed_annotation/freezed_annotation.dart";

part "config_service.freezed.dart";

abstract interface class ConfigService {
  ConfigServiceEnv get env;
}

@freezed
class ConfigServiceEnv with _$ConfigServiceEnv {
  const factory ConfigServiceEnv({
    /// Google Maps API key for development.
    ///
    /// This is not used in production. Production api keys will be hard coded
    /// since it will had "Key Restrictions" that prevent public access.
    ///
    /// * See: https://cloud.google.com/docs/authentication/api-keys#securing
    @Default("") String debugGoogleMapsApiKey,
  }) = _ConfigServiceEnv;
}
