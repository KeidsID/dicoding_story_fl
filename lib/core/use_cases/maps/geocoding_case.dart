import 'package:dicoding_story_fl/core/entities.dart';
import 'package:dicoding_story_fl/core/repos.dart';

class GeocodingCase {
  const GeocodingCase(this._mapsRepo);

  final GMapsRepo _mapsRepo;

  Future<LocationCore> execute(String address, {String? languageCode}) =>
      _mapsRepo.geocoding(address, languageCode: languageCode);
}
