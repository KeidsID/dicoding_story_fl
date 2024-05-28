import 'package:dicoding_story_fl/core/entities.dart';
import 'package:dicoding_story_fl/core/repos.dart';

class ReverseGeocodingCase {
  const ReverseGeocodingCase(this._mapsRepo);

  final GMapsRepo _mapsRepo;

  Future<LocationCore> execute(
    double latitude,
    double longitude, {
    bool includeDisplayName = false,
    String? languageCode,
  }) =>
      _mapsRepo.reverseGeocoding(
        latitude,
        longitude,
        includeDisplayName: includeDisplayName,
        languageCode: languageCode,
      );
}
