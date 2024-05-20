import 'package:equatable/equatable.dart';

/// {@template dicoding_story_fl.core.entities.LocationCore}
/// Core entity for geographic location.
/// {@endtemplate}
class LocationCore extends Equatable {
  /// {@macro dicoding_story_fl.core.entities.LocationCore}
  const LocationCore(this.lat, this.lon);

  /// Latitude unit used for geographic coordinate.
  final double lat;

  /// Longitude unit used for geographic coordinate.
  final double lon;
  
  @override
  List<Object?> get props => [lat, lon];
}
