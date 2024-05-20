import 'package:dicoding_story_fl/core/entities.dart';

/// Contains the interface to access
/// [Google Maps Platform APIs](https://developers.google.com/maps/documentation).
abstract interface class GMapsRepo {
  const GMapsRepo();

  /// Get current device location.
  Future<LocationCore> getLocation();

  /// Search place by query.
  Future<List<PlaceCore>> searchPlace(String query);

  /// Converts the address into latitude and longitude coordinates.
  ///
  /// - [address], the street address or [plus code](https://plus.codes/) that
  ///   you want to geocode.
  Future<LocationCore> geocoding(String address);

  /// Converts the latitude and longitude coordinates into an address.
  Future<PlaceCore> reverseGeocoding(LocationCore location);
}
