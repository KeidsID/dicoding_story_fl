import "package:freezed_annotation/freezed_annotation.dart";

part "location_data_entity.freezed.dart";

@Freezed(copyWith: true)
class LocationData with _$LocationData {
  const factory LocationData(
    /// Latitude in degrees
    double latitude,

    /// Longitude in degrees.
    double longitude, {
    LocationPlaceData? placeData,
  }) = _LocationData;

  const LocationData._();

  /// [latitude] and [longitude] formatted as "latitude, longitude".
  String get latLon => "$latitude, $longitude";

  /// Get address from [placeData].
  String? get address => placeData?.address;

  /// Get display name from [placeData].
  String? get displayName => placeData?.displayName;
}

/// [g-maps-places-api]: https://developers.google.com/maps/documentation/places/web-service
///
/// [Google Maps Places API data][g-maps-places-api].
@Freezed(copyWith: true)
class LocationPlaceData with _$LocationPlaceData {
  const factory LocationPlaceData({
    required String id,
    String? address,
    String? displayName,
  }) = _LocationPlaceData;
}
