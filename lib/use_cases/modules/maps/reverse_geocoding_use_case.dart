import "package:injectable/injectable.dart";

import "package:dicoding_story_fl/domain/entities.dart";
import "package:dicoding_story_fl/domain/services.dart";
import "package:dicoding_story_fl/use_cases/libs/types.dart";

@singleton
final class ReverseGeocodingUseCase
    implements UseCase<ReverseGeocodingRequestDto, LocationData> {
  const ReverseGeocodingUseCase(this._mapsService);

  final MapsService _mapsService;

  @override
  Future<LocationData> execute(ReverseGeocodingRequestDto requestDto) {
    final ReverseGeocodingRequestDto(
      :latitude,
      :longitude,
      :languageCode,
      :includeDisplayName,
    ) = requestDto;

    return _mapsService.reverseGeocoding(
      latitude,
      longitude,
      languageCode: languageCode,
      includeDisplayName: includeDisplayName,
    );
  }
}

final class ReverseGeocodingRequestDto {
  const ReverseGeocodingRequestDto(
    this.latitude,
    this.longitude, {
    this.languageCode,
    this.includeDisplayName = true,
  });

  final double latitude;
  final double longitude;
  final String? languageCode;
  final bool includeDisplayName;
}
