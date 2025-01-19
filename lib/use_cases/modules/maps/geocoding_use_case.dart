import "package:injectable/injectable.dart";

import "package:dicoding_story_fl/domain/entities.dart";
import "package:dicoding_story_fl/domain/services.dart";
import "package:dicoding_story_fl/use_cases/libs/types.dart";

@singleton
final class GeocodingUseCase
    implements UseCase<GeocodingRequestDto, LocationData> {
  const GeocodingUseCase(this._mapsService);

  final MapsService _mapsService;

  @override
  Future<LocationData> execute(GeocodingRequestDto requestDto) {
    final GeocodingRequestDto(:address, :languageCode) = requestDto;

    return _mapsService.geocoding(address, languageCode: languageCode);
  }
}

final class GeocodingRequestDto {
  const GeocodingRequestDto(this.address, {this.languageCode});

  final String address;
  final String? languageCode;
}
