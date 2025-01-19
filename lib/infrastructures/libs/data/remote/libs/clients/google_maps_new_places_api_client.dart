import "package:chopper/chopper.dart";
import "package:flutter/foundation.dart";

/// https://developers.google.com/maps/documentation/places/web-service/overview#places-api-new
final class GoogleMapsNewPlacesApiClient extends ChopperClient {
  GoogleMapsNewPlacesApiClient({
    required String apiKey,
    super.client,
    super.authenticator,
    super.services,
  }) : super(
          baseUrl: Uri.tryParse("https://places.googleapis.com/v1"),
          converter: const JsonConverter(),
          errorConverter: const JsonConverter(),
          interceptors: [
            if (kDebugMode)
              HttpLoggingInterceptor(
                level: Level.basic,
                logger: chopperLogger,
              ),
            HeadersInterceptor({"X-Goog-Api-Key": apiKey}),
          ],
        );
}
