import 'package:dicoding_story_fl/core/entities.dart';
import 'package:dicoding_story_fl/core/repos.dart';

class GetLocationCase {
  const GetLocationCase(this._mapsRepo);

  final GMapsRepo _mapsRepo;

  Future<LocationCore> execute() => _mapsRepo.getLocation();
}
