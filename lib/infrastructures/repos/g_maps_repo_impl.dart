import 'package:flutter/foundation.dart';
import 'package:flutter_google_maps_webservices/geocoding.dart'
    as geocoding_lib;
import 'package:location/location.dart';
import 'package:flutter_google_maps_webservices/places.dart' as places;

import 'package:dicoding_story_fl/common/envs.dart';
import 'package:dicoding_story_fl/core/entities.dart';
import 'package:dicoding_story_fl/core/repos.dart';

class GMapsRepoImpl implements GMapsRepo {
  const GMapsRepoImpl();

  String get apiKey {
    if (kDebugMode) return Envs.debugGMapsApiKey;

    if (kIsWeb) return 'AIzaSyDXOqR3ycqGwIrYHWb61EzHyKCMR4vX9x8';

    return switch (defaultTargetPlatform) {
      TargetPlatform.android => 'AIzaSyBT_mGuD0z_5bwzM6u3Dqyd2S7-A8Q85Vw',
      TargetPlatform.iOS => 'AIzaSyAZD6mFtNivM4GQ1Yf27Ikgf1bIH0UeZs4',
      _ => 'invalid-platform',
    };
  }

  /// Request for location service. May throw exception if not granted.
  Future<void> _requestLocService() async {
    final loc = Location.instance;

    bool isEnabled = await loc.serviceEnabled();
    PermissionStatus permissionStatus = await loc.hasPermission();

    if (!isEnabled) {
      isEnabled = await loc.requestService();
      if (!isEnabled) {
        return;
      }
    }

    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await loc.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        return;
      }
    }

    if (!isEnabled) {
      throw const SimpleException(
        name: 'Location Service Disabled',
        message: 'Please enable location service',
      );
    }

    switch (permissionStatus) {
      case PermissionStatus.denied:
      case PermissionStatus.deniedForever:
        throw const SimpleException(
          name: 'Permission Denied',
          message: 'Please grant permission to access location',
        );
      default:
    }
  }

  @override
  Future<LocationCore> getLocation() async {
    await _requestLocService();

    final location = await Location.instance.getLocation();

    return LocationCore(location.latitude ?? 0, location.longitude ?? 0);
  }

  @override
  Future<List<PlaceCore>> searchPlace(String query) async {
    final api = places.GoogleMapsPlaces(apiKey: apiKey);

    final res = await api.searchByText(query);

    if (!(res.status == places.GoogleResponseStatus.okay)) {
      final code =
          res.status == places.GoogleResponseStatus.notFound ? 404 : 500;

      throw SimpleHttpException(
        statusCode: code,
        message: res.errorMessage ?? 'Something went wrong',
        error: res,
        trace: StackTrace.current,
      );
    }

    return res.results.map((e) {
      return PlaceCore(
        e.placeId,
        address: e.formattedAddress,
        displayName: e.name,
      );
    }).toList();
  }

  @override
  Future<LocationCore> geocoding(String address) async {
    final api = geocoding_lib.GoogleMapsGeocoding(apiKey: apiKey);

    final res = await api.searchByAddress(address);

    if (!(res.status == geocoding_lib.GoogleResponseStatus.okay)) {
      final code =
          res.status == geocoding_lib.GoogleResponseStatus.notFound ? 404 : 500;

      throw SimpleHttpException(
        statusCode: code,
        message: res.errorMessage ?? 'Something went wrong',
        error: res,
        trace: StackTrace.current,
      );
    }

    final result = res.results.first.geometry.location;

    return LocationCore(result.lat, result.lng);
  }

  @override
  Future<PlaceCore> reverseGeocoding(LocationCore location) async {
    // TODO: Cache with location as key

    final api = geocoding_lib.GoogleMapsGeocoding(apiKey: apiKey);

    final res = await api.searchByLocation(geocoding_lib.Location(
      lat: location.lat,
      lng: location.lon,
    ));

    if (!(res.status == geocoding_lib.GoogleResponseStatus.okay)) {
      final code =
          res.status == geocoding_lib.GoogleResponseStatus.notFound ? 404 : 500;

      throw SimpleHttpException(
        statusCode: code,
        message: res.errorMessage ?? 'Something went wrong',
        error: res,
        trace: StackTrace.current,
      );
    }

    final result = res.results.first;

    return PlaceCore(result.placeId, address: result.formattedAddress);
  }
}
