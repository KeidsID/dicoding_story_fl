import 'package:dicoding_story_fl/core/entities.dart';
import 'package:dicoding_story_fl/core/repos.dart';

class SearchPlaceCase {
  const SearchPlaceCase(this._mapsRepo);

  final GMapsRepo _mapsRepo;

   Future<List<PlaceCore>> execute(String query) =>
      _mapsRepo.searchPlace(query);
}
