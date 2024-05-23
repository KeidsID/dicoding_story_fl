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

  /// Get address from [placeDetail]. If not available, return [lat], and [lon]
  /// as address.
  String get address => placeDetail?.address ?? '$lat, $lon';

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
