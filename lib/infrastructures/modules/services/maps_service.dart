import "package:chopper/chopper.dart";
import "package:flutter/foundation.dart";
import "package:flutter_google_maps_webservices/geocoding.dart"
    as lib_geocoding;
import "package:injectable/injectable.dart";
import "package:location/location.dart" as lib_location;

import "package:dicoding_story_fl/domain/entities.dart";
import "package:dicoding_story_fl/domain/services.dart";
import "package:dicoding_story_fl/infrastructures/libs/data/remote/modules.dart";
import "package:dicoding_story_fl/libs/extensions.dart";
import "package:dicoding_story_fl/infrastructures/libs/constants.dart"
    show GoogleMapsApiKeys;

@LazySingleton(as: MapsService)
final class MapsServiceImpl implements MapsService {
  MapsServiceImpl(this._configService);

  final ConfigService _configService;
  lib_location.Location get _locationService => lib_location.Location.instance;
  lib_geocoding.GoogleMapsGeocoding get _geocodingService {
    return _geocodingServiceInstance ??=
        lib_geocoding.GoogleMapsGeocoding(apiKey: _googleMapsApiKey);
  }

  /// This act as a singleton state.
  ///
  /// Use [_geocodingService] instead.
  lib_geocoding.GoogleMapsGeocoding? _geocodingServiceInstance;

  GoogleMapsNewPlacesRemoteData get _newPlacesApiService {
    return _newPlacesApiServiceInstance ??=
        GoogleMapsNewPlacesRemoteData.create(
      GoogleMapsNewPlacesApiClient(apiKey: _googleMapsApiKey),
    );
  }

  /// This act as a singleton state.
  ///
  /// Use [_newPlacesApiService] instead.
  GoogleMapsNewPlacesRemoteData? _newPlacesApiServiceInstance;

  String get _googleMapsApiKey {
    if (kDebugMode) return _configService.env.debugGoogleMapsApiKey;

    if (kIsWeb) return GoogleMapsApiKeys.web;

    return switch (defaultTargetPlatform) {
      TargetPlatform.android => GoogleMapsApiKeys.android,
      TargetPlatform.iOS => GoogleMapsApiKeys.ios,
      _ => "unsuported platform",
    };
  }

  @override
  Future<LocationData> getLocation() async {
    await _requestLocationService();

    final rawLocation = await _locationService.getLocation();

    return LocationData(
      rawLocation.latitude ?? 0.0,
      rawLocation.longitude ?? 0.0,
    );
  }

  @override
  Future<LocationData> geocoding(
    String address, {
    String? languageCode,
  }) async {
    final response = await _geocodingService.searchByAddress(
      address,
      language: languageCode,
    );
    final isFail = response.status != lib_geocoding.GoogleResponseStatus.okay;

    if (isFail) {
      throw AppException(
        name: "MapsServiceImpl.geocoding",
        message: response.errorMessage ?? "Failed to geocoding",
        error: response,
      );
    }

    final result = response.results.first;
    final rawLocation = result.geometry.location;

    return LocationData(
      rawLocation.lat,
      rawLocation.lng,
      placeData: LocationPlaceData(
        id: result.placeId,
        address: result.formattedAddress,
      ),
    );
  }

  @override
  Future<LocationData> reverseGeocoding(
    double latitude,
    double longitude, {
    String? languageCode,
    bool includeDisplayName = true,
  }) async {
    final response = await _geocodingService.searchByLocation(
      lib_geocoding.Location(lat: latitude, lng: longitude),
      language: languageCode,
    );
    final isFail = response.status != lib_geocoding.GoogleResponseStatus.okay;

    if (isFail) {
      throw AppException(
        name: "MapsServiceImpl.reverseGeocoding",
        message: response.errorMessage ?? "Failed to reverse geocoding",
        error: response,
      );
    }

    final result = response.results.first;
    final placeId = result.placeId;
    final rawLocation = result.geometry.location;

    try {
      final Map<String, dynamic>? placeDetailResponseBody = includeDisplayName
          ? (await _newPlacesApiService.placeDetails(
              placeId,
              fieldMask: "displayName",
              languageCode: languageCode,
            ))
              .body
          : null;

      return LocationData(
        rawLocation.lat,
        rawLocation.lng,
        placeData: LocationPlaceData(
          id: result.placeId,
          address: result.formattedAddress,
          displayName: placeDetailResponseBody?["displayName"]["text"],
        ),
      );
    } on ChopperHttpException catch (exception, trace) {
      throw handleApiErrorResponse(exception, trace);
    } catch (error, trace) {
      throw error.toAppException(
        message: "Failed to reverse geocoding",
        trace: trace,
      );
    }
  }

  @override
  Future<List<LocationData>> searchPlace(
    String query, {
    String? languageCode,
  }) async {
    try {
      final response = await _newPlacesApiService.textSearch(
        fieldMask: "places.id,"
            "places.displayName,"
            "places.location,"
            "places.formattedAddress",
        body: {
          "textQuery": query,
          if (languageCode?.isNotEmpty ?? false) "languageCode": languageCode,
        },
      );
      final rawResponseBody = response.body!;
      final List rawResults = rawResponseBody["places"] ?? [];

      return rawResults.map((e) {
        final placeId = (e as Map)["id"] as String;
        final location = e["location"] as Map<String, dynamic>;
        final formattedAddress = e["formattedAddress"] as String;
        final displayName = e["displayName"]["text"] as String;

        return LocationData(
          location["latitude"] ?? 0.0,
          location["longitude"] ?? 0.0,
          placeData: LocationPlaceData(
            id: placeId,
            address: formattedAddress,
            displayName: displayName,
          ),
        );
      }).toList();
    } on ChopperHttpException catch (exception, trace) {
      throw handleApiErrorResponse(exception, trace);
    } catch (error, trace) {
      throw error.toAppException(
        message: "Failed to search place",
        trace: trace,
      );
    }
  }

  /// Request location service permission.
  Future<void> _requestLocationService() async {
    bool isEnabled = await _locationService.serviceEnabled();
    lib_location.PermissionStatus permissionStatus =
        await _locationService.hasPermission();

    bool isPermissionGranted =
        permissionStatus == lib_location.PermissionStatus.granted ||
            permissionStatus == lib_location.PermissionStatus.grantedLimited;

    if (isEnabled && isPermissionGranted) return;

    final isRequestServiceSuccess = await _locationService.requestService();

    if (!isRequestServiceSuccess) {
      throw const AppException(
        name: "MapsServiceImpl._requestLocationService",
        message: "Failed to request location service",
      );
    }

    final newPermissionStatus = await _locationService.requestPermission();

    switch (newPermissionStatus) {
      case lib_location.PermissionStatus.denied:
      case lib_location.PermissionStatus.deniedForever:
        throw const AppException(
          name: "MapsServiceImpl._requestLocationService",
          message: "Location service permission is denied",
        );
      default:
        break;
    }
  }
}
