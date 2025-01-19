import "package:chopper/chopper.dart";
import "package:flutter/foundation.dart";
import "package:injectable/injectable.dart";

import "libs/constants.dart";

export "libs/clients.dart";
export "libs/utils.dart";
export "modules/google_maps_new_places_remote_data.dart";
export "modules/auth_remote_data.dart";
export "modules/stories_remote_data.dart";

@module
abstract class RemoteDataModules {
  @lazySingleton
  ChopperClient getRemoteDataClient() {
    return ChopperClient(
      baseUrl: Uri.tryParse(kApiBaseUrl),
      converter: const JsonConverter(),
      errorConverter: const JsonConverter(),
      interceptors: kDebugMode
          ? [
              HttpLoggingInterceptor(
                level: Level.basic,
                logger: chopperLogger,
              ),
            ]
          : null,
    );
  }
}
