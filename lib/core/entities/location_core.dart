import 'package:equatable/equatable.dart';

/// {@template dicoding_story_fl.core.entities.LocationCore}
/// Core entity for geographic location.
/// {@endtemplate}
class LocationCore extends Equatable {
  /// {@macro dicoding_story_fl.core.entities.LocationCore}
  const LocationCore(this.lat, this.lon, {this.placeDetail});

  /// Latitude unit used for geographic coordinate.
  final double lat;

  /// Longitude unit used for geographic coordinate.
  final double lon;

  final PlaceCore? placeDetail;

  @override
  List<Object?> get props => [lat, lon, placeDetail];

  String get latlng => '$lat, $lon';

  /// Get display name from [placeDetail].
  ///
  /// If `null`, return [address].
  String get displayName => placeDetail?.displayName ?? address;

  /// Similar to [displayName], but this getter may return `null`.
  String? get displayNameOrNull => placeDetail?.displayName;

  /// Get address from [placeDetail].
  ///
  /// If `null`, return [latlng].
  String get address => placeDetail?.address ?? latlng;

  /// Copy current instance with modified [placeDetail].
  LocationCore applyPlace(PlaceCore? place) {
    return LocationCore(lat, lon, placeDetail: place);
  }
}

/// {@template dicoding_story_fl.core.entities.PlaceCore}
/// Core entity for place/address information.
/// {@endtemplate}
class PlaceCore extends Equatable {
  /// {@macro dicoding_story_fl.core.entities.PlaceCore}
  const PlaceCore(this.id, {this.address, this.displayName});

  final String id;
  final String? address;
  final String? displayName;

  @override
  List<Object?> get props => [id, address, displayName];
}
