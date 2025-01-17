import "package:injectable/injectable.dart";

import "package:dicoding_story_fl/domain/entities.dart";
import "package:dicoding_story_fl/domain/services.dart";
import "package:dicoding_story_fl/use_cases/libs/types.dart";

@singleton
final class SearchPlaceUseCase
    implements UseCase<SearchPlaceRequestDto, List<LocationData>> {
  const SearchPlaceUseCase(this._mapsService);

  final MapsService _mapsService;

  @override
  Future<List<LocationData>> execute(SearchPlaceRequestDto requestDto) {
    final SearchPlaceRequestDto(:query, :languageCode) = requestDto;

    return _mapsService.searchPlace(query, languageCode: languageCode);
  }
}

final class SearchPlaceRequestDto {
  const SearchPlaceRequestDto(this.query, {this.languageCode});

  final String query;
  final String? languageCode;
}
