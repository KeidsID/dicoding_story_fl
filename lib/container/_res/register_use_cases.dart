part of "../container.dart";

void _registerUseCases() {
  _locator
    // auth
    ..registerLazySingleton(() => LoginCase(get()))
    ..registerLazySingleton(() => RegisterCase(get()))
    ..registerLazySingleton(() => GetLoginSessionCase(get()))
    ..registerLazySingleton(() => LogoutCase(get()))

    // stories
    ..registerLazySingleton(() => GetStoriesCase(get()))
    ..registerLazySingleton(() => GetStoryDetailCase(get()))
    ..registerLazySingleton(() => PostStoryCase(get()));
}
