import "package:chopper/chopper.dart";
import "package:flutter/foundation.dart";
import "package:injectable/injectable.dart";
import "package:location/location.dart" as lib_location;
import "package:package_info_plus/package_info_plus.dart";

import "package:dicoding_story_fl/domain/entities.dart";
import "package:dicoding_story_fl/domain/services.dart";
import "package:dicoding_story_fl/infrastructures/libs/data/remote/modules.dart";
import "package:dicoding_story_fl/libs/extensions.dart";
import "package:dicoding_story_fl/infrastructures/libs/constants.dart"
    show GoogleMapsApiKeys;

@LazySingleton(as: MapsService)
final class MapsServiceImpl implements MapsService {
  MapsServiceImpl(this._packageInfo, this._configService);

  final PackageInfo _packageInfo;

  final ConfigService _configService;

  lib_location.Location get _locationService => lib_location.Location.instance;
  GoogleMapsGeocodingRemoteData get _geocodingService {
    return _geocodingServiceInstance ??= GoogleMapsGeocodingRemoteData.create(
      _googleMapsApiKey,
      bundleId: _packageInfo.packageName,
      androidSHA: _packageInfo.buildSignature,
    );
  }

  /// This act as a singleton state.
  ///
  /// Use [_geocodingService] instead.
  GoogleMapsGeocodingRemoteData? _geocodingServiceInstance;

  GeocodingProxyRemoteData get _geocodingProxyService {
    return _geocodingProxyServiceInstance ??=
        GeocodingProxyRemoteData.create(_configService);
  }

  /// This act as a singleton state.
  ///
  /// Use [_geocodingProxyService] instead.
  GeocodingProxyRemoteData? _geocodingProxyServiceInstance;

  GoogleMapsNewPlacesRemoteData get _newPlacesApiService {
    return _newPlacesApiServiceInstance ??=
        GoogleMapsNewPlacesRemoteData.create(
      apiKey: _googleMapsApiKey,
      bundleId: _packageInfo.packageName,
      androidSHA: _packageInfo.buildSignature,
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
    try {
      final response = await (kDebugMode
          ? _geocodingService.geocoding(
              address,
              languageCode: languageCode,
            )
          : _geocodingProxyService.geocoding(
              address,
              languageCode: languageCode,
            ));
      final responseBody = response.body!;

      final results = responseBody["results"] as List;
      final result = results.first as Map<String, dynamic>;

      final rawLocation =
          result["geometry"]["location"] as Map<String, dynamic>;
      final latitude = rawLocation["lat"] as double;
      final longitude = rawLocation["lng"] as double;
      final placeId = result["place_id"] as String;
      final formattedAddress = result["formatted_address"] as String;

      return LocationData(
        latitude,
        longitude,
        placeData: LocationPlaceData(
          id: placeId,
          address: formattedAddress,
        ),
      );
    } on ChopperHttpException catch (exception, trace) {
      throw handleApiErrorResponse(exception, trace);
    } catch (error, trace) {
      throw error.toAppException(
        message: "Failed to geocoding",
        trace: trace,
      );
    }
  }

  @override
  Future<LocationData> reverseGeocoding(
    double latitude,
    double longitude, {
    String? languageCode,
    bool includeDisplayName = true,
  }) async {
    try {
      final response = await (kDebugMode
          ? _geocodingService.reverseGeocoding(
              "$latitude,$longitude",
              languageCode: languageCode,
            )
          : _geocodingProxyService.reverseGeocoding(
              "$latitude",
              "$longitude",
              languageCode: languageCode,
            ));
      final responseBody = response.body!;

      final results = responseBody["results"] as List;
      final result = results.first as Map<String, dynamic>;

      final rawLocation =
          result["geometry"]["location"] as Map<String, dynamic>;
      final lat = rawLocation["lat"] as double;
      final lon = rawLocation["lng"] as double;
      final placeId = result["place_id"] as String?;
      final formattedAddress = result["formatted_address"] as String;

      final Map<String, dynamic>? placeDetailResponseBody =
          includeDisplayName && placeId != null
              ? (await _newPlacesApiService.placeDetails(
                  placeId,
                  fieldMask: "displayName",
                  languageCode: languageCode,
                ))
                  .body
              : null;

      final displayName =
          placeDetailResponseBody?["displayName"]["text"] as String?;

      return LocationData(
        lat,
        lon,
        placeData: placeId == null
            ? null
            : LocationPlaceData(
                id: placeId,
                address: formattedAddress,
                displayName: displayName,
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
