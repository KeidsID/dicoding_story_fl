/// Environment variables from `.env` file.
abstract class Envs {
  static const bool isNoHashUrl = bool.fromEnvironment('IS_NO_HASH_URL');
  static const String debugGMapsApiKey = String.fromEnvironment('DEBUG_GMAPS_API_KEY');
}
