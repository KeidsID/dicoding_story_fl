import "package:injectable/injectable.dart";

import "package:dicoding_story_fl/domain/entities.dart";
import "package:dicoding_story_fl/domain/services.dart";
import "package:dicoding_story_fl/use_cases/libs/types.dart";

@singleton
final class GetLocationUseCase implements UseCase<void, LocationData> {
  const GetLocationUseCase(this._mapsService);

  final MapsService _mapsService;

  @override
  Future<LocationData> execute(void requestDto) {
    return _mapsService.getLocation();
  }
}
