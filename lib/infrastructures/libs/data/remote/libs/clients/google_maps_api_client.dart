import "dart:async";

import "package:chopper/chopper.dart";
import "package:flutter/foundation.dart";

final class GoogleMapsApiClient extends ChopperClient {
  GoogleMapsApiClient({
    required GoogleMapsApiClientType type,
    required String apiKey,
    String? bundleId,
    String? androidSHA,
    super.client,
    super.authenticator,
    super.services,
  }) : super(
          baseUrl: Uri.tryParse(switch (type) {
            GoogleMapsApiClientType.geocoding =>
              "https://maps.googleapis.com/maps/api/geocode",
            GoogleMapsApiClientType.newPlaces =>
              "https://places.googleapis.com/v1",
          }),
          converter: const JsonConverter(),
          errorConverter: const JsonConverter(),
          interceptors: [
            if (kDebugMode)
              HttpLoggingInterceptor(
                level: Level.basic,
                logger: chopperLogger,
              ),
            //
            _GoogleMapsApiClientApiKeyInterceptor(apiKey, type),
            HeadersInterceptor({
              if (!kIsWeb) ...{
                if (defaultTargetPlatform == TargetPlatform.android) ...{
                  "X-Android-Package": bundleId ?? "-",
                  "X-Android-Cert": androidSHA ?? "-",
                },
                if (defaultTargetPlatform == TargetPlatform.iOS)
                  "X-Ios-Bundle-Identifier": bundleId ?? "-",
              }
            }),
          ],
        );
}

/// Determine which API to use on [GoogleMapsApiClient]
enum GoogleMapsApiClientType {
  /// https://developers.google.com/maps/documentation/geocoding/overview
  geocoding,

  /// https://developers.google.com/maps/documentation/places/web-service/overview#places-api-new
  newPlaces,
}

class _GoogleMapsApiClientApiKeyInterceptor implements Interceptor {
  const _GoogleMapsApiClientApiKeyInterceptor(this.apiKey, this.clientType);

  final String apiKey;
  final GoogleMapsApiClientType clientType;

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(Chain<BodyType> chain) {
    final req = chain.request;
    final isGeocoding = clientType == GoogleMapsApiClientType.geocoding;

    return chain.proceed(req.copyWith(
      headers: {
        if (!isGeocoding) "X-Goog-Api-Key": apiKey,
        ...req.headers,
      },
      parameters: {
        if (isGeocoding) "key": apiKey,
        ...req.parameters,
      },
    ));
  }
}
