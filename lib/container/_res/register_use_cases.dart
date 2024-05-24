part of '../container.dart';

void _registerUseCases() {
  _locator
    // auth
    ..registerLazySingleton(() => LoginCase(get()))
    ..registerLazySingleton(() => RegisterCase(get()))
    ..registerLazySingleton(() => GetLoginSessionCase(get()))
    ..registerLazySingleton(() => LogoutCase(get()))

    // maps
    ..registerLazySingleton(() => GeocodingCase(get()))
    ..registerLazySingleton(() => GetLocationCase(get()))
    ..registerLazySingleton(() => ReverseGeocodingCase(get()))
    ..registerLazySingleton(() => SearchPlaceCase(get()))

    // stories
    ..registerLazySingleton(() {
      return GetStoriesCase(
        storiesRepo: get(),
        gMapsRepo: get(),
      );
    })
    ..registerLazySingleton(() {
      return GetStoryDetailCase(
        storiesRepo: get(),
        gMapsRepo: get(),
      );
    })
    ..registerLazySingleton(() => PostStoryCase(get()));
}
