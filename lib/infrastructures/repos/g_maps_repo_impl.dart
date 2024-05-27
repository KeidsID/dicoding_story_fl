import 'package:chopper/chopper.dart';
import 'package:dicoding_story_fl/common/utils.dart';
import 'package:dicoding_story_fl/infrastructures/utils/on_error_response_mixin.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_google_maps_webservices/geocoding.dart';
import 'package:location/location.dart' as loc_lib;

import 'package:dicoding_story_fl/common/envs.dart';
import 'package:dicoding_story_fl/core/entities.dart';
import 'package:dicoding_story_fl/core/repos.dart';
import 'package:dicoding_story_fl/infrastructures/api/responses.dart';

part 'g_maps_repo_impl.chopper.dart';

class GMapsRepoImpl with OnErrorResponseMixin implements GMapsRepo {
  GMapsRepoImpl()
      : _newPlacesApi =
            GMapsNewPlacesApiService.create(GMapsNewPlacesApiClient());

  final GMapsNewPlacesApiService _newPlacesApi;

  static String get apiKey {
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
    final loc = loc_lib.Location.instance;

    bool isEnabled = await loc.serviceEnabled();
    loc_lib.PermissionStatus permissionStatus = await loc.hasPermission();

    if (!isEnabled) {
      isEnabled = await loc.requestService();

      if (!isEnabled) {
        throw const SimpleException(
          name: 'Location Service Disabled',
          message: 'Please enable location service',
        );
      }
    }

    switch (permissionStatus) {
      case loc_lib.PermissionStatus.denied:
      case loc_lib.PermissionStatus.deniedForever:
        permissionStatus = await loc.requestPermission();

        switch (permissionStatus) {
          case loc_lib.PermissionStatus.denied:
          case loc_lib.PermissionStatus.deniedForever:
            throw const SimpleException(
              name: 'Permission Denied',
              message: 'Please grant permission to access location',
            );
          default:
        }
        break;
      default:
    }
  }

  @override
  Future<LocationCore> getLocation() async {
    await _requestLocService();

    final location = await loc_lib.Location.instance.getLocation();

    return LocationCore(location.latitude ?? 0, location.longitude ?? 0);
  }

  @override
  Future<List<LocationCore>> searchPlace(String query) async {
    try {
      final rawRes = await _newPlacesApi.textSearch(
        apiKey: apiKey,
        fieldMask: 'places.id,places.displayName,'
            'places.location,places.formattedAddress',
        body: {'textQuery': query},
      );
      final rawResBody = rawRes.body;

      if (rawResBody == null) throw onErrorResponse(rawRes);

      final rawResults = rawResBody['places'];

      if (rawResults is! List) return [];

      final results = rawResults.map((e) => GMapsPlace.fromJson(e));

      return results.map((e) {
        final location = e.location;

        return LocationCore(
          location?.latitude ?? 0.0,
          location?.longitude ?? 0.0,
          placeDetail: PlaceCore(
            e.id ?? '?',
            address: e.formattedAddress,
            displayName: e.displayName?.text,
          ),
        );
      }).toList();
    } catch (err, trace) {
      throw err.toSimpleException(trace: trace);
    }
  }

  @override
  Future<LocationCore> geocoding(String address) async {
    final api = GoogleMapsGeocoding(apiKey: apiKey);

    final res = await api.searchByAddress(address);

    if (!(res.status == GoogleResponseStatus.okay)) {
      final code = res.status == GoogleResponseStatus.notFound ? 404 : 500;

      throw SimpleHttpException(
        statusCode: code,
        message: res.errorMessage ?? 'Something went wrong',
        error: res,
        trace: StackTrace.current,
      );
    }

    final result = res.results.first;
    final geoResult = result.geometry.location;

    return LocationCore(
      geoResult.lat,
      geoResult.lng,
      placeDetail: PlaceCore(
        result.placeId,
        address: result.formattedAddress,
      ),
    );
  }

  @override
  Future<LocationCore> reverseGeocoding(LocationCore location) async {
    final api = GoogleMapsGeocoding(apiKey: apiKey);

    final res = await api.searchByLocation(Location(
      lat: location.lat,
      lng: location.lon,
    ));

    if (!(res.status == GoogleResponseStatus.okay)) {
      final code = res.status == GoogleResponseStatus.notFound ? 404 : 500;

      throw SimpleHttpException(
        statusCode: code,
        message: res.errorMessage ?? 'Something went wrong',
        error: res,
        trace: StackTrace.current,
      );
    }

    final result = res.results.first;

    return LocationCore(
      result.geometry.location.lat,
      result.geometry.location.lng,
      placeDetail: PlaceCore(result.placeId, address: result.formattedAddress),
    );
  }
}

final class GMapsNewPlacesApiClient extends ChopperClient {
  GMapsNewPlacesApiClient({
    super.client,
    super.authenticator,
    super.services,
  }) : super(
          baseUrl: Uri.tryParse('https://places.googleapis.com/v1'),
          converter: const JsonConverter(),
          errorConverter: const JsonConverter(),
          interceptors: !kDebugMode
              ? []
              : [
                  HttpLoggingInterceptor(
                      level: Level.basic, logger: chopperLogger)
                ],
        );
}

/// [create] the service with [GMapsNewPlacesApiClient].
@chopperApi
abstract class GMapsNewPlacesApiService extends ChopperService {
  static GMapsNewPlacesApiService create([ChopperClient? client]) =>
      _$GMapsNewPlacesApiService(client);

  /// A [Text Search (New)](https://developers.google.com/maps/documentation/places/web-service/text-search)
  /// Returns information about a set of places based on a string — for example
  /// "pizza in New York" or "shoe stores near Ottawa" or "123 Main Street".
  /// The service responds with a list of places matching the text string and
  /// any location bias that has been set.
  ///
  /// Headers:
  ///
  /// - String, [apiKey] : An API key that gives you access to Places API.
  /// - Comma-separated string, [fieldMask] :
  ///
  ///   Specify the list of fields to return in the response by creating a
  ///   response field mask.
  ///
  ///   Field masking is a good design practice to ensure that you don't request
  ///   unnecessary data, which helps to avoid unnecessary processing time and
  ///   billing charges.
  ///
  ///   Specify a comma-separated list of place data types to return. For
  ///   example, to retrieve the display name and the address of the place.
  ///
  ///   `places.displayName,places.formattedAddress`
  ///
  ///   Specify `*` to retrieve all fields. Not recommended because of the large
  ///   amount of data that can be returned.
  ///
  ///   Read docs here for more field mask options:
  ///   https://developers.google.com/maps/documentation/places/web-service/text-search#fieldmask
  ///
  /// [body] representation:
  ///
  /// ```json
  /// {
  ///   "textQuery": required string,
  ///   "languageCode": string,
  ///   "pageSize": integer,
  ///   "pageToken": string,
  /// }
  /// ```
  ///
  /// Visit [`places.searchText` reference](https://developers.google.com/maps/documentation/places/web-service/reference/rest/v1/places/searchText)
  /// for more details about [body].
  ///
  @Post(path: '/places:searchText')
  Future<Response<Map<String, dynamic>>> textSearch({
    @Header('X-Goog-Api-Key') required String apiKey,
    @Header('X-Goog-FieldMask') required String fieldMask,
    @body required Map<String, dynamic> body,
  });
}
