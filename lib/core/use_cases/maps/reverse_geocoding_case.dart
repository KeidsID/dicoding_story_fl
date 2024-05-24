import 'package:dicoding_story_fl/core/entities.dart';
import 'package:dicoding_story_fl/core/repos.dart';

class ReverseGeocodingCase {
  const ReverseGeocodingCase(this._mapsRepo);

  final GMapsRepo _mapsRepo;

  Future<LocationCore> execute(LocationCore location) => _mapsRepo.reverseGeocoding(location);
}
