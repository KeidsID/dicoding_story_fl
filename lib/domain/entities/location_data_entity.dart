import "package:freezed_annotation/freezed_annotation.dart";

part "location_data_entity.freezed.dart";

@Freezed(copyWith: true)
class LocationData with _$LocationData {
  const factory LocationData({
    /// Stands for latitude.
    required double lat,

    /// Stands for longitude.
    required double lon,
    LocationPlaceData? placeData,
  }) = _LocationData;

  const LocationData._();

  /// [lat], [lon] formatted as "lat, lon".
  String get latLon => "$lat, $lon";

  /// Get address from [placeData].
  ///
  /// return [latLon] if address not found.
  String get address => placeData?.address ?? latLon;

  /// Get display name from [placeData].
  ///
  /// return [address] if display name not found.
  String get displayName => placeData?.displayName ?? address;
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
